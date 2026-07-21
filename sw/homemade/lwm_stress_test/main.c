#include <neorv32.h>
#include <stdint.h>
#include <neorv32_cust_annx.h>
#include <neorv32_q16_helper.h>

#define BAUD_RATE 19200

int32_t values[128] = {
    TO_Q16( 1.50000), TO_Q16(-1.75000), TO_Q16(-2.50000), TO_Q16( 1.00000), TO_Q16( 1.25000), TO_Q16( 0.62500), TO_Q16(-1.00000), TO_Q16( 0.25000),
    TO_Q16( 0.87500), TO_Q16( 2.75000), TO_Q16( 3.25000), TO_Q16(-1.00000), TO_Q16( 0.18750), TO_Q16(-1.12500), TO_Q16(-0.25000), TO_Q16( 1.12500),
    TO_Q16( 0.62500), TO_Q16(-2.25000), TO_Q16(-2.50000), TO_Q16( 2.75000), TO_Q16( 0.18750), TO_Q16( 1.50000), TO_Q16( 0.06250), TO_Q16(-1.12500),
    TO_Q16( 1.12500), TO_Q16(-0.18750), TO_Q16(-3.00000), TO_Q16( 0.37500), TO_Q16(-2.00000), TO_Q16( 1.12500), TO_Q16(-2.25000), TO_Q16(-2.75000),
    TO_Q16( 0.25000), TO_Q16(-2.75000), TO_Q16( 3.25000), TO_Q16(-1.00000), TO_Q16( 3.25000), TO_Q16( 1.12500), TO_Q16(-1.00000), TO_Q16(-0.50000),
    TO_Q16(-0.87500), TO_Q16( 0.18750), TO_Q16( 0.37500), TO_Q16( 0.12500), TO_Q16( 2.75000), TO_Q16(-2.50000), TO_Q16( 0.75000), TO_Q16( 3.00000),
    TO_Q16( 1.75000), TO_Q16(-2.00000), TO_Q16(-1.25000), TO_Q16(-3.25000), TO_Q16( 3.00000), TO_Q16(-0.62500), TO_Q16(-0.87500), TO_Q16(-0.75000),
    TO_Q16(-0.50000), TO_Q16(-0.12500), TO_Q16( 0.37500), TO_Q16(-0.75000), TO_Q16( 3.00000), TO_Q16( 2.75000), TO_Q16(-0.18750), TO_Q16( 0.62500),
    TO_Q16(-3.00000), TO_Q16(-0.18750), TO_Q16( 0.50000), TO_Q16(-2.25000), TO_Q16(-3.25000), TO_Q16(-0.87500), TO_Q16( 0.18750), TO_Q16(-1.25000),
    TO_Q16(-1.50000), TO_Q16( 1.25000), TO_Q16( 2.25000), TO_Q16(-3.00000), TO_Q16( 0.62500), TO_Q16( 0.12500), TO_Q16( 0.50000), TO_Q16( 1.12500),
    TO_Q16( 2.00000), TO_Q16( 1.75000), TO_Q16( 2.50000), TO_Q16(-1.25000), TO_Q16(-0.87500), TO_Q16(-0.18750), TO_Q16(-2.25000), TO_Q16( 1.00000),
    TO_Q16( 3.00000), TO_Q16(-3.25000), TO_Q16(-1.00000), TO_Q16( 1.75000), TO_Q16(-0.18750), TO_Q16( 0.62500), TO_Q16(-0.50000), TO_Q16(-2.00000),
    TO_Q16( 3.00000), TO_Q16(-0.12500), TO_Q16(-3.00000), TO_Q16(-0.12500), TO_Q16( 2.25000), TO_Q16( 3.25000), TO_Q16(-0.12500), TO_Q16( 1.00000),
    TO_Q16(-1.75000), TO_Q16( 1.50000), TO_Q16(-1.75000), TO_Q16(-0.62500), TO_Q16( 2.50000), TO_Q16(-0.62500), TO_Q16( 0.62500), TO_Q16( 0.87500),
    TO_Q16(-0.50000), TO_Q16( 1.50000), TO_Q16( 2.00000), TO_Q16( 0.25000), TO_Q16(-1.25000), TO_Q16(-2.75000), TO_Q16( 1.25000), TO_Q16( 3.25000),
    TO_Q16( 2.00000), TO_Q16( 1.25000), TO_Q16(-0.50000), TO_Q16(-3.00000), TO_Q16(-0.37500), TO_Q16(-1.12500), TO_Q16( 1.25000), TO_Q16( 1.12500)
};

void run_test(int n) {

    uint32_t start_base, end_base, elapsed_base;
    uint32_t start_annx, end_annx, elapsed_annx;
    int32_t  product_base   = TO_Q16(1);
    int32_t  product_annx   = TO_Q16(1);

    // Base: software multiplication (load + multiply)
    start_base = neorv32_cpu_csr_read(CSR_CYCLE);
    for (int i = 0; i < n; i++) {
        int64_t tmp = (int64_t)product_base * values[i];
        product_base = (int32_t)(tmp >> 16);
    }
    end_base = neorv32_cpu_csr_read(CSR_CYCLE);
    elapsed_base = end_base - start_base;

    // ANNX: LWM pi (load + multiply fused)
    // annx_lwm(base, rs2, word_offset) = MEM[base + word_offset<<2] * rs2
    // accumulate: product = annx_lwm(values, product, i) for each i
    uint32_t values_mid = (uint32_t)&values[64];
    start_annx = neorv32_cpu_csr_read(CSR_CYCLE);
    product_annx = annx_lwm(values_mid, product_annx, 64);
    if (n >= 2)   product_annx = annx_lwm(values_mid, product_annx, 65);
    if (n >= 3)   product_annx = annx_lwm(values_mid, product_annx, 66);
    if (n >= 4)   product_annx = annx_lwm(values_mid, product_annx, 67);
    if (n >= 5)   product_annx = annx_lwm(values_mid, product_annx, 68);
    if (n >= 6)   product_annx = annx_lwm(values_mid, product_annx, 69);
    if (n >= 7)   product_annx = annx_lwm(values_mid, product_annx, 70);
    if (n >= 8)   product_annx = annx_lwm(values_mid, product_annx, 71);
    if (n >= 9)   product_annx = annx_lwm(values_mid, product_annx, 72);
    if (n >= 10)  product_annx = annx_lwm(values_mid, product_annx, 73);
    if (n >= 11)  product_annx = annx_lwm(values_mid, product_annx, 74);
    if (n >= 12)  product_annx = annx_lwm(values_mid, product_annx, 75);
    if (n >= 13)  product_annx = annx_lwm(values_mid, product_annx, 76);
    if (n >= 14)  product_annx = annx_lwm(values_mid, product_annx, 77);
    if (n >= 15)  product_annx = annx_lwm(values_mid, product_annx, 78);
    if (n >= 16)  product_annx = annx_lwm(values_mid, product_annx, 79);
    if (n >= 17)  product_annx = annx_lwm(values_mid, product_annx, 80);
    if (n >= 18)  product_annx = annx_lwm(values_mid, product_annx, 81);
    if (n >= 19)  product_annx = annx_lwm(values_mid, product_annx, 82);
    if (n >= 20)  product_annx = annx_lwm(values_mid, product_annx, 83);
    if (n >= 21)  product_annx = annx_lwm(values_mid, product_annx, 84);
    if (n >= 22)  product_annx = annx_lwm(values_mid, product_annx, 85);
    if (n >= 23)  product_annx = annx_lwm(values_mid, product_annx, 86);
    if (n >= 24)  product_annx = annx_lwm(values_mid, product_annx, 87);
    if (n >= 25)  product_annx = annx_lwm(values_mid, product_annx, 88);
    if (n >= 26)  product_annx = annx_lwm(values_mid, product_annx, 89);
    if (n >= 27)  product_annx = annx_lwm(values_mid, product_annx, 90);
    if (n >= 28)  product_annx = annx_lwm(values_mid, product_annx, 91);
    if (n >= 29)  product_annx = annx_lwm(values_mid, product_annx, 92);
    if (n >= 30)  product_annx = annx_lwm(values_mid, product_annx, 93);
    if (n >= 31)  product_annx = annx_lwm(values_mid, product_annx, 94);
    if (n >= 32)  product_annx = annx_lwm(values_mid, product_annx, 95);
    if (n >= 33)  product_annx = annx_lwm(values_mid, product_annx, 96);
    if (n >= 34)  product_annx = annx_lwm(values_mid, product_annx, 97);
    if (n >= 35)  product_annx = annx_lwm(values_mid, product_annx, 98);
    if (n >= 36)  product_annx = annx_lwm(values_mid, product_annx, 99);
    if (n >= 37)  product_annx = annx_lwm(values_mid, product_annx, 100);
    if (n >= 38)  product_annx = annx_lwm(values_mid, product_annx, 101);
    if (n >= 39)  product_annx = annx_lwm(values_mid, product_annx, 102);
    if (n >= 40)  product_annx = annx_lwm(values_mid, product_annx, 103);
    if (n >= 41)  product_annx = annx_lwm(values_mid, product_annx, 104);
    if (n >= 42)  product_annx = annx_lwm(values_mid, product_annx, 105);
    if (n >= 43)  product_annx = annx_lwm(values_mid, product_annx, 106);
    if (n >= 44)  product_annx = annx_lwm(values_mid, product_annx, 107);
    if (n >= 45)  product_annx = annx_lwm(values_mid, product_annx, 108);
    if (n >= 46)  product_annx = annx_lwm(values_mid, product_annx, 109);
    if (n >= 47)  product_annx = annx_lwm(values_mid, product_annx, 110);
    if (n >= 48)  product_annx = annx_lwm(values_mid, product_annx, 111);
    if (n >= 49)  product_annx = annx_lwm(values_mid, product_annx, 112);
    if (n >= 50)  product_annx = annx_lwm(values_mid, product_annx, 113);
    if (n >= 51)  product_annx = annx_lwm(values_mid, product_annx, 114);
    if (n >= 52)  product_annx = annx_lwm(values_mid, product_annx, 115);
    if (n >= 53)  product_annx = annx_lwm(values_mid, product_annx, 116);
    if (n >= 54)  product_annx = annx_lwm(values_mid, product_annx, 117);
    if (n >= 55)  product_annx = annx_lwm(values_mid, product_annx, 118);
    if (n >= 56)  product_annx = annx_lwm(values_mid, product_annx, 119);
    if (n >= 57)  product_annx = annx_lwm(values_mid, product_annx, 120);
    if (n >= 58)  product_annx = annx_lwm(values_mid, product_annx, 121);
    if (n >= 59)  product_annx = annx_lwm(values_mid, product_annx, 122);
    if (n >= 60)  product_annx = annx_lwm(values_mid, product_annx, 123);
    if (n >= 61)  product_annx = annx_lwm(values_mid, product_annx, 124);
    if (n >= 62)  product_annx = annx_lwm(values_mid, product_annx, 125);
    if (n >= 63)  product_annx = annx_lwm(values_mid, product_annx, 126);
    if (n >= 64)  product_annx = annx_lwm(values_mid, product_annx, 127);
    if (n >= 65)  product_annx = annx_lwm(values_mid, product_annx, 0);
    if (n >= 66)  product_annx = annx_lwm(values_mid, product_annx, 1);
    if (n >= 67)  product_annx = annx_lwm(values_mid, product_annx, 2);
    if (n >= 68)  product_annx = annx_lwm(values_mid, product_annx, 3);
    if (n >= 69)  product_annx = annx_lwm(values_mid, product_annx, 4);
    if (n >= 70)  product_annx = annx_lwm(values_mid, product_annx, 5);
    if (n >= 71)  product_annx = annx_lwm(values_mid, product_annx, 6);
    if (n >= 72)  product_annx = annx_lwm(values_mid, product_annx, 7);
    if (n >= 73)  product_annx = annx_lwm(values_mid, product_annx, 8);
    if (n >= 74)  product_annx = annx_lwm(values_mid, product_annx, 9);
    if (n >= 75)  product_annx = annx_lwm(values_mid, product_annx, 10);
    if (n >= 76)  product_annx = annx_lwm(values_mid, product_annx, 11);
    if (n >= 77)  product_annx = annx_lwm(values_mid, product_annx, 12);
    if (n >= 78)  product_annx = annx_lwm(values_mid, product_annx, 13);
    if (n >= 79)  product_annx = annx_lwm(values_mid, product_annx, 14);
    if (n >= 80)  product_annx = annx_lwm(values_mid, product_annx, 15);
    if (n >= 81)  product_annx = annx_lwm(values_mid, product_annx, 16);
    if (n >= 82)  product_annx = annx_lwm(values_mid, product_annx, 17);
    if (n >= 83)  product_annx = annx_lwm(values_mid, product_annx, 18);
    if (n >= 84)  product_annx = annx_lwm(values_mid, product_annx, 19);
    if (n >= 85)  product_annx = annx_lwm(values_mid, product_annx, 20);
    if (n >= 86)  product_annx = annx_lwm(values_mid, product_annx, 21);
    if (n >= 87)  product_annx = annx_lwm(values_mid, product_annx, 22);
    if (n >= 88)  product_annx = annx_lwm(values_mid, product_annx, 23);
    if (n >= 89)  product_annx = annx_lwm(values_mid, product_annx, 24);
    if (n >= 90)  product_annx = annx_lwm(values_mid, product_annx, 25);
    if (n >= 91)  product_annx = annx_lwm(values_mid, product_annx, 26);
    if (n >= 92)  product_annx = annx_lwm(values_mid, product_annx, 27);
    if (n >= 93)  product_annx = annx_lwm(values_mid, product_annx, 28);
    if (n >= 94)  product_annx = annx_lwm(values_mid, product_annx, 29);
    if (n >= 95)  product_annx = annx_lwm(values_mid, product_annx, 30);
    if (n >= 96)  product_annx = annx_lwm(values_mid, product_annx, 31);
    if (n >= 97)  product_annx = annx_lwm(values_mid, product_annx, 32);
    if (n >= 98)  product_annx = annx_lwm(values_mid, product_annx, 33);
    if (n >= 99)  product_annx = annx_lwm(values_mid, product_annx, 34);
    if (n >= 100) product_annx = annx_lwm(values_mid, product_annx, 35);
    if (n >= 101) product_annx = annx_lwm(values_mid, product_annx, 36);
    if (n >= 102) product_annx = annx_lwm(values_mid, product_annx, 37);
    if (n >= 103) product_annx = annx_lwm(values_mid, product_annx, 38);
    if (n >= 104) product_annx = annx_lwm(values_mid, product_annx, 39);
    if (n >= 105) product_annx = annx_lwm(values_mid, product_annx, 40);
    if (n >= 106) product_annx = annx_lwm(values_mid, product_annx, 41);
    if (n >= 107) product_annx = annx_lwm(values_mid, product_annx, 42);
    if (n >= 108) product_annx = annx_lwm(values_mid, product_annx, 43);
    if (n >= 109) product_annx = annx_lwm(values_mid, product_annx, 44);
    if (n >= 110) product_annx = annx_lwm(values_mid, product_annx, 45);
    if (n >= 111) product_annx = annx_lwm(values_mid, product_annx, 46);
    if (n >= 112) product_annx = annx_lwm(values_mid, product_annx, 47);
    if (n >= 113) product_annx = annx_lwm(values_mid, product_annx, 48);
    if (n >= 114) product_annx = annx_lwm(values_mid, product_annx, 49);
    if (n >= 115) product_annx = annx_lwm(values_mid, product_annx, 50);
    if (n >= 116) product_annx = annx_lwm(values_mid, product_annx, 51);
    if (n >= 117) product_annx = annx_lwm(values_mid, product_annx, 52);
    if (n >= 118) product_annx = annx_lwm(values_mid, product_annx, 53);
    if (n >= 119) product_annx = annx_lwm(values_mid, product_annx, 54);
    if (n >= 120) product_annx = annx_lwm(values_mid, product_annx, 55);
    if (n >= 121) product_annx = annx_lwm(values_mid, product_annx, 56);
    if (n >= 122) product_annx = annx_lwm(values_mid, product_annx, 57);
    if (n >= 123) product_annx = annx_lwm(values_mid, product_annx, 58);
    if (n >= 124) product_annx = annx_lwm(values_mid, product_annx, 59);
    if (n >= 125) product_annx = annx_lwm(values_mid, product_annx, 60);
    if (n >= 126) product_annx = annx_lwm(values_mid, product_annx, 61);
    if (n >= 127) product_annx = annx_lwm(values_mid, product_annx, 62);
    if (n >= 128) product_annx = annx_lwm(values_mid, product_annx, 63);
    end_annx = neorv32_cpu_csr_read(CSR_CYCLE);
    elapsed_annx = end_annx - start_annx;

    // Speedup as integer percentage
    uint32_t speedup_pct = elapsed_base > elapsed_annx ?
                           elapsed_base * 100 / elapsed_annx : 0;

    neorv32_uart0_printf("N=%d\n", n);
    neorv32_uart0_printf("  Base: product="); print_q16(product_base);
    neorv32_uart0_printf(", cycles=%u\n", elapsed_base);
    neorv32_uart0_printf("  ANNX: product="); print_q16(product_annx);
    neorv32_uart0_printf(", cycles=%u\n", elapsed_annx);
    neorv32_uart0_printf("  Speedup: %u%%\n\n", speedup_pct);
}

int main(void) {

    neorv32_uart0_setup(BAUD_RATE, 0);
    neorv32_uart0_printf("========= LWM Stress Test: Pi Operation =========\n");
    neorv32_uart0_printf("=================================================\n\n");

    run_test(1);
    run_test(2);
    run_test(5);
    run_test(10);
    run_test(50);
    run_test(100);
    run_test(128); // Max word_offset range (-64 to 63 = 128 words)

    neorv32_uart0_printf("====================== Done =====================\n");
    neorv32_uart0_printf("=================================================\n\n");

    return 0;
}