#include <neorv32.h>
#include <stdint.h>
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
// exp_pwl: Q16.16 piecewise-linear exp approximation
// Matches acc_core.vhd exactly
// ============================================================
int32_t exp_pwl(int32_t x)
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
// sigmoid_q16: sigma(x) = exp(x) / (1 + exp(x)) in Q16.16
// Requires M extension for division
// ============================================================
int32_t sigmoid_q16(int32_t x)
{
    int32_t exp_x  = exp_pwl(x);
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
#define bias_multiplier 0x10000

#define l1_inputs       (input_layer    + bias_count)
#define l2_inputs       (h1_neuron      + bias_count)
#define l3_inputs       (h2_neuron      + bias_count)

// Inputs (ASAM, MANIS, ASIN, PEDAS, ranging from 0-1)
int32_t inputs[l1_inputs] = {
    // 13107, 52428, 45875, 19660, 65536  // Mie Goreng  - Expected: Tasty
    // 65536, 13107, 19660, 19660, 65536  // Sayur Asem  - Expected: Not Tasty
    // 39321, 39321, 19660, 52428, 65536  // Pecel       - Expected: Not Tasty
    // 19660, 52428, 19660, 32768, 65536  // Nasi Goreng - Expected: Tasty
    // 39321, 58982, 32768, 39321, 65536  // Tahu Campur - Expected: Tasty
    19660, 13107, 39321, 65536, 65536  // Dendeng     - Expected: Not Tasty
};

// Hidden layer 1
int32_t h1_weights[l1_inputs][h1_neuron] = {
    { -95077, -18761,   66946,  162212, -54345},    // W1 row 1
    { 196632, -39271, -145054, -262395, 103757},    // W1 row 2
    {  65621, -44711,  -60594,  -84996,   -604},    // W1 row 3
    {-110763,  51870,  149020,  159926, -65649},    // W1 row 4
    { -29561, -34029,  -21527,   15558,  17376}     // b1
};

int32_t h1_outputs[l2_inputs] = {
    0, 0, 0, 0, 0, bias_multiplier
};

// Hidden layer 2 weights (5 neurons, 5 inputs + bias)
int32_t h2_weights[l2_inputs][h2_neuron] = {
    {  78372, -242129, -63311,  100652,   44358},   // W2 row 1
    { -17407,   17312, -24329,  -56535,  -24475},   // W2 row 2
    { -67159,  187036,  28451,  -47128,  -68997},   // W2 row 3
    {-192478,  248645,  33987, -150446, -121661},   // W2 row 4
    {  63144,  -80859, -74799,   61123,   88419},   // W2 row 5
    {  43618,  -31781,  40982,   14507,   13483}    // b2
};

int32_t h2_outputs[l3_inputs] = {
    0, 0, 0, 0, 0, bias_multiplier
};

// Output layer weights (2 neurons, 5 inputs + bias)
int32_t o_weights[l3_inputs][o_neuron] = {
    { 144148, -177383}, // W3 row 1
    {-320594,  335431}, // W3 row 2
    {-103031,    9901}, // W3 row 3
    { 138344, -148999}, // W3 row 4
    { 128838,  -97330}, // W3 row 5
    {  20998,   18766}  // b3
};

int32_t outputs[o_neuron];

int main() {
    // Get the actual CPU clock frequency
    uint32_t NEORV32_CLK = neorv32_sysinfo_get_clk();

    // Initialize UART at 19200 baud
    if (!neorv32_uart0_available()) return -1;
    neorv32_uart0_setup(BAUD_RATE, 0);

    // Print banner
    neorv32_uart0_printf("==== NEORV32 ANN (No M-Extension) Base Example =====\n");
    neorv32_uart0_printf("=== ANN for Indonesian Food Preference Detection ===\n");
    neorv32_uart0_printf("====================================================\n\n");

    // Print taste values
    neorv32_uart0_printf("Input Taste Values:\n");
    neorv32_uart0_printf("Sourness : "); print_q16(inputs[0]); neorv32_uart0_printf("\n");
    neorv32_uart0_printf("Sweetness: "); print_q16(inputs[1]); neorv32_uart0_printf("\n");
    neorv32_uart0_printf("Saltiness: "); print_q16(inputs[2]); neorv32_uart0_printf("\n");
    neorv32_uart0_printf("Spiciness: "); print_q16(inputs[3]); neorv32_uart0_printf("\n");

    // Start calculation
    uint32_t start_time = neorv32_cpu_csr_read(CSR_CYCLE);

    // Hidden Layer 1 computation
    for (int i = 0; i < h1_neuron; i++) {
        int64_t sum = 0;
        for (int j = 0; j < l1_inputs; j++) {
            sum += ((int64_t)inputs[j] * (int64_t)h1_weights[j][i]) >> FRAC_WIDTH;
        }
        h1_outputs[i] = sigmoid_q16((int32_t)sum);
    }

    // Hidden Layer 2 computation
    for (int i = 0; i < h2_neuron; i++) {
        int64_t sum = 0;
        for (int j = 0; j < l2_inputs; j++) {
            sum += ((int64_t)h1_outputs[j] * (int64_t)h2_weights[j][i]) >> FRAC_WIDTH;
        }
        h2_outputs[i] = sigmoid_q16((int32_t)sum);
    }

    // Output Layer computation
    for (int i = 0; i < o_neuron; i++) {
        int64_t sum = 0;
        for (int j = 0; j < l3_inputs; j++) {
            sum += ((int64_t)h2_outputs[j] * (int64_t)o_weights[j][i]) >> FRAC_WIDTH;
        }
        outputs[i] = sigmoid_q16((int32_t)sum);
    }

    // End calculation
    uint32_t end_time           = neorv32_cpu_csr_read(CSR_CYCLE);
    uint32_t elapsed_cycles     = end_time - start_time;
    uint32_t elapsed_time_ns    = (uint32_t)(((uint64_t)elapsed_cycles * 1000ULL) / (NEORV32_CLK / 1000000));

    // Print results
    neorv32_uart0_printf("\nOutput Values:\n");
    for (int i = 0; i < o_neuron; i++) {
        neorv32_uart0_printf("%s:", i ? "Untastiness" : "Tastiness  "); print_q16(outputs[i]); neorv32_uart0_printf("\n");
    }
    neorv32_uart0_printf("\nConclusion: %s\n", (outputs[0] > outputs[1]) ? "Tasty" : "Not Tasty");
    neorv32_uart0_printf("\nElapsed Time: %u cycles (%u ns)\n", elapsed_cycles, elapsed_time_ns);

    // Finish execution
    neorv32_uart0_printf("\n===================== THE END ======================\n");
    neorv32_uart0_printf("====================================================\n\n");
    return 0;
}