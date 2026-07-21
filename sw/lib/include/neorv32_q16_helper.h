#ifndef NEORV32_Q16_HELPER_H
#define NEORV32_Q16_HELPER_H

#include <neorv32.h>
#include <stdint.h>

#define TO_Q16(x)      ((int32_t)((x) * 65536))
#define Q16_TO_INT(x)  ((x) >> 16)
#define Q16_TO_FRAC(x) ((int32_t)((((x) & 0xFFFF) * 10000) >> 16))

void print_q16(int32_t val) {
    if (val < 0) {
        neorv32_uart0_printf("-");
        val = -val;
    }

    uint32_t i = ((uint32_t)val) >> 16;
    uint32_t f = ((((uint32_t)val & 0xFFFF) * 10000U) + 32768U) >> 16;

    if (f == 10000) {
        i++;
        f = 0;
    }

    neorv32_uart0_printf("%u.", i);

    if      (f < 10)   neorv32_uart0_printf("000%u", f);
    else if (f < 100)  neorv32_uart0_printf("00%u",  f);
    else if (f < 1000) neorv32_uart0_printf("0%u",   f);
    else               neorv32_uart0_printf("%u",    f);
}

#endif // NEORV32_Q16_HELPER_H