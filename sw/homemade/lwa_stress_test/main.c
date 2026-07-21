#include <neorv32.h>
#include <stdint.h>
#include <neorv32_cust_annx.h>

#define BAUD_RATE 19200

#define TO_Q16(x)      ((int32_t)((x) * 65536))
#define Q16_TO_INT(x)  ((x) >> 16)
#define Q16_TO_FRAC(x) ((int32_t)((((x) & 0xFFFF) * 10000) >> 16))

void print_q16(int32_t val) {
    int32_t i = Q16_TO_INT(val);
    int32_t f = Q16_TO_FRAC(val);
    if      (f < 10)   neorv32_uart0_printf("%d.000%d", i, f);
    else if (f < 100)  neorv32_uart0_printf("%d.00%d",  i, f);
    else if (f < 1000) neorv32_uart0_printf("%d.0%d",   i, f);
    else               neorv32_uart0_printf("%d.%d",    i, f);
}

int32_t values[100] = {
    TO_Q16( 1), TO_Q16( 2), TO_Q16( 3), TO_Q16( 4), TO_Q16( 5), TO_Q16( 6), TO_Q16( 7), TO_Q16( 8),
    TO_Q16( 9), TO_Q16(10), TO_Q16(11), TO_Q16(12), TO_Q16(13), TO_Q16(14), TO_Q16(15), TO_Q16(16),
    TO_Q16(17), TO_Q16(18), TO_Q16(19), TO_Q16(20), TO_Q16(21), TO_Q16(22), TO_Q16(23), TO_Q16(24),
    TO_Q16(25), TO_Q16(26), TO_Q16(27), TO_Q16(28), TO_Q16(29), TO_Q16(30), TO_Q16(31), TO_Q16(32),
    TO_Q16(33), TO_Q16(34), TO_Q16(35), TO_Q16(36), TO_Q16(37), TO_Q16(38), TO_Q16(39), TO_Q16(40),
    TO_Q16(41), TO_Q16(42), TO_Q16(43), TO_Q16(44), TO_Q16(45), TO_Q16(46), TO_Q16(47), TO_Q16(48),
    TO_Q16(49), TO_Q16(50), TO_Q16(51), TO_Q16(52), TO_Q16(53), TO_Q16(54), TO_Q16(55), TO_Q16(56),
    TO_Q16(57), TO_Q16(58), TO_Q16(59), TO_Q16(60), TO_Q16(61), TO_Q16(62), TO_Q16(63), TO_Q16(64)
};

void run_test(int n) {

    uint32_t start_base, end_base, elapsed_base;
    uint32_t start_annx, end_annx, elapsed_annx;
    int32_t  sum_base = 0;
    int32_t  sum_annx = 0;

    // Base: software addition (load + add)
    start_base = neorv32_cpu_csr_read(CSR_CYCLE);
    for (int i = 0; i < n; i++) {
        sum_base += values[i];
    }
    end_base = neorv32_cpu_csr_read(CSR_CYCLE);
    elapsed_base = end_base - start_base;

    // ANNX: LWA sigma (load + add fused)
    // annx_lwa(base, rs2, imm7) = MEM[base + imm7<<2] + rs2
    // accumulate: sum = annx_lwa(values, sum, i) for each i
    start_annx = neorv32_cpu_csr_read(CSR_CYCLE);
    sum_annx = annx_lwa((uint32_t)values, 0,         0);
    if (n >= 2)  sum_annx = annx_lwa((uint32_t)values, sum_annx,  1);
    if (n >= 3)  sum_annx = annx_lwa((uint32_t)values, sum_annx,  2);
    if (n >= 4)  sum_annx = annx_lwa((uint32_t)values, sum_annx,  3);
    if (n >= 5)  sum_annx = annx_lwa((uint32_t)values, sum_annx,  4);
    if (n >= 6)  sum_annx = annx_lwa((uint32_t)values, sum_annx,  5);
    if (n >= 7)  sum_annx = annx_lwa((uint32_t)values, sum_annx,  6);
    if (n >= 8)  sum_annx = annx_lwa((uint32_t)values, sum_annx,  7);
    if (n >= 9)  sum_annx = annx_lwa((uint32_t)values, sum_annx,  8);
    if (n >= 10) sum_annx = annx_lwa((uint32_t)values, sum_annx,  9);
    if (n >= 11) sum_annx = annx_lwa((uint32_t)values, sum_annx, 10);
    if (n >= 12) sum_annx = annx_lwa((uint32_t)values, sum_annx, 11);
    if (n >= 13) sum_annx = annx_lwa((uint32_t)values, sum_annx, 12);
    if (n >= 14) sum_annx = annx_lwa((uint32_t)values, sum_annx, 13);
    if (n >= 15) sum_annx = annx_lwa((uint32_t)values, sum_annx, 14);
    if (n >= 16) sum_annx = annx_lwa((uint32_t)values, sum_annx, 15);
    if (n >= 17) sum_annx = annx_lwa((uint32_t)values, sum_annx, 16);
    if (n >= 18) sum_annx = annx_lwa((uint32_t)values, sum_annx, 17);
    if (n >= 19) sum_annx = annx_lwa((uint32_t)values, sum_annx, 18);
    if (n >= 20) sum_annx = annx_lwa((uint32_t)values, sum_annx, 19);
    if (n >= 21) sum_annx = annx_lwa((uint32_t)values, sum_annx, 20);
    if (n >= 22) sum_annx = annx_lwa((uint32_t)values, sum_annx, 21);
    if (n >= 23) sum_annx = annx_lwa((uint32_t)values, sum_annx, 22);
    if (n >= 24) sum_annx = annx_lwa((uint32_t)values, sum_annx, 23);
    if (n >= 25) sum_annx = annx_lwa((uint32_t)values, sum_annx, 24);
    if (n >= 26) sum_annx = annx_lwa((uint32_t)values, sum_annx, 25);
    if (n >= 27) sum_annx = annx_lwa((uint32_t)values, sum_annx, 26);
    if (n >= 28) sum_annx = annx_lwa((uint32_t)values, sum_annx, 27);
    if (n >= 29) sum_annx = annx_lwa((uint32_t)values, sum_annx, 28);
    if (n >= 30) sum_annx = annx_lwa((uint32_t)values, sum_annx, 29);
    if (n >= 31) sum_annx = annx_lwa((uint32_t)values, sum_annx, 30);
    if (n >= 32) sum_annx = annx_lwa((uint32_t)values, sum_annx, 31);
    if (n >= 33) sum_annx = annx_lwa((uint32_t)values, sum_annx, 32);
    if (n >= 34) sum_annx = annx_lwa((uint32_t)values, sum_annx, 33);
    if (n >= 35) sum_annx = annx_lwa((uint32_t)values, sum_annx, 34);
    if (n >= 36) sum_annx = annx_lwa((uint32_t)values, sum_annx, 35);
    if (n >= 37) sum_annx = annx_lwa((uint32_t)values, sum_annx, 36);
    if (n >= 38) sum_annx = annx_lwa((uint32_t)values, sum_annx, 37);
    if (n >= 39) sum_annx = annx_lwa((uint32_t)values, sum_annx, 38);
    if (n >= 40) sum_annx = annx_lwa((uint32_t)values, sum_annx, 39);
    if (n >= 41) sum_annx = annx_lwa((uint32_t)values, sum_annx, 40);
    if (n >= 42) sum_annx = annx_lwa((uint32_t)values, sum_annx, 41);
    if (n >= 43) sum_annx = annx_lwa((uint32_t)values, sum_annx, 42);
    if (n >= 44) sum_annx = annx_lwa((uint32_t)values, sum_annx, 43);
    if (n >= 45) sum_annx = annx_lwa((uint32_t)values, sum_annx, 44);
    if (n >= 46) sum_annx = annx_lwa((uint32_t)values, sum_annx, 45);
    if (n >= 47) sum_annx = annx_lwa((uint32_t)values, sum_annx, 46);
    if (n >= 48) sum_annx = annx_lwa((uint32_t)values, sum_annx, 47);
    if (n >= 49) sum_annx = annx_lwa((uint32_t)values, sum_annx, 48);
    if (n >= 50) sum_annx = annx_lwa((uint32_t)values, sum_annx, 49);
    if (n >= 51) sum_annx = annx_lwa((uint32_t)values, sum_annx, 50);
    if (n >= 52) sum_annx = annx_lwa((uint32_t)values, sum_annx, 51);
    if (n >= 53) sum_annx = annx_lwa((uint32_t)values, sum_annx, 52);
    if (n >= 54) sum_annx = annx_lwa((uint32_t)values, sum_annx, 53);
    if (n >= 55) sum_annx = annx_lwa((uint32_t)values, sum_annx, 54);
    if (n >= 56) sum_annx = annx_lwa((uint32_t)values, sum_annx, 55);
    if (n >= 57) sum_annx = annx_lwa((uint32_t)values, sum_annx, 56);
    if (n >= 58) sum_annx = annx_lwa((uint32_t)values, sum_annx, 57);
    if (n >= 59) sum_annx = annx_lwa((uint32_t)values, sum_annx, 58);
    if (n >= 60) sum_annx = annx_lwa((uint32_t)values, sum_annx, 59);
    if (n >= 61) sum_annx = annx_lwa((uint32_t)values, sum_annx, 60);
    if (n >= 62) sum_annx = annx_lwa((uint32_t)values, sum_annx, 61);
    if (n >= 63) sum_annx = annx_lwa((uint32_t)values, sum_annx, 62);
    end_annx = neorv32_cpu_csr_read(CSR_CYCLE);
    elapsed_annx = end_annx - start_annx;

    // Speedup as integer percentage
    uint32_t speedup_pct = elapsed_base > elapsed_annx ?
                           (elapsed_base - elapsed_annx) * 100 / elapsed_base : 0;

    neorv32_uart0_printf("N=%d\n", n);
    neorv32_uart0_printf("  Base: sum="); print_q16(sum_base);
    neorv32_uart0_printf(", cycles=%u\n", elapsed_base);
    neorv32_uart0_printf("  ANNX: sum="); print_q16(sum_annx);
    neorv32_uart0_printf(", cycles=%u\n", elapsed_annx);
    neorv32_uart0_printf("  Speedup: %u%%\n\n", speedup_pct);
}

int main(void) {

    neorv32_uart0_setup(BAUD_RATE, 0);
    neorv32_uart0_printf("LWA Stress Test: Sigma Operation\n");
    neorv32_uart0_printf("=================================\n\n");

    run_test(1);
    run_test(2);
    run_test(5);
    run_test(10);
    run_test(50);
    run_test(63);  // max imm7 range (0..62 = 63 offsets)

    neorv32_uart0_printf("==== Done ====\n");
    neorv32_uart0_printf("==============\n\n");

    return 0;
}