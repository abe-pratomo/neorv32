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

int main(void) {

    neorv32_uart0_setup(BAUD_RATE, 0);
    neorv32_uart0_printf("LWA Stress Test\n");
    neorv32_uart0_printf("===============\n\n");

    int32_t values[100] = {
        TO_Q16( 1), TO_Q16( 2), TO_Q16( 3), TO_Q16( 4), TO_Q16( 5), TO_Q16( 6), TO_Q16( 7), TO_Q16( 8), TO_Q16( 9), TO_Q16( 10),
        TO_Q16(11), TO_Q16(12), TO_Q16(13), TO_Q16(14), TO_Q16(15), TO_Q16(16), TO_Q16(17), TO_Q16(18), TO_Q16(19), TO_Q16( 20),
        TO_Q16(21), TO_Q16(22), TO_Q16(23), TO_Q16(24), TO_Q16(25), TO_Q16(26), TO_Q16(27), TO_Q16(28), TO_Q16(29), TO_Q16( 30),
        TO_Q16(31), TO_Q16(32), TO_Q16(33), TO_Q16(34), TO_Q16(35), TO_Q16(36), TO_Q16(37), TO_Q16(38), TO_Q16(39), TO_Q16( 40),
        TO_Q16(41), TO_Q16(42), TO_Q16(43), TO_Q16(44), TO_Q16(45), TO_Q16(46), TO_Q16(47), TO_Q16(48), TO_Q16(49), TO_Q16( 50),
        TO_Q16(51), TO_Q16(52), TO_Q16(53), TO_Q16(54), TO_Q16(55), TO_Q16(56), TO_Q16(57), TO_Q16(58), TO_Q16(59), TO_Q16( 60),
        TO_Q16(61), TO_Q16(62), TO_Q16(63), TO_Q16(64), TO_Q16(65), TO_Q16(66), TO_Q16(67), TO_Q16(68), TO_Q16(69), TO_Q16( 70),
        TO_Q16(71), TO_Q16(72), TO_Q16(73), TO_Q16(74), TO_Q16(75), TO_Q16(76), TO_Q16(77), TO_Q16(78), TO_Q16(79), TO_Q16( 80),
        TO_Q16(81), TO_Q16(82), TO_Q16(83), TO_Q16(84), TO_Q16(85), TO_Q16(86), TO_Q16(87), TO_Q16(88), TO_Q16(89), TO_Q16( 90),
        TO_Q16(91), TO_Q16(92), TO_Q16(93), TO_Q16(94), TO_Q16(95), TO_Q16(96), TO_Q16(97), TO_Q16(98), TO_Q16(99), TO_Q16(100),
    }

    uint32_t start_time_base;
    uint32_t end_time_base;
    uint32_t elapsed_base;

    uint32_t start_time_annx;
    uint32_t end_time_annx;
    uint32_t elapsed_annx;

    float speedup;

    int32_t sum = 0;

    // 1 concurrent execution

    start_time_base = neorv32_cpu_csr_read(CSR_CYCLE);
    for (int i = 0; i < 1; i++) {
        sum += values[i];
    }
    end_time_base = neorv32_cpu_csr_read(CSR_CYCLE);
    neorv32_uart0_printf("1 Concurrent - Base Sum = %d; ", sum);

    sum = 0;

    start_time_annx = neorv32_cpu_csr_read(CSR_CYCLE);
    sum = annx_lwa(values, sum, 0);
    end_time_annx = neorv32_cpu_csr_read(CSR_CYCLE);
    neorv32_uart0_printf("ANNX Sum = %d; ", sum);

    sum = 0;

    elapsed_base = end_time_base - start_time_base;
    elapsed_annx = end_time_annx - end_time_annx;
    speedup      = (float)elapsed_base/(float)elapsed_annx

    neorv32_uart0_printf("Base Elapsed Cycles = %u; ANNX Elapsed Cycles = %u; SPEEDUP = %fx", elapsed_base, elapsed_annx, speedup)

    // 2 concurrent executions
    ...

    // 5 concurrent executions
    ...

    // 10 concurrent executions
    ...

    // 50 concurrent executions
    ...

    // 100 concurrent executions
    ...

    neorv32_uart0_printf("==== Done ====")
    neorv32_uart0_printf("==============\n\n");

    return 0;
}
