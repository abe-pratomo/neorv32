#include <neorv32.h>
#include <stdint.h>
#include <neorv32_cust_annx.h>
#include <neorv32_q16_helper.h>

#define BAUD_RATE 19200

// ============================================================
// Q16.16 constants
// ============================================================
#define EXP_MIN_INPUT  ((int32_t)(-726817))
#define EXP_MAX_INPUT  ((int32_t)( 681391))
#define INT32_MAX_VAL  ((int32_t)0x7FFFFFFF)
#define FRAC_WIDTH     16

// ============================================================
// Lookup tables
// ============================================================
static const int32_t BOUNDARY[31] = {
    -682810, -638804, -594797, -550791, -506784, -462778, -418771, -374765, -330758,
    -286752, -242745, -198739, -154732, -110726,  -66719,  -22713,   21294,   65300,
     109307,  153313,  197320,  241326,  285333,  329339,  373346,  417352,  461359,
     505365,  549372,  593378,  637385
};

static const int32_t SLOPE[32] = {
           1,         3,         5,        11,        21,        41,        80,       156,
         305,       596,      1167,      2283,      4469,      8746,     17117,     33500,
       65564,    128317,    251135,    491508,    961951,   1882676,   3684668,   7211420,
    14113789,  27622694,  54061598, 105806239, 207078075, 405281257, 793193895, 1552405946
};

static const int64_t INTERCEPT[32] = {
           17LL,         31LL,         56LL,        103LL,         188LL,         341LL,         615LL,         1099LL,
         1946LL,       3409LL,       5888LL,       9991LL,       16553LL,       26524LL,       40417LL,        56608LL,
        66765LL,      44505LL,     -81530LL,    -489607LL,    -1604168LL,    -4403777LL,   -11093028LL,    -26553003LL,
    -61445264LL, -138805384LL, -307963746LL, -673776302LL, -1457727373LL, -3125120666LL, -6648930289LL, -14055439078LL
};

// ============================================================
// exp_sw: Q16.16 piecewise-linear exp approximation
// Matches acc_core.vhd exactly
// ============================================================
int32_t exp_sw(int32_t x)
{
    if (x <= EXP_MIN_INPUT)
        return 0;

    if (x >= EXP_MAX_INPUT)
        return INT32_MAX_VAL;

    // Find segment
    int32_t m = SLOPE[31];
    int64_t b = INTERCEPT[31];

    for (int i = 0; i < 31; i++) {
        if (x < BOUNDARY[i]) {
            m = SLOPE[i];
            b = INTERCEPT[i];
            break;
        }
    }

    int64_t mult     = (int64_t)m * (int64_t)x;
    int64_t result64 = (mult >> FRAC_WIDTH) + b;

    if (result64 <= 0)
        return 0;
    else if (result64 >= (int64_t)INT32_MAX_VAL)
        return INT32_MAX_VAL;
    else
        return (int32_t)result64;
}

// ============================================================
// sigmoid_sw: sigma(x) = exp(x) / (1 + exp(x)) in Q16.16
// ============================================================
int32_t sigmoid_sw(int32_t x)
{
    int32_t exp_x  = exp_sw(x);
    int64_t num    = (int64_t)exp_x << FRAC_WIDTH;
    int64_t denom  = (int64_t)65536 + (int64_t)exp_x;
    return (int32_t)(num / denom);
}

// ============================================================
// sigmoid_hw: sigma(x) = exp(x) / (1 + exp(x)) in Q16.16
// ============================================================
int32_t sigmoid_hw(int32_t x)
{
    int32_t exp_x  = annx_exp(x);
    int64_t num    = (int64_t)exp_x << FRAC_WIDTH;
    int64_t denom  = (int64_t)65536 + (int64_t)exp_x;
    return (int32_t)(num / denom);
}

// ============================================================
// ANN Specifications
// ============================================================
#define input_layer     4

#define h1_neuron       5
#define h2_neuron       5
#define o_neuron        2

#define bias_count      1

// Inputs (ASAM, MANIS, ASIN, PEDAS, ranging from 0-1)
int32_t inputs[6][input_layer] = {
    {13107, 52428, 45875, 19660},  // Mie Goreng  - Expected: Tasty
    {65536, 13107, 19660, 19660},  // Sayur Asem  - Expected: Not Tasty
    {39321, 39321, 19660, 52428},  // Pecel       - Expected: Not Tasty
    {19660, 52428, 19660, 32768},  // Nasi Goreng - Expected: Tasty
    {39321, 58982, 32768, 39321},  // Tahu Campur - Expected: Tasty
    {19660, 13107, 39321, 65536},  // Dendeng     - Expected: Not Tasty
};

// Hidden layer 1 weights
int32_t h1_weights[h1_neuron][input_layer] = {
    { -95077,  196632,   65621, -110763},   // neuron 0
    { -18761,  -39271,  -44711,   51870},   // neuron 1
    {  66946, -145054,  -60594,  149020},   // neuron 2
    { 162212, -262395,  -84996,  159926},   // neuron 3
    { -54345,  103757,    -604,  -65649}    // neuron 4
};

// Hidden layer 1 biases
int32_t h1_biases[h1_neuron] = {
    -29561, -34029, -21527, 15558, 17376
};

// Hidden layer 1 outputs
int32_t h1_outputs_base[h1_neuron];

int32_t h1_outputs_annx[h1_neuron];

// Hidden layer 2 weights
int32_t h2_weights[h2_neuron][h1_neuron] = {
    {  78372,  -17407,  -67159, -192478,  63144},   // neuron 0
    {-242129,   17312,  187036,  248645, -80859},   // neuron 1
    { -63311,  -24329,   28451,   33987, -74799},   // neuron 2
    { 100652,  -56535,  -47128, -150446,  61123},   // neuron 3
    {  44358,  -24475,  -68997, -121661,  88419}    // neuron 4
};

// Hidden layer 2 biases
int32_t h2_biases[h2_neuron] = {
    43618, -31781, 40982, 14507, 13483
};

// Hidden layer 2 outputs
int32_t h2_outputs_base[h2_neuron];

int32_t h2_outputs_annx[h2_neuron];

// Output layer weights
int32_t o_weights[o_neuron][h2_neuron] = {
    { 144148, -320594, -103031,  138344,  128838},  // output 0 (Tastiness)
    {-177383,  335431,    9901, -148999,  -97330}   // output 1 (Untastiness)
};

int32_t o_biases[o_neuron] = {
    20998, 18766
};

int32_t outputs_base[o_neuron];

int32_t outputs_annx[o_neuron];

int main() {
    // Initialize UART at 19200 baud
    if (!neorv32_uart0_available()) return -1;
    neorv32_uart0_setup(BAUD_RATE, 0);

    // Print banner
    neorv32_uart0_printf("================ NEORV32 ANN Example ===============\n");
    neorv32_uart0_printf("=== ANN for Indonesian Food Preference Detection ===\n");
    neorv32_uart0_printf("====================================================\n\n");

    for (int input_select = 0; input_select < 6; input_select++) {
        // Print food
        neorv32_uart0_printf("Food: ");
        switch (input_select) {
            case 0: neorv32_uart0_printf("Mie Goreng;  EXPECTED: Tasty    :\n"); break;
            case 1: neorv32_uart0_printf("Sayur Asem;  EXPECTED: Not Tasty:\n"); break;
            case 2: neorv32_uart0_printf("Pecel;       EXPECTED: Not Tasty:\n"); break;
            case 3: neorv32_uart0_printf("Nasi Goreng; EXPECTED: Tasty    :\n"); break;
            case 4: neorv32_uart0_printf("Tahu Campur; EXPECTED: Tasty    :\n"); break;
            case 5: neorv32_uart0_printf("Dendeng;     EXPECTED: Not Tasty:\n"); break;
        }

        // Start calculation
        uint32_t start_time_base = neorv32_cpu_csr_read(CSR_CYCLE);

        // Hidden Layer 1 computation
        for (int i = 0; i < h1_neuron; i++) {
            int64_t sum = 0;
            for (int j = 0; j < input_layer; j++) {
                sum += ((int64_t)inputs[input_select][j] * (int64_t)h1_weights[i][j]) >> FRAC_WIDTH;
            }
            sum += h1_biases[i];

            h1_outputs_base[i] = sigmoid_sw((int32_t)sum);
        }

        // Hidden Layer 2 computation
        for (int i = 0; i < h2_neuron; i++) {
            int64_t sum = 0;
            for (int j = 0; j < h1_neuron; j++) {
                sum += ((int64_t)h1_outputs_base[j] * (int64_t)h2_weights[i][j]) >> FRAC_WIDTH;
            }
            sum += h2_biases[i];

            h2_outputs_base[i] = sigmoid_sw((int32_t)sum);
        }

        // Output Layer computation
        for (int i = 0; i < o_neuron; i++) {
            int64_t sum = 0;
            for (int j = 0; j < h2_neuron; j++) {
                sum += ((int64_t)h2_outputs_base[j] * (int64_t)o_weights[i][j]) >> FRAC_WIDTH;
            }
            sum += o_biases[i];

            outputs_base[i] = sigmoid_sw((int32_t)sum);
        }

        // End calculation
        uint32_t end_time_base      = neorv32_cpu_csr_read(CSR_CYCLE);
        uint32_t elapsed_cycle_base = end_time_base - start_time_base;

        // Start calculation
        uint32_t start_time_annx = neorv32_cpu_csr_read(CSR_CYCLE);

        // --------------------------------------------------------
        // Hidden Layer 1
        // --------------------------------------------------------
        uint32_t bbase = (uint32_t)h1_biases;
        int32_t in  = 0;
        int32_t sum = 0;

        // Neuron 1
        uint32_t wbase = (uint32_t)h1_weights[0];
        in = inputs[input_select][0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = inputs[input_select][1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = inputs[input_select][2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = inputs[input_select][3]; in = annx_lwm(wbase, in, 3); sum += in;
        sum = annx_lwa(bbase, sum, 0); h1_outputs_annx[0] = sigmoid_hw(sum);

        // Neuron 2
        wbase = (uint32_t)h1_weights[1]; sum = 0;
        in = inputs[input_select][0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = inputs[input_select][1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = inputs[input_select][2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = inputs[input_select][3]; in = annx_lwm(wbase, in, 3); sum += in;
        sum = annx_lwa(bbase, sum, 1); h1_outputs_annx[1] = sigmoid_hw(sum);

        // Neuron 3
        wbase = (uint32_t)h1_weights[2]; sum = 0;
        in = inputs[input_select][0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = inputs[input_select][1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = inputs[input_select][2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = inputs[input_select][3]; in = annx_lwm(wbase, in, 3); sum += in;
        sum = annx_lwa(bbase, sum, 2); h1_outputs_annx[2] = sigmoid_hw(sum);

        // Neuron 4
        wbase = (uint32_t)h1_weights[3]; sum = 0;
        in = inputs[input_select][0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = inputs[input_select][1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = inputs[input_select][2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = inputs[input_select][3]; in = annx_lwm(wbase, in, 3); sum += in;
        sum = annx_lwa(bbase, sum, 3); h1_outputs_annx[3] = sigmoid_hw(sum);

        // Neuron 5
        wbase = (uint32_t)h1_weights[4]; sum = 0;
        in = inputs[input_select][0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = inputs[input_select][1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = inputs[input_select][2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = inputs[input_select][3]; in = annx_lwm(wbase, in, 3); sum += in;
        sum = annx_lwa(bbase, sum, 4); h1_outputs_annx[4] = sigmoid_hw(sum);

        // --------------------------------------------------------
        // Hidden Layer 2
        // --------------------------------------------------------
        bbase = (uint32_t)h2_biases;
        sum = 0;

        // Neuron 1
        wbase = (uint32_t)h2_weights[0];
        in = h1_outputs_annx[0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = h1_outputs_annx[1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = h1_outputs_annx[2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = h1_outputs_annx[3]; in = annx_lwm(wbase, in, 3); sum += in;
        in = h1_outputs_annx[4]; in = annx_lwm(wbase, in, 4); sum += in;
        sum = annx_lwa(bbase, sum, 0); h2_outputs_annx[0] = sigmoid_hw(sum);

        // Neuron 2
        wbase = (uint32_t)h2_weights[1]; sum = 0;
        in = h1_outputs_annx[0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = h1_outputs_annx[1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = h1_outputs_annx[2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = h1_outputs_annx[3]; in = annx_lwm(wbase, in, 3); sum += in;
        in = h1_outputs_annx[4]; in = annx_lwm(wbase, in, 4); sum += in;
        sum = annx_lwa(bbase, sum, 1); h2_outputs_annx[1] = sigmoid_hw(sum);

        // Neuron 3
        wbase = (uint32_t)h2_weights[2]; sum = 0;
        in = h1_outputs_annx[0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = h1_outputs_annx[1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = h1_outputs_annx[2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = h1_outputs_annx[3]; in = annx_lwm(wbase, in, 3); sum += in;
        in = h1_outputs_annx[4]; in = annx_lwm(wbase, in, 4); sum += in;
        sum = annx_lwa(bbase, sum, 2); h2_outputs_annx[2] = sigmoid_hw(sum);

        // Neuron 4
        wbase = (uint32_t)h2_weights[3]; sum = 0;
        in = h1_outputs_annx[0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = h1_outputs_annx[1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = h1_outputs_annx[2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = h1_outputs_annx[3]; in = annx_lwm(wbase, in, 3); sum += in;
        in = h1_outputs_annx[4]; in = annx_lwm(wbase, in, 4); sum += in;
        sum = annx_lwa(bbase, sum, 3); h2_outputs_annx[3] = sigmoid_hw(sum);

        // Neuron 5
        wbase = (uint32_t)h2_weights[4]; sum = 0;
        in = h1_outputs_annx[0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = h1_outputs_annx[1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = h1_outputs_annx[2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = h1_outputs_annx[3]; in = annx_lwm(wbase, in, 3); sum += in;
        in = h1_outputs_annx[4]; in = annx_lwm(wbase, in, 4); sum += in;
        sum = annx_lwa(bbase, sum, 4); h2_outputs_annx[4] = sigmoid_hw(sum);

        // --------------------------------------------------------
        // Output Layer
        // --------------------------------------------------------
        bbase = (uint32_t)o_biases;
        sum = 0;

        // Neuron 1
        wbase = (uint32_t)o_weights[0];
        in = h2_outputs_annx[0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = h2_outputs_annx[1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = h2_outputs_annx[2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = h2_outputs_annx[3]; in = annx_lwm(wbase, in, 3); sum += in;
        in = h2_outputs_annx[4]; in = annx_lwm(wbase, in, 4); sum += in;
        sum = annx_lwa(bbase, sum, 0); outputs_annx[0] = sigmoid_hw(sum);

        // Neuron 2
        wbase = (uint32_t)o_weights[1]; sum = 0;
        in = h2_outputs_annx[0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = h2_outputs_annx[1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = h2_outputs_annx[2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = h2_outputs_annx[3]; in = annx_lwm(wbase, in, 3); sum += in;
        in = h2_outputs_annx[4]; in = annx_lwm(wbase, in, 4); sum += in;
        sum = annx_lwa(bbase, sum, 1); outputs_annx[1] = sigmoid_hw(sum);

        // End calculation
        uint32_t end_time_annx      = neorv32_cpu_csr_read(CSR_CYCLE);
        uint32_t elapsed_cycle_annx = end_time_annx - start_time_annx;

        // Print results
        neorv32_uart0_printf("  Base:\n    ");
        for (int i = 0; i < o_neuron; i++) {
            neorv32_uart0_printf("%s: ", i ? "Untastiness" : "Tastiness  "); print_q16(outputs_base[i]); neorv32_uart0_printf("; ");
        }
        neorv32_uart0_printf("%s; ", (outputs_base[0] > outputs_base[1]) ? "Tasty    " : "Not Tasty"); neorv32_uart0_printf("Elapsed Time: %u cycles\n", elapsed_cycle_base);

        neorv32_uart0_printf("  ANNX:\n    ");
        for (int i = 0; i < o_neuron; i++) {
            neorv32_uart0_printf("%s: ", i ? "Untastiness" : "Tastiness  "); print_q16(outputs_base[i]); neorv32_uart0_printf("; ");
        }
        neorv32_uart0_printf("%s; ", (outputs_annx[0] > outputs_annx[1]) ? "Tasty    " : "Not Tasty"); neorv32_uart0_printf("Elapsed Time: %u cycles\n", elapsed_cycle_annx);
    }

    // Finish execution
    neorv32_uart0_printf("\n===================== THE END ======================\n");
    neorv32_uart0_printf("====================================================\n\n");
    return 0;
}