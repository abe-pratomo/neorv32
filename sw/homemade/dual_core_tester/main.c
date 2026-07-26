#include <neorv32.h>
#define BAUD_RATE 19200

volatile uint8_t __attribute__ ((aligned (16))) core1_stack[2048];
volatile uint32_t done_core1 = 0;
const uint32_t a = 3;
const uint32_t b = 6;
uint32_t c0;
uint32_t c1;

uint64_t core0_start, core0_end;
uint64_t core1_start, core1_end;

int core1_entry(void) {
    core1_start = neorv32_clint_time_get();   // shared MTIME, comparable across cores
    c1 = a * b;
    core1_end = neorv32_clint_time_get();
    done_core1 = 1;
    return 0;
}

int main(void) {
    neorv32_uart0_setup(BAUD_RATE, 0);
    neorv32_uart0_printf("== NEORV32 DUAL-CORE SPEED COMPARATOR ==\n\n");

    uint32_t c0 = neorv32_cpu_csr_read(CSR_CYCLE);
    uint64_t t0 = neorv32_clint_time_get();
    while ((neorv32_cpu_csr_read(CSR_CYCLE) - c0) < 1000000);
    uint64_t t1 = neorv32_clint_time_get();
    uint32_t c1 = neorv32_cpu_csr_read(CSR_CYCLE);

    uint32_t cycles_elapsed = c1 - c0;
    uint32_t ticks_elapsed  = (uint32_t)(t1 - t0);  // fine since t1-t0 « 2^32 here

    neorv32_uart0_printf("CPU cycles elapsed: %u\n", cycles_elapsed);
    neorv32_uart0_printf("MTIME ticks elapsed: %u\n\n", ticks_elapsed);

    neorv32_smp_launch(core1_entry, (uint8_t*)core1_stack, sizeof(core1_stack));

    core0_start = neorv32_clint_time_get();
    c0 = a * b;
    core0_end = neorv32_clint_time_get();

    while (!done_core1);   // barrier — wait for core1 before reading its timestamps

    uint32_t core0_start_lo = (uint32_t)(core0_start & 0xFFFFFFFF);
    uint32_t core0_start_hi = (uint32_t)(core0_start >> 32);
    uint32_t core0_end_lo   = (uint32_t)(core0_end & 0xFFFFFFFF);
    uint32_t core0_end_hi   = (uint32_t)(core0_end >> 32);

    uint32_t core1_start_lo = (uint32_t)(core1_start & 0xFFFFFFFF);
    uint32_t core1_start_hi = (uint32_t)(core1_start >> 32);
    uint32_t core1_end_lo   = (uint32_t)(core1_end & 0xFFFFFFFF);
    uint32_t core1_end_hi   = (uint32_t)(core1_end >> 32);

    neorv32_uart0_printf("Core 0: start=%u end=%u\n", core0_start_lo, core0_end_lo);
    neorv32_uart0_printf("Core 1: start=%u end=%u\n", core1_start_lo, core1_end_lo);

    if (core0_start < core1_start)
        neorv32_uart0_printf("Core 0 started first (by %u MTIME ticks)\n", core1_start - core0_start);
    else
        neorv32_uart0_printf("Core 1 started first (by %u MTIME ticks)\n", core0_start - core1_start);

    return 0;
}