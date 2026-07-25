#include <neorv32.h>
#include <stdint.h>
#include <neorv32_cust_annx.h>
#include <neorv32_q16_helper.h>

#define BAUD_RATE 19200

#define FRAC_WIDTH     16

// ============================================================
// sigmoid using annx_exp hardware instruction
// ============================================================
int32_t sigmoid_q16(int32_t x)
{
    int32_t exp_x = annx_exp((uint32_t)x);
    int64_t num   = (int64_t)exp_x << FRAC_WIDTH;
    int64_t denom = (int64_t)65536 + (int64_t)exp_x;
    return (int32_t)(num / denom);
}

// ============================================================
// ANN Specifications
// ============================================================
#define input_select    0 // 0 = Mie Goreng, 1 = Sayur Asem, 2 = Pecel, 3 = Nasi Goreng, 4 = Tahu Campur, 5 = Dendeng

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
int32_t h1_outputs[h1_neuron] = {
    0, 0, 0, 0
};

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
int32_t h2_outputs[h2_neuron] = {
    0, 0, 0, 0
};

// Output layer weights
int32_t o_weights[o_neuron][h2_neuron] = {
    { 144148, -320594, -103031,  138344,  128838},  // output 0 (Tastiness)
    {-177383,  335431,    9901, -148999,  -97330}   // output 1 (Untastiness)
};

int32_t o_biases[o_neuron] = {
    20998, 18766
};

int32_t outputs[o_neuron];

int main() {
    // Get the actual CPU clock frequency
    uint32_t NEORV32_CLK = neorv32_sysinfo_get_clk();

    // Initialize UART at 19200 baud
    if (!neorv32_uart0_available()) return -1;
    neorv32_uart0_setup(BAUD_RATE, 0);

    // Print banner
    neorv32_uart0_printf("==== NEORV32 ANN ANNX (No M-Extension) Example =====\n");
    neorv32_uart0_printf("=== ANN for Indonesian Food Preference Detection ===\n");
    neorv32_uart0_printf("====================================================\n\n");

    // Print taste values
    neorv32_uart0_printf("Input Taste Values:\n");
    neorv32_uart0_printf("Sourness : "); print_q16(inputs[input_select][0]); neorv32_uart0_printf("\n");
    neorv32_uart0_printf("Sweetness: "); print_q16(inputs[input_select][1]); neorv32_uart0_printf("\n");
    neorv32_uart0_printf("Saltiness: "); print_q16(inputs[input_select][2]); neorv32_uart0_printf("\n");
    neorv32_uart0_printf("Spiciness: "); print_q16(inputs[input_select][3]); neorv32_uart0_printf("\n");

    // Start calculation
    uint32_t start_time = neorv32_cpu_csr_read(CSR_CYCLE);

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
    sum = annx_lwa(bbase, sum, 0); h1_outputs[0] = sigmoid_q16(sum);

    // Neuron 2
    wbase = (uint32_t)h1_weights[1]; sum = 0;
    in = inputs[input_select][0]; in = annx_lwm(wbase, in, 0); sum += in;
    in = inputs[input_select][1]; in = annx_lwm(wbase, in, 1); sum += in;
    in = inputs[input_select][2]; in = annx_lwm(wbase, in, 2); sum += in;
    in = inputs[input_select][3]; in = annx_lwm(wbase, in, 3); sum += in;
    sum = annx_lwa(bbase, sum, 1); h1_outputs[1] = sigmoid_q16(sum);

    // Neuron 3
    wbase = (uint32_t)h1_weights[2]; sum = 0;
    in = inputs[input_select][0]; in = annx_lwm(wbase, in, 0); sum += in;
    in = inputs[input_select][1]; in = annx_lwm(wbase, in, 1); sum += in;
    in = inputs[input_select][2]; in = annx_lwm(wbase, in, 2); sum += in;
    in = inputs[input_select][3]; in = annx_lwm(wbase, in, 3); sum += in;
    sum = annx_lwa(bbase, sum, 2); h1_outputs[2] = sigmoid_q16(sum);

    // Neuron 4
    wbase = (uint32_t)h1_weights[3]; sum = 0;
    in = inputs[input_select][0]; in = annx_lwm(wbase, in, 0); sum += in;
    in = inputs[input_select][1]; in = annx_lwm(wbase, in, 1); sum += in;
    in = inputs[input_select][2]; in = annx_lwm(wbase, in, 2); sum += in;
    in = inputs[input_select][3]; in = annx_lwm(wbase, in, 3); sum += in;
    sum = annx_lwa(bbase, sum, 3); h1_outputs[3] = sigmoid_q16(sum);

    // Neuron 5
    wbase = (uint32_t)h1_weights[4]; sum = 0;
    in = inputs[input_select][0]; in = annx_lwm(wbase, in, 0); sum += in;
    in = inputs[input_select][1]; in = annx_lwm(wbase, in, 1); sum += in;
    in = inputs[input_select][2]; in = annx_lwm(wbase, in, 2); sum += in;
    in = inputs[input_select][3]; in = annx_lwm(wbase, in, 3); sum += in;
    sum = annx_lwa(bbase, sum, 4); h1_outputs[4] = sigmoid_q16(sum);

    // --------------------------------------------------------
    // Hidden Layer 2
    // --------------------------------------------------------
    bbase = (uint32_t)h2_biases;
    sum = 0;

    // Neuron 1
    wbase = (uint32_t)h2_weights[0];
    in = h1_outputs[0]; in = annx_lwm(wbase, in, 0); sum += in;
    in = h1_outputs[1]; in = annx_lwm(wbase, in, 1); sum += in;
    in = h1_outputs[2]; in = annx_lwm(wbase, in, 2); sum += in;
    in = h1_outputs[3]; in = annx_lwm(wbase, in, 3); sum += in;
    in = h1_outputs[4]; in = annx_lwm(wbase, in, 4); sum += in;
    sum = annx_lwa(bbase, sum, 0); h2_outputs[0] = sigmoid_q16(sum);

    // Neuron 2
    wbase = (uint32_t)h2_weights[1]; sum = 0;
    in = h1_outputs[0]; in = annx_lwm(wbase, in, 0); sum += in;
    in = h1_outputs[1]; in = annx_lwm(wbase, in, 1); sum += in;
    in = h1_outputs[2]; in = annx_lwm(wbase, in, 2); sum += in;
    in = h1_outputs[3]; in = annx_lwm(wbase, in, 3); sum += in;
    in = h1_outputs[4]; in = annx_lwm(wbase, in, 4); sum += in;
    sum = annx_lwa(bbase, sum, 1); h2_outputs[1] = sigmoid_q16(sum);

    // Neuron 3
    wbase = (uint32_t)h2_weights[2]; sum = 0;
    in = h1_outputs[0]; in = annx_lwm(wbase, in, 0); sum += in;
    in = h1_outputs[1]; in = annx_lwm(wbase, in, 1); sum += in;
    in = h1_outputs[2]; in = annx_lwm(wbase, in, 2); sum += in;
    in = h1_outputs[3]; in = annx_lwm(wbase, in, 3); sum += in;
    in = h1_outputs[4]; in = annx_lwm(wbase, in, 4); sum += in;
    sum = annx_lwa(bbase, sum, 2); h2_outputs[2] = sigmoid_q16(sum);

    // Neuron 4
    wbase = (uint32_t)h2_weights[3]; sum = 0;
    in = h1_outputs[0]; in = annx_lwm(wbase, in, 0); sum += in;
    in = h1_outputs[1]; in = annx_lwm(wbase, in, 1); sum += in;
    in = h1_outputs[2]; in = annx_lwm(wbase, in, 2); sum += in;
    in = h1_outputs[3]; in = annx_lwm(wbase, in, 3); sum += in;
    in = h1_outputs[4]; in = annx_lwm(wbase, in, 4); sum += in;
    sum = annx_lwa(bbase, sum, 3); h2_outputs[3] = sigmoid_q16(sum);

    // Neuron 5
    wbase = (uint32_t)h2_weights[4]; sum = 0;
    in = h1_outputs[0]; in = annx_lwm(wbase, in, 0); sum += in;
    in = h1_outputs[1]; in = annx_lwm(wbase, in, 1); sum += in;
    in = h1_outputs[2]; in = annx_lwm(wbase, in, 2); sum += in;
    in = h1_outputs[3]; in = annx_lwm(wbase, in, 3); sum += in;
    in = h1_outputs[4]; in = annx_lwm(wbase, in, 4); sum += in;
    sum = annx_lwa(bbase, sum, 4); h2_outputs[4] = sigmoid_q16(sum);

    // --------------------------------------------------------
    // Output Layer
    // --------------------------------------------------------
    bbase = (uint32_t)o_biases;
    sum = 0;

    // Neuron 1
    wbase = (uint32_t)o_weights[0];
    in = h2_outputs[0]; in = annx_lwm(wbase, in, 0); sum += in;
    in = h2_outputs[1]; in = annx_lwm(wbase, in, 1); sum += in;
    in = h2_outputs[2]; in = annx_lwm(wbase, in, 2); sum += in;
    in = h2_outputs[3]; in = annx_lwm(wbase, in, 3); sum += in;
    in = h2_outputs[4]; in = annx_lwm(wbase, in, 4); sum += in;
    sum = annx_lwa(bbase, sum, 0); outputs[0] = sigmoid_q16(sum);

    // Neuron 2
    wbase = (uint32_t)o_weights[1]; sum = 0;
    in = h2_outputs[0]; in = annx_lwm(wbase, in, 0); sum += in;
    in = h2_outputs[1]; in = annx_lwm(wbase, in, 1); sum += in;
    in = h2_outputs[2]; in = annx_lwm(wbase, in, 2); sum += in;
    in = h2_outputs[3]; in = annx_lwm(wbase, in, 3); sum += in;
    in = h2_outputs[4]; in = annx_lwm(wbase, in, 4); sum += in;
    sum = annx_lwa(bbase, sum, 1); outputs[1] = sigmoid_q16(sum);

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