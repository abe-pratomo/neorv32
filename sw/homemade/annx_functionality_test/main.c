#include <neorv32.h>
#include <stdint.h>
#include <neorv32_cust_annx.h>

#define BAUD_RATE 19200

// Q16.16 conversion helpers
#define TO_Q16(x)      ((int32_t)((x) * 65536))
#define Q16_TO_INT(x)  ((x) >> 16)
#define Q16_TO_FRAC(x) ((int32_t)((((x) & 0xFFFF) * 10000) >> 16))

int main(void) {

    // UART init
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
    // LWA test: result = mem_a[i] + mem_b[i]
    // -------------------------------------------------------------------------
    neorv32_uart0_printf("=== LWA Test: mem_a[i] + mem_b[i] ===\n");

    result = annx_lwa((uint32_t)mem_a, mem_b[0], 0);
    neorv32_uart0_printf("[0]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[0]), Q16_TO_FRAC(mem_a[0]),
        Q16_TO_INT(mem_b[0]), Q16_TO_FRAC(mem_b[0]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwa((uint32_t)mem_a, mem_b[1], 1);
    neorv32_uart0_printf("[1]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[1]), Q16_TO_FRAC(mem_a[1]),
        Q16_TO_INT(mem_b[1]), Q16_TO_FRAC(mem_b[1]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwa((uint32_t)mem_a, mem_b[2], 2);
    neorv32_uart0_printf("[2]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[2]), Q16_TO_FRAC(mem_a[2]),
        Q16_TO_INT(mem_b[2]), Q16_TO_FRAC(mem_b[2]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwa((uint32_t)mem_a, mem_b[3], 3);
    neorv32_uart0_printf("[3]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[3]), Q16_TO_FRAC(mem_a[3]),
        Q16_TO_INT(mem_b[3]), Q16_TO_FRAC(mem_b[3]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwa((uint32_t)mem_a, mem_b[4], 4);
    neorv32_uart0_printf("[4]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[4]), Q16_TO_FRAC(mem_a[4]),
        Q16_TO_INT(mem_b[4]), Q16_TO_FRAC(mem_b[4]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwa((uint32_t)mem_a, mem_b[5], 5);
    neorv32_uart0_printf("[5]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[5]), Q16_TO_FRAC(mem_a[5]),
        Q16_TO_INT(mem_b[5]), Q16_TO_FRAC(mem_b[5]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwa((uint32_t)mem_a, mem_b[6], 6);
    neorv32_uart0_printf("[6]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[6]), Q16_TO_FRAC(mem_a[6]),
        Q16_TO_INT(mem_b[6]), Q16_TO_FRAC(mem_b[6]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwa((uint32_t)mem_a, mem_b[7], 7);
    neorv32_uart0_printf("[7]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[7]), Q16_TO_FRAC(mem_a[7]),
        Q16_TO_INT(mem_b[7]), Q16_TO_FRAC(mem_b[7]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    neorv32_uart0_printf("\n");

    // -------------------------------------------------------------------------
    // LWM test: result = (mem_a[i] * mem_b[i]) >> 16
    // -------------------------------------------------------------------------
    neorv32_uart0_printf("=== LWM Test: (mem_a[i] * mem_b[i]) >> 16 ===\n");

    result = annx_lwm((uint32_t)mem_a, mem_b[0], 0);
    neorv32_uart0_printf("[0]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[0]), Q16_TO_FRAC(mem_a[0]),
        Q16_TO_INT(mem_b[0]), Q16_TO_FRAC(mem_b[0]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwm((uint32_t)mem_a, mem_b[1], 1);
    neorv32_uart0_printf("[1]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[1]), Q16_TO_FRAC(mem_a[1]),
        Q16_TO_INT(mem_b[1]), Q16_TO_FRAC(mem_b[1]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwm((uint32_t)mem_a, mem_b[2], 2);
    neorv32_uart0_printf("[2]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[2]), Q16_TO_FRAC(mem_a[2]),
        Q16_TO_INT(mem_b[2]), Q16_TO_FRAC(mem_b[2]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwm((uint32_t)mem_a, mem_b[3], 3);
    neorv32_uart0_printf("[3]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[3]), Q16_TO_FRAC(mem_a[3]),
        Q16_TO_INT(mem_b[3]), Q16_TO_FRAC(mem_b[3]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwm((uint32_t)mem_a, mem_b[4], 4);
    neorv32_uart0_printf("[4]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[4]), Q16_TO_FRAC(mem_a[4]),
        Q16_TO_INT(mem_b[4]), Q16_TO_FRAC(mem_b[4]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwm((uint32_t)mem_a, mem_b[5], 5);
    neorv32_uart0_printf("[5]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[5]), Q16_TO_FRAC(mem_a[5]),
        Q16_TO_INT(mem_b[5]), Q16_TO_FRAC(mem_b[5]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwm((uint32_t)mem_a, mem_b[6], 6);
    neorv32_uart0_printf("[6]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[6]), Q16_TO_FRAC(mem_a[6]),
        Q16_TO_INT(mem_b[6]), Q16_TO_FRAC(mem_b[6]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwm((uint32_t)mem_a, mem_b[7], 7);
    neorv32_uart0_printf("[7]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
        Q16_TO_INT(mem_a[7]), Q16_TO_FRAC(mem_a[7]),
        Q16_TO_INT(mem_b[7]), Q16_TO_FRAC(mem_b[7]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    neorv32_uart0_printf("\n");

    // -------------------------------------------------------------------------
    // EXP test: result = exp_pwl(x)
    // -------------------------------------------------------------------------
    neorv32_uart0_printf("=== EXP Test: exp_pwl(x) ===\n");

    result = annx_exp(TO_Q16(-10));
    neorv32_uart0_printf("exp(-10.0000)  =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));

    result = annx_exp(TO_Q16(-8));
    neorv32_uart0_printf("exp(-8.0000)   =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));

    result = annx_exp(TO_Q16(-6));
    neorv32_uart0_printf("exp(-6.0000)   =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));

    result = annx_exp(TO_Q16(-4));
    neorv32_uart0_printf("exp(-4.0000)   =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));

    result = annx_exp(TO_Q16(-2));
    neorv32_uart0_printf("exp(-2.0000)   =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));

    result = annx_exp(TO_Q16(-1));
    neorv32_uart0_printf("exp(-1.0000)   =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));

    result = annx_exp(TO_Q16(0));
    neorv32_uart0_printf("exp(0.0000)    =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));

    result = annx_exp(TO_Q16(1));
    neorv32_uart0_printf("exp(1.0000)    =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));

    result = annx_exp(TO_Q16(2));
    neorv32_uart0_printf("exp(2.0000)    =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));

    result = annx_exp(TO_Q16(4));
    neorv32_uart0_printf("exp(4.0000)    =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));

    result = annx_exp(TO_Q16(6));
    neorv32_uart0_printf("exp(6.0000)    =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));

    result = annx_exp(TO_Q16(8));
    neorv32_uart0_printf("exp(8.0000)    =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));

    result = annx_exp(TO_Q16(10));
    neorv32_uart0_printf("exp(10.0000)   =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));

    neorv32_uart0_printf("\nDone.\n");

    return 0;
}