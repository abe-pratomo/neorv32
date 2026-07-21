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

    uint32_t start_base, end_base, elapsed_base;
    uint32_t start_annx, end_annx, elapsed_annx;

    int32_t  x;

    int32_t  exp_base[n];
    int32_t  exp_annx[n];

    // Base: software exponential function
    start_base = neorv32_cpu_csr_read(CSR_CYCLE);
    if (n == 1) {
        x = 0;
        exp_base[0] = exp_pwl(x);
    } else {
        for (int i = 0; i < n; i++) {
            // evenly distribute between -MAX_ABS_INPUT and +MAX_ABS_INPUT
            x = -MAX_ABS_INPUT +
                (int32_t)(((int64_t)i * (2LL * MAX_ABS_INPUT)) / (n - 1));

            exp_base[i] = exp_pwl(x);
        }
    }
    end_base = neorv32_cpu_csr_read(CSR_CYCLE);
    elapsed_base = end_base - start_base;

    // ANNX: EXP
    // annx_exp(rs1) = exp_pwl(rs1)
    start_annx = neorv32_cpu_csr_read(CSR_CYCLE);
    if (n == 1) {
        x = 0;
        exp_annx[0] = annx_exp(x);
    } else {
        for (int i = 0; i < n; i++) {
            // evenly distribute between -MAX_ABS_INPUT and +MAX_ABS_INPUT
            x = -MAX_ABS_INPUT +
                (int32_t)(((int64_t)i * (2LL * MAX_ABS_INPUT)) / (n - 1));

            exp_annx[i] = annx_exp(x);
        }
    }
    end_annx = neorv32_cpu_csr_read(CSR_CYCLE);
    elapsed_annx = end_annx - start_annx;

    // Speedup as integer percentage
    uint32_t speedup_pct = elapsed_base > elapsed_annx ?
                           elapsed_base * 100 / elapsed_annx : 0;

    neorv32_uart0_printf("N=%d\n", n);
    for (int i = 0; i < n; i++) {
        if (n == 1)
            x = 0;
        else
            x = -MAX_ABS_INPUT + (int32_t)(((int64_t)i * (2LL * MAX_ABS_INPUT)) / (n - 1));
        if (exp_base[i] != exp_annx[i]) {
            neorv32_uart0_printf("  Mismatch at x="); print_q16(x);
            neorv32_uart0_printf(": Base="); print_q16(exp_base[i]); neorv32_uart0_printf(", ANNX="); print_q16(exp_annx[i]); neorv32_uart0_printf("\n");
        }
    }
    neorv32_uart0_printf("  Cycles: base=%u, ANNX=%u\n", elapsed_base, elapsed_annx);
    neorv32_uart0_printf("  Speedup: %u%%\n\n", speedup_pct);
}

int main(void) {

    neorv32_uart0_setup(BAUD_RATE, 0);

    neorv32_uart0_printf("================ EXP Stress Test ================\n");
    neorv32_uart0_printf("=================================================\n\n");

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
    run_test(1408209);

    neorv32_uart0_printf("====================== Done =====================\n");
    neorv32_uart0_printf("=================================================\n\n");

    return 0;
}