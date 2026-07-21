#include <neorv32.h>
#include <stdint.h>
#include <neorv32_cust_annx.h>
#include <neorv32_q16_helper.h>

#define BAUD_RATE 19200

int32_t values[128] = {
    TO_Q16( 2.4375 ), TO_Q16(-1.6875 ), TO_Q16( 0.8125 ), TO_Q16(-3.1250 ), TO_Q16( 1.5625 ), TO_Q16(-0.9375 ), TO_Q16( 2.21875), TO_Q16(-2.78125),
    TO_Q16( 3.4375 ), TO_Q16(-1.15625), TO_Q16( 0.59375), TO_Q16(-2.46875), TO_Q16( 1.90625), TO_Q16(-3.71875), TO_Q16( 2.65625), TO_Q16(-0.46875),
    TO_Q16(-2.3125 ), TO_Q16( 3.15625), TO_Q16(-1.96875), TO_Q16( 0.71875), TO_Q16( 2.84375), TO_Q16(-1.28125), TO_Q16( 3.6875 ), TO_Q16(-2.15625),
    TO_Q16( 1.1875 ), TO_Q16(-0.84375), TO_Q16( 2.53125), TO_Q16(-3.59375), TO_Q16( 1.46875), TO_Q16(-2.71875), TO_Q16( 0.96875), TO_Q16( 3.28125),
    TO_Q16(-1.59375), TO_Q16( 2.96875), TO_Q16(-3.3125 ), TO_Q16( 1.71875), TO_Q16(-0.53125), TO_Q16( 2.15625), TO_Q16(-2.84375), TO_Q16( 3.53125),
    TO_Q16(-1.09375), TO_Q16( 0.65625), TO_Q16(-3.78125), TO_Q16( 2.40625), TO_Q16(-1.40625), TO_Q16( 3.0625 ), TO_Q16(-2.09375), TO_Q16( 1.84375),
    TO_Q16( 0.40625), TO_Q16(-2.65625), TO_Q16( 3.84375), TO_Q16(-1.53125), TO_Q16( 2.09375), TO_Q16(-0.71875), TO_Q16( 3.21875), TO_Q16(-2.34375),
    TO_Q16( 1.65625), TO_Q16(-3.4375 ), TO_Q16( 0.90625), TO_Q16(-1.21875), TO_Q16( 2.78125), TO_Q16(-2.96875), TO_Q16( 3.46875), TO_Q16(-0.59375),
    TO_Q16( 1.03125), TO_Q16(-2.46875), TO_Q16( 3.59375), TO_Q16(-1.78125), TO_Q16( 0.53125), TO_Q16(-3.09375), TO_Q16( 2.28125), TO_Q16(-1.34375),
    TO_Q16( 3.15625), TO_Q16(-2.53125), TO_Q16( 1.28125), TO_Q16(-0.90625), TO_Q16( 2.71875), TO_Q16(-3.65625), TO_Q16( 1.90625), TO_Q16(-2.03125),
    TO_Q16( 3.78125), TO_Q16(-1.46875), TO_Q16( 0.78125), TO_Q16(-2.21875), TO_Q16( 1.59375), TO_Q16(-3.28125), TO_Q16( 2.96875), TO_Q16(-0.40625),
    TO_Q16( 3.34375), TO_Q16(-1.90625), TO_Q16( 2.15625), TO_Q16(-2.78125), TO_Q16( 0.65625), TO_Q16(-3.53125), TO_Q16( 1.34375), TO_Q16(-2.59375),
    TO_Q16( 3.09375), TO_Q16(-0.84375), TO_Q16( 2.40625), TO_Q16(-1.65625), TO_Q16( 0.96875), TO_Q16(-3.84375), TO_Q16( 2.53125), TO_Q16(-2.15625),
    TO_Q16( 1.71875), TO_Q16(-0.53125), TO_Q16( 3.6875 ), TO_Q16(-1.09375), TO_Q16( 2.84375), TO_Q16(-3.15625), TO_Q16( 0.59375), TO_Q16(-2.90625),
    TO_Q16( 1.46875), TO_Q16(-3.71875), TO_Q16( 2.21875), TO_Q16(-0.65625), TO_Q16( 3.53125), TO_Q16(-1.28125), TO_Q16( 2.65625), TO_Q16(-2.34375),
    TO_Q16( 0.84375), TO_Q16(-3.46875), TO_Q16( 1.15625), TO_Q16(-2.71875), TO_Q16( 3.28125), TO_Q16(-0.96875), TO_Q16( 2.09375), TO_Q16(-1.84375)
};

void run_test(int n) {

    uint64_t start_base = 0, end_base = 0;
    uint64_t start_annx = 0, end_annx = 0;
    uint64_t elapsed_base = 0, elapsed_annx = 0;
    int32_t  sum_base = 0;
    int32_t  sum_annx = 0;

    // Base: software addition (load + add)
    start_base = (uint32_t)neorv32_cpu_csr_read(CSR_CYCLE);
    for (int i = 0; i < n; i++) {
        sum_base += values[i];
    }
    end_base = (uint32_t)neorv32_cpu_csr_read(CSR_CYCLE);
    elapsed_base = end_base - start_base;

    // ANNX: LWA sigma (load + add fused)
    // annx_lwa(base, rs2, word_offset) = MEM[base + word_offset<<2] + rs2
    // accumulate: sum = annx_lwa(values, sum, i) for each i
    uint32_t values_mid = (uint32_t)&values[64];
    start_annx = (uint32_t)neorv32_cpu_csr_read(CSR_CYCLE);
    sum_annx = annx_lwa(values_mid, sum_annx, 64);
    if (n >= 2)   sum_annx = annx_lwa(values_mid, sum_annx, 65);
    if (n >= 3)   sum_annx = annx_lwa(values_mid, sum_annx, 66);
    if (n >= 4)   sum_annx = annx_lwa(values_mid, sum_annx, 67);
    if (n >= 5)   sum_annx = annx_lwa(values_mid, sum_annx, 68);
    if (n >= 6)   sum_annx = annx_lwa(values_mid, sum_annx, 69);
    if (n >= 7)   sum_annx = annx_lwa(values_mid, sum_annx, 70);
    if (n >= 8)   sum_annx = annx_lwa(values_mid, sum_annx, 71);
    if (n >= 9)   sum_annx = annx_lwa(values_mid, sum_annx, 72);
    if (n >= 10)  sum_annx = annx_lwa(values_mid, sum_annx, 73);
    if (n >= 11)  sum_annx = annx_lwa(values_mid, sum_annx, 74);
    if (n >= 12)  sum_annx = annx_lwa(values_mid, sum_annx, 75);
    if (n >= 13)  sum_annx = annx_lwa(values_mid, sum_annx, 76);
    if (n >= 14)  sum_annx = annx_lwa(values_mid, sum_annx, 77);
    if (n >= 15)  sum_annx = annx_lwa(values_mid, sum_annx, 78);
    if (n >= 16)  sum_annx = annx_lwa(values_mid, sum_annx, 79);
    if (n >= 17)  sum_annx = annx_lwa(values_mid, sum_annx, 80);
    if (n >= 18)  sum_annx = annx_lwa(values_mid, sum_annx, 81);
    if (n >= 19)  sum_annx = annx_lwa(values_mid, sum_annx, 82);
    if (n >= 20)  sum_annx = annx_lwa(values_mid, sum_annx, 83);
    if (n >= 21)  sum_annx = annx_lwa(values_mid, sum_annx, 84);
    if (n >= 22)  sum_annx = annx_lwa(values_mid, sum_annx, 85);
    if (n >= 23)  sum_annx = annx_lwa(values_mid, sum_annx, 86);
    if (n >= 24)  sum_annx = annx_lwa(values_mid, sum_annx, 87);
    if (n >= 25)  sum_annx = annx_lwa(values_mid, sum_annx, 88);
    if (n >= 26)  sum_annx = annx_lwa(values_mid, sum_annx, 89);
    if (n >= 27)  sum_annx = annx_lwa(values_mid, sum_annx, 90);
    if (n >= 28)  sum_annx = annx_lwa(values_mid, sum_annx, 91);
    if (n >= 29)  sum_annx = annx_lwa(values_mid, sum_annx, 92);
    if (n >= 30)  sum_annx = annx_lwa(values_mid, sum_annx, 93);
    if (n >= 31)  sum_annx = annx_lwa(values_mid, sum_annx, 94);
    if (n >= 32)  sum_annx = annx_lwa(values_mid, sum_annx, 95);
    if (n >= 33)  sum_annx = annx_lwa(values_mid, sum_annx, 96);
    if (n >= 34)  sum_annx = annx_lwa(values_mid, sum_annx, 97);
    if (n >= 35)  sum_annx = annx_lwa(values_mid, sum_annx, 98);
    if (n >= 36)  sum_annx = annx_lwa(values_mid, sum_annx, 99);
    if (n >= 37)  sum_annx = annx_lwa(values_mid, sum_annx, 100);
    if (n >= 38)  sum_annx = annx_lwa(values_mid, sum_annx, 101);
    if (n >= 39)  sum_annx = annx_lwa(values_mid, sum_annx, 102);
    if (n >= 40)  sum_annx = annx_lwa(values_mid, sum_annx, 103);
    if (n >= 41)  sum_annx = annx_lwa(values_mid, sum_annx, 104);
    if (n >= 42)  sum_annx = annx_lwa(values_mid, sum_annx, 105);
    if (n >= 43)  sum_annx = annx_lwa(values_mid, sum_annx, 106);
    if (n >= 44)  sum_annx = annx_lwa(values_mid, sum_annx, 107);
    if (n >= 45)  sum_annx = annx_lwa(values_mid, sum_annx, 108);
    if (n >= 46)  sum_annx = annx_lwa(values_mid, sum_annx, 109);
    if (n >= 47)  sum_annx = annx_lwa(values_mid, sum_annx, 110);
    if (n >= 48)  sum_annx = annx_lwa(values_mid, sum_annx, 111);
    if (n >= 49)  sum_annx = annx_lwa(values_mid, sum_annx, 112);
    if (n >= 50)  sum_annx = annx_lwa(values_mid, sum_annx, 113);
    if (n >= 51)  sum_annx = annx_lwa(values_mid, sum_annx, 114);
    if (n >= 52)  sum_annx = annx_lwa(values_mid, sum_annx, 115);
    if (n >= 53)  sum_annx = annx_lwa(values_mid, sum_annx, 116);
    if (n >= 54)  sum_annx = annx_lwa(values_mid, sum_annx, 117);
    if (n >= 55)  sum_annx = annx_lwa(values_mid, sum_annx, 118);
    if (n >= 56)  sum_annx = annx_lwa(values_mid, sum_annx, 119);
    if (n >= 57)  sum_annx = annx_lwa(values_mid, sum_annx, 120);
    if (n >= 58)  sum_annx = annx_lwa(values_mid, sum_annx, 121);
    if (n >= 59)  sum_annx = annx_lwa(values_mid, sum_annx, 122);
    if (n >= 60)  sum_annx = annx_lwa(values_mid, sum_annx, 123);
    if (n >= 61)  sum_annx = annx_lwa(values_mid, sum_annx, 124);
    if (n >= 62)  sum_annx = annx_lwa(values_mid, sum_annx, 125);
    if (n >= 63)  sum_annx = annx_lwa(values_mid, sum_annx, 126);
    if (n >= 64)  sum_annx = annx_lwa(values_mid, sum_annx, 127);
    if (n >= 65)  sum_annx = annx_lwa(values_mid, sum_annx, 0);
    if (n >= 66)  sum_annx = annx_lwa(values_mid, sum_annx, 1);
    if (n >= 67)  sum_annx = annx_lwa(values_mid, sum_annx, 2);
    if (n >= 68)  sum_annx = annx_lwa(values_mid, sum_annx, 3);
    if (n >= 69)  sum_annx = annx_lwa(values_mid, sum_annx, 4);
    if (n >= 70)  sum_annx = annx_lwa(values_mid, sum_annx, 5);
    if (n >= 71)  sum_annx = annx_lwa(values_mid, sum_annx, 6);
    if (n >= 72)  sum_annx = annx_lwa(values_mid, sum_annx, 7);
    if (n >= 73)  sum_annx = annx_lwa(values_mid, sum_annx, 8);
    if (n >= 74)  sum_annx = annx_lwa(values_mid, sum_annx, 9);
    if (n >= 75)  sum_annx = annx_lwa(values_mid, sum_annx, 10);
    if (n >= 76)  sum_annx = annx_lwa(values_mid, sum_annx, 11);
    if (n >= 77)  sum_annx = annx_lwa(values_mid, sum_annx, 12);
    if (n >= 78)  sum_annx = annx_lwa(values_mid, sum_annx, 13);
    if (n >= 79)  sum_annx = annx_lwa(values_mid, sum_annx, 14);
    if (n >= 80)  sum_annx = annx_lwa(values_mid, sum_annx, 15);
    if (n >= 81)  sum_annx = annx_lwa(values_mid, sum_annx, 16);
    if (n >= 82)  sum_annx = annx_lwa(values_mid, sum_annx, 17);
    if (n >= 83)  sum_annx = annx_lwa(values_mid, sum_annx, 18);
    if (n >= 84)  sum_annx = annx_lwa(values_mid, sum_annx, 19);
    if (n >= 85)  sum_annx = annx_lwa(values_mid, sum_annx, 20);
    if (n >= 86)  sum_annx = annx_lwa(values_mid, sum_annx, 21);
    if (n >= 87)  sum_annx = annx_lwa(values_mid, sum_annx, 22);
    if (n >= 88)  sum_annx = annx_lwa(values_mid, sum_annx, 23);
    if (n >= 89)  sum_annx = annx_lwa(values_mid, sum_annx, 24);
    if (n >= 90)  sum_annx = annx_lwa(values_mid, sum_annx, 25);
    if (n >= 91)  sum_annx = annx_lwa(values_mid, sum_annx, 26);
    if (n >= 92)  sum_annx = annx_lwa(values_mid, sum_annx, 27);
    if (n >= 93)  sum_annx = annx_lwa(values_mid, sum_annx, 28);
    if (n >= 94)  sum_annx = annx_lwa(values_mid, sum_annx, 29);
    if (n >= 95)  sum_annx = annx_lwa(values_mid, sum_annx, 30);
    if (n >= 96)  sum_annx = annx_lwa(values_mid, sum_annx, 31);
    if (n >= 97)  sum_annx = annx_lwa(values_mid, sum_annx, 32);
    if (n >= 98)  sum_annx = annx_lwa(values_mid, sum_annx, 33);
    if (n >= 99)  sum_annx = annx_lwa(values_mid, sum_annx, 34);
    if (n >= 100) sum_annx = annx_lwa(values_mid, sum_annx, 35);
    if (n >= 101) sum_annx = annx_lwa(values_mid, sum_annx, 36);
    if (n >= 102) sum_annx = annx_lwa(values_mid, sum_annx, 37);
    if (n >= 103) sum_annx = annx_lwa(values_mid, sum_annx, 38);
    if (n >= 104) sum_annx = annx_lwa(values_mid, sum_annx, 39);
    if (n >= 105) sum_annx = annx_lwa(values_mid, sum_annx, 40);
    if (n >= 106) sum_annx = annx_lwa(values_mid, sum_annx, 41);
    if (n >= 107) sum_annx = annx_lwa(values_mid, sum_annx, 42);
    if (n >= 108) sum_annx = annx_lwa(values_mid, sum_annx, 43);
    if (n >= 109) sum_annx = annx_lwa(values_mid, sum_annx, 44);
    if (n >= 110) sum_annx = annx_lwa(values_mid, sum_annx, 45);
    if (n >= 111) sum_annx = annx_lwa(values_mid, sum_annx, 46);
    if (n >= 112) sum_annx = annx_lwa(values_mid, sum_annx, 47);
    if (n >= 113) sum_annx = annx_lwa(values_mid, sum_annx, 48);
    if (n >= 114) sum_annx = annx_lwa(values_mid, sum_annx, 49);
    if (n >= 115) sum_annx = annx_lwa(values_mid, sum_annx, 50);
    if (n >= 116) sum_annx = annx_lwa(values_mid, sum_annx, 51);
    if (n >= 117) sum_annx = annx_lwa(values_mid, sum_annx, 52);
    if (n >= 118) sum_annx = annx_lwa(values_mid, sum_annx, 53);
    if (n >= 119) sum_annx = annx_lwa(values_mid, sum_annx, 54);
    if (n >= 120) sum_annx = annx_lwa(values_mid, sum_annx, 55);
    if (n >= 121) sum_annx = annx_lwa(values_mid, sum_annx, 56);
    if (n >= 122) sum_annx = annx_lwa(values_mid, sum_annx, 57);
    if (n >= 123) sum_annx = annx_lwa(values_mid, sum_annx, 58);
    if (n >= 124) sum_annx = annx_lwa(values_mid, sum_annx, 59);
    if (n >= 125) sum_annx = annx_lwa(values_mid, sum_annx, 60);
    if (n >= 126) sum_annx = annx_lwa(values_mid, sum_annx, 61);
    if (n >= 127) sum_annx = annx_lwa(values_mid, sum_annx, 62);
    if (n >= 128) sum_annx = annx_lwa(values_mid, sum_annx, 63);
    end_annx = (uint32_t)neorv32_cpu_csr_read(CSR_CYCLE);
    elapsed_annx = end_annx - start_annx;

    // Speedup as fractional
    uint32_t speedup_int  = (uint32_t)(elapsed_base / elapsed_annx);
    uint32_t speedup_frac = (uint32_t)((elapsed_base * 1000ULL / elapsed_annx) % 1000);

    neorv32_uart0_printf("N=%d\n", n);
    neorv32_uart0_printf("  Base: sum="); print_q16(sum_base);
    neorv32_uart0_printf(", cycles=%u\n", (uint32_t)elapsed_base);
    neorv32_uart0_printf("  ANNX: sum="); print_q16(sum_annx);
    neorv32_uart0_printf(", cycles=%u\n", (uint32_t)elapsed_annx);
    const char* dir = elapsed_base >= elapsed_annx ? "faster" : "slower";
    if      (speedup_frac < 10)  neorv32_uart0_printf("  Speedup: %u.00%ux %s\n\n", speedup_int, speedup_frac, dir);
    else if (speedup_frac < 100) neorv32_uart0_printf("  Speedup: %u.0%ux %s\n\n",  speedup_int, speedup_frac, dir);
    else                         neorv32_uart0_printf("  Speedup: %u.%ux %s\n\n",   speedup_int, speedup_frac, dir);
}

int main(void) {

    neorv32_uart0_setup(BAUD_RATE, 0);
    neorv32_uart0_printf("LWA Stress Test: Sigma Operation (No M-Extension)\n");
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