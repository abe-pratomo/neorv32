#include <neorv32.h>
#include <stdint.h>
#include <neorv32_cust_annx.h>
#include <neorv32_q16_helper.h>
#define BAUD_RATE 19200
#define FRAC_WIDTH 16
// ============================================================
// FIXED SPLIT: H1_SPLIT=2, H2_SPLIT=2 (core0=neurons 0-1, core1=neurons 2-4)
// Fully unrolled — no runtime loop variables, no generic split logic.
// ============================================================
#define h1_neuron 5
#define h2_neuron 5
#define o_neuron  2
#define input_layer 4
// ============================================================
// Shared / cross-core data
// ============================================================
volatile uint8_t __attribute__ ((aligned (16))) core1_stack[2048];

volatile int32_t h1_outputs[h1_neuron];
volatile int32_t h2_outputs[h2_neuron];
volatile int32_t outputs[o_neuron];

volatile uint32_t core0_done_h1 = 0, core1_done_h1 = 0;
volatile uint32_t core0_done_h2 = 0, core1_done_h2 = 0;

volatile uint32_t core1_start_food = 0;

volatile uint32_t input_select = 0;

// Weight/bias/input arrays
int32_t inputs[6][input_layer] = {
    {13107, 52428, 45875, 19660},  // Mie Goreng  - Expected: Tasty
    {65536, 13107, 19660, 19660},  // Sayur Asem  - Expected: Not Tasty
    {39321, 39321, 19660, 52428},  // Pecel       - Expected: Not Tasty
    {19660, 52428, 19660, 32768},  // Nasi Goreng - Expected: Tasty
    {39321, 58982, 32768, 39321},  // Tahu Campur - Expected: Tasty
    {19660, 13107, 39321, 65536},  // Dendeng     - Expected: Not Tasty
};
int32_t h1_weights[h1_neuron][input_layer] = {
    { -95077,  196632,   65621, -110763},
    { -18761,  -39271,  -44711,   51870},
    {  66946, -145054,  -60594,  149020},
    { 162212, -262395,  -84996,  159926},
    { -54345,  103757,    -604,  -65649}
};
int32_t h1_biases[h1_neuron] = { -29561, -34029, -21527, 15558, 17376 };
int32_t h2_weights[h2_neuron][h1_neuron] = {
    {  78372,  -17407,  -67159, -192478,  63144},
    {-242129,   17312,  187036,  248645, -80859},
    { -63311,  -24329,   28451,   33987, -74799},
    { 100652,  -56535,  -47128, -150446,  61123},
    {  44358,  -24475,  -68997, -121661,  88419}
};
int32_t h2_biases[h2_neuron] = { 43618, -31781, 40982, 14507, 13483 };
int32_t o_weights[o_neuron][h2_neuron] = {
    { 144148, -320594, -103031,  138344,  128838},
    {-177383,  335431,    9901, -148999,  -97330}
};
int32_t o_biases[o_neuron] = { 20998, 18766 };
// ============================================================
int32_t sigmoid_q16(int32_t x)
{
    int32_t exp_x  = annx_exp(x);
    int64_t num    = (int64_t)exp_x << FRAC_WIDTH;
    int64_t denom  = (int64_t)65536 + (int64_t)exp_x;
    return (int32_t)(num / denom);
}
// ============================================================
// CORE 1 — hardcoded: h1 neurons 2,3,4 / h2 neurons 2,3,4 / output neuron 1
// ============================================================
int core1_entry(void) {
    for (;;) {
        while (!core1_start_food);
        uint32_t fi = input_select;

        uint32_t bbase, wbase;
        int32_t in, sum;
        // ---- Hidden Layer 1: neurons 2,3,4 ----
        bbase = (uint32_t)h1_biases;
        wbase = (uint32_t)h1_weights[2]; sum = 0;
        in = inputs[fi][0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = inputs[fi][1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = inputs[fi][2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = inputs[fi][3]; in = annx_lwm(wbase, in, 3); sum += in;
        sum = annx_lwa(bbase, sum, 2); h1_outputs[2] = sigmoid_q16(sum);

        wbase = (uint32_t)h1_weights[3]; sum = 0;
        in = inputs[fi][0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = inputs[fi][1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = inputs[fi][2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = inputs[fi][3]; in = annx_lwm(wbase, in, 3); sum += in;
        sum = annx_lwa(bbase, sum, 3); h1_outputs[3] = sigmoid_q16(sum);

        wbase = (uint32_t)h1_weights[4]; sum = 0;
        in = inputs[fi][0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = inputs[fi][1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = inputs[fi][2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = inputs[fi][3]; in = annx_lwm(wbase, in, 3); sum += in;
        sum = annx_lwa(bbase, sum, 4); h1_outputs[4] = sigmoid_q16(sum);

        core1_done_h1 = 1;
        while (!core0_done_h1);

        // ---- Hidden Layer 2: neurons 2,3,4 ----
        bbase = (uint32_t)h2_biases;
        wbase = (uint32_t)h2_weights[2]; sum = 0;
        in = h1_outputs[0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = h1_outputs[1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = h1_outputs[2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = h1_outputs[3]; in = annx_lwm(wbase, in, 3); sum += in;
        in = h1_outputs[4]; in = annx_lwm(wbase, in, 4); sum += in;
        sum = annx_lwa(bbase, sum, 2); h2_outputs[2] = sigmoid_q16(sum);

        wbase = (uint32_t)h2_weights[3]; sum = 0;
        in = h1_outputs[0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = h1_outputs[1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = h1_outputs[2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = h1_outputs[3]; in = annx_lwm(wbase, in, 3); sum += in;
        in = h1_outputs[4]; in = annx_lwm(wbase, in, 4); sum += in;
        sum = annx_lwa(bbase, sum, 3); h2_outputs[3] = sigmoid_q16(sum);

        wbase = (uint32_t)h2_weights[4]; sum = 0;
        in = h1_outputs[0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = h1_outputs[1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = h1_outputs[2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = h1_outputs[3]; in = annx_lwm(wbase, in, 3); sum += in;
        in = h1_outputs[4]; in = annx_lwm(wbase, in, 4); sum += in;
        sum = annx_lwa(bbase, sum, 4); h2_outputs[4] = sigmoid_q16(sum);

        core1_done_h2 = 1;
        while (!core0_done_h2);

        // ---- Output Layer: neuron 1 ----
        bbase = (uint32_t)o_biases;
        wbase = (uint32_t)o_weights[1]; sum = 0;
        in = h2_outputs[0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = h2_outputs[1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = h2_outputs[2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = h2_outputs[3]; in = annx_lwm(wbase, in, 3); sum += in;
        in = h2_outputs[4]; in = annx_lwm(wbase, in, 4); sum += in;
        sum = annx_lwa(bbase, sum, 1); outputs[1] = sigmoid_q16(sum);

        core1_start_food = 0;
    }

    return 0;
}
// Simple space-padding helper — since neorv32_uart0_printf likely has no %-Ns support
void print_padded(const char *s, int width) {
    neorv32_uart0_printf("%s", s);
    int len = 0;
    while (s[len] != '\0') len++;
    for (int i = len; i < width; i++) {
        neorv32_uart0_printf(" ");
    }
}
// ============================================================
// MAIN (core0) — hardcoded: h1 neurons 0,1 / h2 neurons 0,1 / output neuron 0
// ============================================================
int main(void) {
    // Initialize UART at 19200 baud
    neorv32_uart0_setup(BAUD_RATE, 0);

    // Print banner
    neorv32_uart0_printf("=============== NEORV32 ANN (Dual-Core) Example ==============\n");
    neorv32_uart0_printf("======== ANN for Indonesian Food Preference Detection ========\n");
    neorv32_uart0_printf("==============================================================\n\n");

    neorv32_uart0_printf("Food          Expected   Result     Cycles Status\n");
    neorv32_uart0_printf("--------------------------------------------------------------\n");

    neorv32_smp_launch(core1_entry, (uint8_t*)core1_stack, sizeof(core1_stack)); // Launch core1

    for (input_select; input_select < 6; input_select++) {
        // Reset barriers for this iteration
        core0_done_h1 = 0; core1_done_h1 = 0;
        core0_done_h2 = 0; core1_done_h2 = 0;

        uint32_t fi = input_select;

        uint32_t wall_start = neorv32_cpu_csr_read(CSR_CYCLE);
        core1_start_food = 1; // wake core1 for this food

        uint32_t bbase, wbase;
        int32_t in, sum;
        // ---- Hidden Layer 1: neurons 0,1 ----
        bbase = (uint32_t)h1_biases;
        wbase = (uint32_t)h1_weights[0]; sum = 0;
        in = inputs[fi][0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = inputs[fi][1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = inputs[fi][2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = inputs[fi][3]; in = annx_lwm(wbase, in, 3); sum += in;
        sum = annx_lwa(bbase, sum, 0); h1_outputs[0] = sigmoid_q16(sum);

        wbase = (uint32_t)h1_weights[1]; sum = 0;
        in = inputs[fi][0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = inputs[fi][1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = inputs[fi][2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = inputs[fi][3]; in = annx_lwm(wbase, in, 3); sum += in;
        sum = annx_lwa(bbase, sum, 1); h1_outputs[1] = sigmoid_q16(sum);

        core0_done_h1 = 1;
        while (!core1_done_h1);

        // ---- Hidden Layer 2: neurons 0,1 ----
        bbase = (uint32_t)h2_biases;
        wbase = (uint32_t)h2_weights[0]; sum = 0;
        in = h1_outputs[0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = h1_outputs[1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = h1_outputs[2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = h1_outputs[3]; in = annx_lwm(wbase, in, 3); sum += in;
        in = h1_outputs[4]; in = annx_lwm(wbase, in, 4); sum += in;
        sum = annx_lwa(bbase, sum, 0); h2_outputs[0] = sigmoid_q16(sum);

        wbase = (uint32_t)h2_weights[1]; sum = 0;
        in = h1_outputs[0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = h1_outputs[1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = h1_outputs[2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = h1_outputs[3]; in = annx_lwm(wbase, in, 3); sum += in;
        in = h1_outputs[4]; in = annx_lwm(wbase, in, 4); sum += in;
        sum = annx_lwa(bbase, sum, 1); h2_outputs[1] = sigmoid_q16(sum);

        core0_done_h2 = 1;
        while (!core1_done_h2);

        // ---- Output Layer: neuron 0 ----
        bbase = (uint32_t)o_biases;
        wbase = (uint32_t)o_weights[0]; sum = 0;
        in = h2_outputs[0]; in = annx_lwm(wbase, in, 0); sum += in;
        in = h2_outputs[1]; in = annx_lwm(wbase, in, 1); sum += in;
        in = h2_outputs[2]; in = annx_lwm(wbase, in, 2); sum += in;
        in = h2_outputs[3]; in = annx_lwm(wbase, in, 3); sum += in;
        in = h2_outputs[4]; in = annx_lwm(wbase, in, 4); sum += in;
        sum = annx_lwa(bbase, sum, 0); outputs[0] = sigmoid_q16(sum);

        while (core1_start_food);
        uint32_t wall_end = neorv32_cpu_csr_read(CSR_CYCLE);
        uint32_t elapsed_cycle = wall_end - wall_start;

        const char *food_names[6] = {
            "Mie Goreng", "Sayur Asem", "Pecel", "Nasi Goreng", "Tahu Campur", "Dendeng"
        };
        const char *expected_str[6] = {
            "Tasty", "Not Tasty", "Not Tasty", "Tasty", "Tasty", "Not Tasty"
        };
        uint32_t tasty_expected[6] = {1, 0, 0, 1, 1, 0};

        uint32_t tasty_result = (outputs[0] > outputs[1]);
        const char *result_str = tasty_result ? "Tasty" : "Not Tasty";
        const char *status = (tasty_result == tasty_expected[input_select]) ? "OK" : "MISMATCH";

        print_padded(food_names[input_select], 14);
        print_padded(expected_str[input_select], 11);
        print_padded(result_str, 11);
        neorv32_uart0_printf("%u", elapsed_cycle);
        print_padded("", 3);
        neorv32_uart0_printf("%s\n", status);
    }

    // Finish execution
    neorv32_uart0_printf("\n=========================== THE END ==========================\n");
    neorv32_uart0_printf("==============================================================\n\n");
    return 0;
}