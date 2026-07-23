#include <neorv32.h>
#include <stdint.h>
#include <neorv32_cust_annx.h>
#include <neorv32_q16_helper.h>

#define BAUD_RATE 19200

int main(void) {

    neorv32_uart0_setup(BAUD_RATE, 0);
    neorv32_uart0_printf("ANNX Functionality Check\n");
    neorv32_uart0_printf("========================\n\n");

    // -------------------------------------------------------------------------
    // Test data in local arrays (Q16.16 fixed-point)
    // -------------------------------------------------------------------------
    int32_t mem_a[] = {
        TO_Q16(     3.5  ), // +  +   normal
        TO_Q16(    12.75 ), // +  -
        TO_Q16(   -18.5  ), // -  -
        TO_Q16(    -7.25 ), // -  +
        TO_Q16(   100.125), // +  +
        TO_Q16(     0.625), // +  -
        TO_Q16(   -55.875), // -  -
        TO_Q16(    -1.5  ), // -  +
        TO_Q16( 32767    ), // positive overflow
        TO_Q16(-32768    )  // negative overflow
    };

    int32_t mem_b[] = {
        TO_Q16(  4.25 ),    // +  +
        TO_Q16( -5.5  ),    // +  -
        TO_Q16( -2.75 ),    // -  -
        TO_Q16(  8.875),    // -  +
        TO_Q16(  2.5  ),    // +  +
        TO_Q16( -7.125),    // +  -
        TO_Q16( -0.5  ),    // -  -
        TO_Q16( 15.75 ),    // -  +
        TO_Q16(  2    ),    // positive overflow
        TO_Q16( -2    )     // negative overflow
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

    result = annx_lwa((uint32_t)mem_a, mem_b[8], 8);
    neorv32_uart0_printf("[8]  "); print_q16(mem_a[8]); neorv32_uart0_printf("  +  "); print_q16(mem_b[8]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwa((uint32_t)mem_a, mem_b[9], 9);
    neorv32_uart0_printf("[9]  "); print_q16(mem_a[9]); neorv32_uart0_printf("  +  "); print_q16(mem_b[9]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

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

    result = annx_lwm((uint32_t)mem_a, mem_b[8], 8);
    neorv32_uart0_printf("[8]  "); print_q16(mem_a[8]); neorv32_uart0_printf("  x  "); print_q16(mem_b[8]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

    result = annx_lwm((uint32_t)mem_a, mem_b[9], 9);
    neorv32_uart0_printf("[9]  "); print_q16(mem_a[9]); neorv32_uart0_printf("  x  "); print_q16(mem_b[9]); neorv32_uart0_printf("  =  "); print_q16(result); neorv32_uart0_printf("\n");

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