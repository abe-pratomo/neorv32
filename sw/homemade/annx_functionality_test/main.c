#include <neorv32.h>
#include <stdint.h>
#include <neorv32_cust_annx.h>

#define BAUD_RATE 19200

// Q16.16 conversion helpers
#define TO_Q16(x)     ((int32_t)((x) * 65536))
#define Q16_TO_INT(x) ((x) >> 16)
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

    int32_t exp_inputs[] = {
        TO_Q16(-10),
        TO_Q16( -8),
        TO_Q16( -6),
        TO_Q16( -4),
        TO_Q16( -2),
        TO_Q16( -1),
        TO_Q16(  0),
        TO_Q16(  1),
        TO_Q16(  2),
        TO_Q16(  4),
        TO_Q16(  6),
        TO_Q16(  8),
        TO_Q16( 10)
    };

    int32_t result;

    // -------------------------------------------------------------------------
    // LWA test: result = mem_a[i] + mem_b[i]
    // -------------------------------------------------------------------------
    // neorv32_uart0_printf("=== LWA Test: mem_a[i] + mem_b[i] ===\n");
    // neorv32_uart0_printf("%-6s  %-12s  %-12s  %-12s\n", "i", "mem_a", "mem_b", "result");

    // for (int i = 0; i < 8; i++) {
    //     result = annx_lwa((uint32_t)mem_a, (uint32_t)mem_b[i], i);

    //     int32_t a_int  = Q16_TO_INT(mem_a[i]);
    //     int32_t b_int  = Q16_TO_INT(mem_b[i]);
    //     int32_t r_int  = Q16_TO_INT(result);
    //     int32_t a_frac = Q16_TO_FRAC(mem_a[i]);
    //     int32_t b_frac = Q16_TO_FRAC(mem_b[i]);
    //     int32_t r_frac = Q16_TO_FRAC(result);

    //     neorv32_uart0_printf("[%d]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
    //         i, a_int, a_frac, b_int, b_frac, r_int, r_frac);
    // }
    neorv32_uart0_printf("=== LWA Test: mem_a[0] + mem_b[0] ===\n");

    result = annx_lwa((uint32_t)mem_a, (uint32_t)mem_b[0], 0);

    int32_t a_int  = Q16_TO_INT(mem_a[0]);
    int32_t b_int  = Q16_TO_INT(mem_b[0]);
    int32_t r_int  = Q16_TO_INT(result);
    int32_t a_frac = Q16_TO_FRAC(mem_a[0]);
    int32_t b_frac = Q16_TO_FRAC(mem_b[0]);
    int32_t r_frac = Q16_TO_FRAC(result);

    neorv32_uart0_printf("[%d]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
        0, a_int, a_frac, b_int, b_frac, r_int, r_frac);

    neorv32_uart0_printf("\n");

    // -------------------------------------------------------------------------
    // LWM test: result = (mem_a[i] * mem_b[i]) >> 16
    // -------------------------------------------------------------------------
    // neorv32_uart0_printf("=== LWM Test: (mem_a[i] * mem_b[i]) >> 16 ===\n");
    // neorv32_uart0_printf("%-6s  %-12s  %-12s  %-12s\n", "i", "mem_a", "mem_b", "result");

    // for (int i = 0; i < 8; i++) {
    //     result = annx_lwm((uint32_t)mem_a, (uint32_t)mem_b[i], i);

    //     int32_t a_int  = Q16_TO_INT(mem_a[i]);
    //     int32_t b_int  = Q16_TO_INT(mem_b[i]);
    //     int32_t r_int  = Q16_TO_INT(result);
    //     int32_t a_frac = Q16_TO_FRAC(mem_a[i]);
    //     int32_t b_frac = Q16_TO_FRAC(mem_b[i]);
    //     int32_t r_frac = Q16_TO_FRAC(result);

    //     neorv32_uart0_printf("[%d]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
    //         i, a_int, a_frac, b_int, b_frac, r_int, r_frac);
    // }
    neorv32_uart0_printf("=== LWM Test: (mem_a[0] * mem_b[0]) >> 16 ===\n");

    result = annx_lwm((uint32_t)mem_a, (uint32_t)mem_b[0], 0);

    a_int  = Q16_TO_INT(mem_a[0]);
    b_int  = Q16_TO_INT(mem_b[0]);
    r_int  = Q16_TO_INT(result);
    a_frac = Q16_TO_FRAC(mem_a[0]);
    b_frac = Q16_TO_FRAC(mem_b[0]);
    r_frac = Q16_TO_FRAC(result);

    neorv32_uart0_printf("[%d]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
        0, a_int, a_frac, b_int, b_frac, r_int, r_frac);

    neorv32_uart0_printf("\n");

    // -------------------------------------------------------------------------
    // EXP test: result = exp_pwl(x)
    // -------------------------------------------------------------------------
    // neorv32_uart0_printf("=== EXP Test: exp_pwl(x) ===\n");
    // neorv32_uart0_printf("%-12s  %-12s\n", "x", "exp(x)");

    // int n_exp = sizeof(exp_inputs) / sizeof(exp_inputs[0]);
    // for (int i = 0; i < n_exp; i++) {
    //     result = annx_exp((uint32_t)exp_inputs[i]);

    //     int32_t x_int  = Q16_TO_INT(exp_inputs[i]);
    //     int32_t r_int  = Q16_TO_INT(result);
    //     int32_t x_frac = Q16_TO_FRAC(exp_inputs[i]);
    //     int32_t r_frac = Q16_TO_FRAC(result);

    //     neorv32_uart0_printf("exp(%d.%04d)  =  %d.%04d\n",
    //         x_int, x_frac, r_int, r_frac);
    // }
    neorv32_uart0_printf("=== EXP Test: exp_pwl(x) ===\n");

    result = annx_exp((uint32_t)exp_inputs[0]);

    int32_t x_int  = Q16_TO_INT(exp_inputs[0]);
    r_int  = Q16_TO_INT(result);
    int32_t x_frac = Q16_TO_FRAC(exp_inputs[0]);
    r_frac = Q16_TO_FRAC(result);

    neorv32_uart0_printf("exp(%d.%04d)  =  %d.%04d\n",
        x_int, x_frac, r_int, r_frac);

    neorv32_uart0_printf("\nDone.\n");

    return 0;
}