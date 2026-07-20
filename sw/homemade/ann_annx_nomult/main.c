#include <neorv32.h>
#include <stdint.h>
#include <neorv32_cust_annx.h>

#define BAUD_RATE 19200

// Q16.16 conversion helpers
#define TO_Q16(x)      ((int32_t)((x) * 65536))
#define Q16_TO_INT(x)  ((x) >> 16)
#define Q16_TO_FRAC(x) ((int32_t)((((x) & 0xFFFF) * 10000) >> 16))

// Print a Q16.16 value with 4 decimal places, handling leading zeros
void print_q16(int32_t val) {
    int32_t i = Q16_TO_INT(val);
    int32_t f = Q16_TO_FRAC(val);
    if      (f < 10)   neorv32_uart0_printf("%d.000%d", i, f);
    else if (f < 100)  neorv32_uart0_printf("%d.00%d",  i, f);
    else if (f < 1000) neorv32_uart0_printf("%d.0%d",   i, f);
    else               neorv32_uart0_printf("%d.%d",    i, f);
}

#define FRAC_WIDTH     16

// ============================================================
// ANN Specifications
// ============================================================
#define input_layer     4
#define h1_neuron       5
#define h2_neuron       5
#define o_neuron        2
#define bias_count      1
#define bias_multiplier 0x10000
#define l1_inputs       (input_layer + bias_count)  // 5
#define l2_inputs       (h1_neuron   + bias_count)  // 6
#define l3_inputs       (h2_neuron   + bias_count)  // 6

// ============================================================
// Inputs
// ============================================================
int32_t inputs[l1_inputs] = {
    // 13107, 52428, 45875, 19660, 65536  // Mie Goreng  - Expected: Tasty
    // 65536, 13107, 19660, 19660, 65536  // Sayur Asem  - Expected: Not Tasty
    // 39321, 39321, 19660, 52428, 65536  // Pecel       - Expected: Not Tasty
    19660, 52428, 19660, 32768, 65536  // Nasi Goreng - Expected: Tasty
    // 39321, 58982, 32768, 39321, 65536  // Tahu Campur - Expected: Tasty
    // 19660, 13107, 39321, 65536, 65536  // Dendeng     - Expected: Not Tasty
};

// ============================================================
// Weights — stored TRANSPOSED [neuron][inputs] for contiguous
// column access via LWM word offset
// ============================================================

// Hidden layer 1: [h1_neuron][l1_inputs] = [5][5]
int32_t h1_weights[h1_neuron][l1_inputs] = {
    { -95077,  196632,   65621, -110763, -29561},  // neuron 0
    { -18761,  -39271,  -44711,   51870, -34029},  // neuron 1
    {  66946, -145054,  -60594,  149020, -21527},  // neuron 2
    { 162212, -262395,  -84996,  159926,  15558},  // neuron 3
    { -54345,  103757,    -604,  -65649,  17376}   // neuron 4
};

int32_t h1_outputs[l2_inputs] = {
    0, 0, 0, 0, 0, bias_multiplier
};

// Hidden layer 2: [h2_neuron][l2_inputs] = [5][6]
int32_t h2_weights[h2_neuron][l2_inputs] = {
    {  78372,  -17407,  -67159, -192478,   63144,  43618},  // neuron 0
    {-242129,   17312,  187036,  248645,  -80859, -31781},  // neuron 1
    { -63311,  -24329,   28451,   33987,  -74799,  40982},  // neuron 2
    { 100652,  -56535,  -47128, -150446,   61123,  14507},  // neuron 3
    {  44358,  -24475,  -68997, -121661,   88419,  13483}   // neuron 4
};

int32_t h2_outputs[l3_inputs] = {
    0, 0, 0, 0, 0, bias_multiplier
};

// Output layer: [o_neuron][l3_inputs] = [2][6]
int32_t o_weights[o_neuron][l3_inputs] = {
    { 144148, -320594, -103031,  138344,  128838,  20998},  // neuron 0 (Tasty)
    {-177383,  335431,    9901, -148999,  -97330,  18766}   // neuron 1 (Not Tasty)
};

int32_t outputs[o_neuron];

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
    neorv32_uart0_printf("Sourness : "); print_q16(inputs[0]); neorv32_uart0_printf("\n");
    neorv32_uart0_printf("Sweetness: "); print_q16(inputs[1]); neorv32_uart0_printf("\n");
    neorv32_uart0_printf("Saltiness: "); print_q16(inputs[2]); neorv32_uart0_printf("\n");
    neorv32_uart0_printf("Spiciness: "); print_q16(inputs[3]); neorv32_uart0_printf("\n");

    // Start calculation
    uint32_t start_time = neorv32_cpu_csr_read(CSR_CYCLE);

    // --------------------------------------------------------
    // Hidden Layer 1
    // --------------------------------------------------------
    for (int i = 0; i < h1_neuron; i++) {
        uint32_t wbase = (uint32_t)h1_weights[i];

        int32_t p0 = annx_lwm(wbase, inputs[0], 0);
        int32_t p1 = annx_lwm(wbase, inputs[1], 1);
        int32_t p2 = annx_lwm(wbase, inputs[2], 2);
        int32_t p3 = annx_lwm(wbase, inputs[3], 3);
        int32_t p4 = annx_lwm(wbase, inputs[4], 4);

        int32_t sum = p0 + p1 + p2 + p3 + p4;
        h1_outputs[i] = sigmoid_q16(sum);
    }

    // --------------------------------------------------------
    // Hidden Layer 2
    // --------------------------------------------------------
    for (int i = 0; i < h2_neuron; i++) {
        uint32_t wbase = (uint32_t)h2_weights[i];

        int32_t p0 = annx_lwm(wbase, h1_outputs[0], 0);
        int32_t p1 = annx_lwm(wbase, h1_outputs[1], 1);
        int32_t p2 = annx_lwm(wbase, h1_outputs[2], 2);
        int32_t p3 = annx_lwm(wbase, h1_outputs[3], 3);
        int32_t p4 = annx_lwm(wbase, h1_outputs[4], 4);
        int32_t p5 = annx_lwm(wbase, h1_outputs[5], 5);

        int32_t sum = p0 + p1 + p2 + p3 + p4 + p5;
        h2_outputs[i] = sigmoid_q16(sum);
    }

    // --------------------------------------------------------
    // Output Layer
    // --------------------------------------------------------
    for (int i = 0; i < o_neuron; i++) {
        uint32_t wbase = (uint32_t)o_weights[i];

        int32_t p0 = annx_lwm(wbase, h2_outputs[0], 0);
        int32_t p1 = annx_lwm(wbase, h2_outputs[1], 1);
        int32_t p2 = annx_lwm(wbase, h2_outputs[2], 2);
        int32_t p3 = annx_lwm(wbase, h2_outputs[3], 3);
        int32_t p4 = annx_lwm(wbase, h2_outputs[4], 4);
        int32_t p5 = annx_lwm(wbase, h2_outputs[5], 5);

        int32_t sum = p0 + p1 + p2 + p3 + p4 + p5;
        outputs[i] = sigmoid_q16(sum);
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