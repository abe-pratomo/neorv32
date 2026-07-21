#include <neorv32.h>
#include <stdint.h>
#include <neorv32_cust_annx.h>
#include <neorv32_q16_helper.h>

#define BAUD_RATE 19200

// ============================================================
// Q16.16 constants
// ============================================================
#define EXP_MIN_INPUT ((int32_t)-726817)
#define EXP_MAX_INPUT ((int32_t) 681391)
#define MAX_ABS_INPUT EXP_MAX_INPUT
#define INT32_MAX_VAL ((int32_t)0x7FFFFFFF)
#define FRAC_WIDTH    16

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

void run_test(int n) {

    uint64_t start_base = 0, end_base = 0;
    uint64_t start_annx = 0, end_annx = 0;
    uint64_t elapsed_base = 0, elapsed_annx = 0;

    int32_t x;
    int32_t exp_base, exp_annx;

    int mismatch_count = 0;

    neorv32_uart0_printf("N=%d\n", n);

    for (int i = 0; i < n; i++) {
        // evenly distribute between -MAX_ABS_INPUT and +MAX_ABS_INPUT
        x = (n == 1) ? 0 : -MAX_ABS_INPUT + (int32_t)(((int64_t)i * (2LL * MAX_ABS_INPUT)) / (n - 1));

        start_base = neorv32_cpu_csr_read(CSR_CYCLE);
        exp_base   = exp_pwl(x);
        end_base   = neorv32_cpu_csr_read(CSR_CYCLE);
        
        elapsed_base += (uint64_t)(end_base - start_base);

        start_annx = neorv32_cpu_csr_read(CSR_CYCLE);
        exp_annx   = annx_exp(x);
        end_annx   = neorv32_cpu_csr_read(CSR_CYCLE);
        
        elapsed_annx += (uint64_t)(end_annx - start_annx);
        
        if (exp_base != exp_annx && mismatch_count < 10) {
            neorv32_uart0_printf("  Mismatch at x=0x%x", (uint32_t)x);
            neorv32_uart0_printf(": Base="); print_q16(exp_base);
            neorv32_uart0_printf(", ANNX="); print_q16(exp_annx);
            neorv32_uart0_printf("\n");
            mismatch_count++;
        }
    }

    // Speedup as fractional
    uint64_t speedup_int  = elapsed_base / elapsed_annx;
    uint64_t speedup_frac = (elapsed_base * 1000ULL / elapsed_annx) % 1000;

    neorv32_uart0_printf("  Mismatches: %d\n", mismatch_count);
    neorv32_uart0_printf("  Cycles: base=%u, ANNX=%u\n", (uint32_t)elapsed_base, (uint32_t)elapsed_annx);
    const char* dir = elapsed_base >= elapsed_annx ? "faster" : "slower";
    if      (speedup_frac < 10)  neorv32_uart0_printf("  Speedup: %u.00%ux %s\n\n", (uint32_t)speedup_int, (uint32_t)speedup_frac, dir);
    else if (speedup_frac < 100) neorv32_uart0_printf("  Speedup: %u.0%ux %s\n\n",  (uint32_t)speedup_int, (uint32_t)speedup_frac, dir);
    else                         neorv32_uart0_printf("  Speedup: %u.%ux %s\n\n",   (uint32_t)speedup_int, (uint32_t)speedup_frac, dir);
}

int main(void) {

    neorv32_uart0_setup(BAUD_RATE, 0);

    neorv32_uart0_printf("======== EXP Stress Test (No M-Extension) =======\n");
    neorv32_uart0_printf("=================================================\n\n");

    // Power of 4s
    run_test(1);
    run_test(4);
    run_test(16);
    run_test(64);
    run_test(256);
    run_test(1024);
    run_test(4096);
    run_test(16384);
    run_test(65536);
    run_test(262144);
    run_test(1048576);
    run_test(1362782); // Max step from -10.3972015381 to 10.3972015381

    neorv32_uart0_printf("====================== Done =====================\n");
    neorv32_uart0_printf("=================================================\n\n");

    return 0;
}