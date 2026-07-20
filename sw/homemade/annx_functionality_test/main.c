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
    neorv32_uart0_printf("ANNX Functionality Check\n");
    neorv32_uart0_printf("========================\n\n");

    // -------------------------------------------------------------------------
    // Test data in local arrays (Q16.16 fixed-point)
    // -------------------------------------------------------------------------
    int32_t mem_a[] = {
        TO_Q16( 3),    // 3.0
        TO_Q16(-17),   // -17.0
        TO_Q16( 45),   // 45.0
        TO_Q16(-128),  // -128.0
        TO_Q16( 256),  // 256.0
        TO_Q16(-73),   // -73.0
        TO_Q16( 11),   // 11.0
        TO_Q16(-200)   // -200.0
    };

    int32_t mem_b[] = {
        TO_Q16( 7),    // 7.0
        TO_Q16( 23),   // 23.0
        TO_Q16(-60),   // -60.0
        TO_Q16( 99),   // 99.0
        TO_Q16(-150),  // -150.0
        TO_Q16( 34),   // 34.0
        TO_Q16(-88),   // -88.0
        TO_Q16( 175)   // 175.0
    };

    int32_t result;

    // -------------------------------------------------------------------------
    // LWA test
    // -------------------------------------------------------------------------
    neorv32_uart0_printf("=== LWA Test: mem_a[i] + mem_b[i] ===\n");

    result = annx_lwa((uint32_t)mem_a, mem_b[0], 0);
    neorv32_uart0_printf("[0]  "); print_q16(mem_a[0]); neorv32_uart0_printf("  +  "); print_q16(mem_b[0]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwa((uint32_t)mem_a, mem_b[1], 1);
    neorv32_uart0_printf("[1]  "); print_q16(mem_a[1]); neorv32_uart0_printf("  +  "); print_q16(mem_b[1]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwa((uint32_t)mem_a, mem_b[2], 2);
    neorv32_uart0_printf("[2]  "); print_q16(mem_a[2]); neorv32_uart0_printf("  +  "); print_q16(mem_b[2]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwa((uint32_t)mem_a, mem_b[3], 3);
    neorv32_uart0_printf("[3]  "); print_q16(mem_a[3]); neorv32_uart0_printf("  +  "); print_q16(mem_b[3]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwa((uint32_t)mem_a, mem_b[4], 4);
    neorv32_uart0_printf("[4]  "); print_q16(mem_a[4]); neorv32_uart0_printf("  +  "); print_q16(mem_b[4]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwa((uint32_t)mem_a, mem_b[5], 5);
    neorv32_uart0_printf("[5]  "); print_q16(mem_a[5]); neorv32_uart0_printf("  +  "); print_q16(mem_b[5]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwa((uint32_t)mem_a, mem_b[6], 6);
    neorv32_uart0_printf("[6]  "); print_q16(mem_a[6]); neorv32_uart0_printf("  +  "); print_q16(mem_b[6]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwa((uint32_t)mem_a, mem_b[7], 7);
    neorv32_uart0_printf("[7]  "); print_q16(mem_a[7]); neorv32_uart0_printf("  +  "); print_q16(mem_b[7]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    neorv32_uart0_printf("\n");

    // -------------------------------------------------------------------------
    // LWM test
    // -------------------------------------------------------------------------
    neorv32_uart0_printf("=== LWM Test: (mem_a[i] * mem_b[i]) >> 16 ===\n");

    result = annx_lwm((uint32_t)mem_a, mem_b[0], 0);
    neorv32_uart0_printf("[0]  "); print_q16(mem_a[0]); neorv32_uart0_printf("  x  "); print_q16(mem_b[0]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwm((uint32_t)mem_a, mem_b[1], 1);
    neorv32_uart0_printf("[1]  "); print_q16(mem_a[1]); neorv32_uart0_printf("  x  "); print_q16(mem_b[1]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwm((uint32_t)mem_a, mem_b[2], 2);
    neorv32_uart0_printf("[2]  "); print_q16(mem_a[2]); neorv32_uart0_printf("  x  "); print_q16(mem_b[2]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwm((uint32_t)mem_a, mem_b[3], 3);
    neorv32_uart0_printf("[3]  "); print_q16(mem_a[3]); neorv32_uart0_printf("  x  "); print_q16(mem_b[3]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwm((uint32_t)mem_a, mem_b[4], 4);
    neorv32_uart0_printf("[4]  "); print_q16(mem_a[4]); neorv32_uart0_printf("  x  "); print_q16(mem_b[4]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwm((uint32_t)mem_a, mem_b[5], 5);
    neorv32_uart0_printf("[5]  "); print_q16(mem_a[5]); neorv32_uart0_printf("  x  "); print_q16(mem_b[5]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwm((uint32_t)mem_a, mem_b[6], 6);
    neorv32_uart0_printf("[6]  "); print_q16(mem_a[6]); neorv32_uart0_printf("  x  "); print_q16(mem_b[6]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwm((uint32_t)mem_a, mem_b[7], 7);
    neorv32_uart0_printf("[7]  "); print_q16(mem_a[7]); neorv32_uart0_printf("  x  "); print_q16(mem_b[7]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    neorv32_uart0_printf("\n");

    // -------------------------------------------------------------------------
    // EXP test
    // -------------------------------------------------------------------------
    neorv32_uart0_printf("=== EXP Test: exp_pwl(x) ===\n");

    result = annx_exp((uint32_t)-655360);
    neorv32_uart0_printf("exp(-10)  raw=0x%x  =  ", (uint32_t)result); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_exp((uint32_t)-524288);
    neorv32_uart0_printf("exp(-8)   raw=0x%x  =  ", (uint32_t)result); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_exp((uint32_t)-393216);
    neorv32_uart0_printf("exp(-6)   raw=0x%x  =  ", (uint32_t)result); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_exp((uint32_t)-262144);
    neorv32_uart0_printf("exp(-4)   raw=0x%x  =  ", (uint32_t)result); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_exp((uint32_t)-131072);
    neorv32_uart0_printf("exp(-2)   raw=0x%x  =  ", (uint32_t)result); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_exp((uint32_t)-65536);
    neorv32_uart0_printf("exp(-1)   raw=0x%x  =  ", (uint32_t)result); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_exp((uint32_t)0);
    neorv32_uart0_printf("exp(0)    raw=0x%x  =  ", (uint32_t)result); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_exp((uint32_t)65536);
    neorv32_uart0_printf("exp(1)    raw=0x%x  =  ", (uint32_t)result); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_exp((uint32_t)131072);
    neorv32_uart0_printf("exp(2)    raw=0x%x  =  ", (uint32_t)result); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_exp((uint32_t)262144);
    neorv32_uart0_printf("exp(4)    raw=0x%x  =  ", (uint32_t)result); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_exp((uint32_t)393216);
    neorv32_uart0_printf("exp(6)    raw=0x%x  =  ", (uint32_t)result); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_exp((uint32_t)524288);
    neorv32_uart0_printf("exp(8)    raw=0x%x  =  ", (uint32_t)result); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_exp((uint32_t)655360);
    neorv32_uart0_printf("exp(10)   raw=0x%x  =  ", (uint32_t)result); print_q16(result); neorv32_uart0_printf("\n");

    neorv32_uart0_printf("\n========================\n");
    neorv32_uart0_printf("========= Done =========\n");
    return 0;
}