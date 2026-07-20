
main.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <__crt0_entry>:
       0:	f14020f3          	csrr	ra,mhartid
       4:	80020217          	auipc	tp,0x80020
       8:	ffc20213          	addi	tp,tp,-4 # 80020000 <__crt0_stack_top>
       c:	ff027113          	andi	sp,tp,-16
      10:	80000197          	auipc	gp,0x80000
      14:	7f018193          	addi	gp,gp,2032 # 80000800 <__global_pointer$>
      18:	000022b7          	lui	t0,0x2
      1c:	80028293          	addi	t0,t0,-2048 # 1800 <__fini_array_end+0x11c>
      20:	30029073          	csrw	mstatus,t0
      24:	00000317          	auipc	t1,0x0
      28:	19430313          	addi	t1,t1,404 # 1b8 <__crt0_panic>
      2c:	30531073          	csrw	mtvec,t1
      30:	30401073          	csrw	mie,zero
      34:	00002397          	auipc	t2,0x2
      38:	c7438393          	addi	t2,t2,-908 # 1ca8 <__crt0_copy_data_src_begin>
      3c:	80000417          	auipc	s0,0x80000
      40:	fc440413          	addi	s0,s0,-60 # 80000000 <o_weights>
      44:	80000497          	auipc	s1,0x80000
      48:	10c48493          	addi	s1,s1,268 # 80000150 <outputs>
      4c:	80000517          	auipc	a0,0x80000
      50:	10450513          	addi	a0,a0,260 # 80000150 <outputs>
      54:	80000597          	auipc	a1,0x80000
      58:	10458593          	addi	a1,a1,260 # 80000158 <__crt0_bss_end>
      5c:	00000613          	li	a2,0
      60:	00000693          	li	a3,0
      64:	00000713          	li	a4,0
      68:	00000793          	li	a5,0
      6c:	00000813          	li	a6,0
      70:	00000893          	li	a7,0
      74:	00000913          	li	s2,0
      78:	00000993          	li	s3,0
      7c:	00000a13          	li	s4,0
      80:	00000a93          	li	s5,0
      84:	00000b13          	li	s6,0
      88:	00000b93          	li	s7,0
      8c:	00000c13          	li	s8,0
      90:	00000c93          	li	s9,0
      94:	00000d13          	li	s10,0
      98:	00000d93          	li	s11,0
      9c:	00000e13          	li	t3,0
      a0:	00000e93          	li	t4,0
      a4:	00000f13          	li	t5,0
      a8:	00000f93          	li	t6,0

000000ac <__crt0_smp_check>:
      ac:	04008463          	beqz	ra,f4 <__crt0_data_copy>

000000b0 <__crt0_smp_setup>:
      b0:	00000797          	auipc	a5,0x0
      b4:	01c78793          	addi	a5,a5,28 # cc <__crt0_smp_wakeup>
      b8:	30579073          	csrw	mtvec,a5
      bc:	30445073          	csrwi	mie,8
      c0:	30046073          	csrsi	mstatus,8

000000c4 <__crt0_smp_sleep>:
      c4:	10500073          	wfi
      c8:	ffdff06f          	j	c4 <__crt0_smp_sleep>

000000cc <__crt0_smp_wakeup>:
      cc:	00000797          	auipc	a5,0x0
      d0:	0ec78793          	addi	a5,a5,236 # 1b8 <__crt0_panic>
      d4:	30579073          	csrw	mtvec,a5
      d8:	30405073          	csrwi	mie,0
      dc:	fff44737          	lui	a4,0xfff44
      e0:	00872103          	lw	sp,8(a4) # fff44008 <__crt0_stack_top+0x7ff24008>
      e4:	00c72603          	lw	a2,12(a4)
      e8:	fff40737          	lui	a4,0xfff40
      ec:	00072223          	sw	zero,4(a4) # fff40004 <__crt0_stack_top+0x7ff20004>
      f0:	05c0006f          	j	14c <__crt0_main_entry>

000000f4 <__crt0_data_copy>:
      f4:	00838e63          	beq	t2,s0,110 <__crt0_bss_clear>
      f8:	00945c63          	bge	s0,s1,110 <__crt0_bss_clear>

000000fc <__crt0_data_copy_loop>:
      fc:	0003a783          	lw	a5,0(t2)
     100:	00f42023          	sw	a5,0(s0)
     104:	00438393          	addi	t2,t2,4
     108:	00440413          	addi	s0,s0,4
     10c:	fe9448e3          	blt	s0,s1,fc <__crt0_data_copy_loop>

00000110 <__crt0_bss_clear>:
     110:	00b55863          	bge	a0,a1,120 <__crt0_bss_clear_end>

00000114 <__crt0_bss_clear_loop>:
     114:	00052023          	sw	zero,0(a0)
     118:	00450513          	addi	a0,a0,4
     11c:	feb54ce3          	blt	a0,a1,114 <__crt0_bss_clear_loop>

00000120 <__crt0_bss_clear_end>:
// (t0-t6, a0-a7, ra). Loop counters use s0/s1 (callee-saved), which are
// preserved by the called functions according to the RISC-V calling convention.
// ************************************************************************************************
#ifndef MAKE_BOOTLOADER
__crt0_constructors_primary:
  la    x8, __init_array_start
     120:	00001417          	auipc	s0,0x1
     124:	5c440413          	addi	s0,s0,1476 # 16e4 <__fini_array_end>
  la    x9, __init_array_end
     128:	00001497          	auipc	s1,0x1
     12c:	5bc48493          	addi	s1,s1,1468 # 16e4 <__fini_array_end>

00000130 <__crt0_constructors>:

__crt0_constructors:
  bge   x8, x9, __crt0_constructors_end  // skip if empty
     130:	00945a63          	bge	s0,s1,144 <__crt0_constructors_end>

00000134 <__crt0_constructors_loop>:

__crt0_constructors_loop:
  lw    x1, 0(x8)
     134:	00042083          	lw	ra,0(s0)
  jalr  x1, 0(x1) // call constructor function; put return address in ra
     138:	000080e7          	jalr	ra
  addi  x8, x8, 4
     13c:	00440413          	addi	s0,s0,4
  blt   x8, x9, __crt0_constructors_loop
     140:	fe944ae3          	blt	s0,s1,134 <__crt0_constructors_loop>

00000144 <__crt0_constructors_end>:

// ************************************************************************************************
// Setup arguments and call main function.
// ************************************************************************************************
__crt0_main_primary:
  la    x12, main         // primary core's (core0) entry point (#1169)
     144:	00000617          	auipc	a2,0x0
     148:	19460613          	addi	a2,a2,404 # 2d8 <main>

0000014c <__crt0_main_entry>:
__crt0_main_entry:
  fence                   // synchronize loads/stores
     14c:	0ff0000f          	fence
  fence.i                 // synchronize instruction fetch
     150:	0000100f          	fence.i
  li    x10, 0            // x10 = a0 = argc = 0
     154:	00000513          	li	a0,0
  li    x11, 0            // x11 = a1 = argv = 0
     158:	00000593          	li	a1,0
  jalr  x1, x12           // call actual main function
     15c:	000600e7          	jalr	a2

00000160 <__crt0_main_exit>:

.global __crt0_main_exit
__crt0_main_exit:         // main's "return" and "exit" will arrive here
  csrci mstatus, 1 << 3   // disable machine-level interrupts
     160:	30047073          	csrci	mstatus,8
  csrw  mie, zero         // disable all interrupt sources
     164:	30401073          	csrw	mie,zero
  la    x11, __crt0_panic // re-install default crt0 trap handler
     168:	00000597          	auipc	a1,0x0
     16c:	05058593          	addi	a1,a1,80 # 1b8 <__crt0_panic>
  csrw  mtvec, x11
     170:	30559073          	csrw	mtvec,a1
  csrw  mscratch, x10     // backup main's return code to mscratch (for debugger or destructors)
     174:	34051073          	csrw	mscratch,a0

00000178 <__crt0_destructors_primary>:
// (t0-t6, a0-a7, ra). Loop counters use s0/s1 (callee-saved), which are
// preserved by the called functions according to the RISC-V calling convention.
// ************************************************************************************************
#ifndef MAKE_BOOTLOADER
__crt0_destructors_primary:
  csrr  x8, mhartid
     178:	f1402473          	csrr	s0,mhartid
  bnez  x8, __crt0_destructors_end // execute destructors only on core 0
     17c:	02041463          	bnez	s0,1a4 <__crt0_destructors_end>

  la    x8, __fini_array_start
     180:	00001417          	auipc	s0,0x1
     184:	56440413          	addi	s0,s0,1380 # 16e4 <__fini_array_end>
  la    x9, __fini_array_end
     188:	00001497          	auipc	s1,0x1
     18c:	55c48493          	addi	s1,s1,1372 # 16e4 <__fini_array_end>

00000190 <__crt0_destructors>:

__crt0_destructors:
  bge   x8, x9, __crt0_destructors_end
     190:	00945a63          	bge	s0,s1,1a4 <__crt0_destructors_end>

00000194 <__crt0_destructors_loop>:

__crt0_destructors_loop:
  lw    x1, 0(x8)
     194:	00042083          	lw	ra,0(s0)
  jalr  x1, 0(x1)                  // call destructor function; put return address in ra
     198:	000080e7          	jalr	ra
  addi  x8, x8, 4
     19c:	00440413          	addi	s0,s0,4
  blt   x8, x9, __crt0_destructors_loop
     1a0:	fe944ae3          	blt	s0,s1,194 <__crt0_destructors_loop>

000001a4 <__crt0_destructors_end>:
// ************************************************************************************************
// Halt CPU. Bootloader should never return; if it does -> panic.
// ************************************************************************************************
#ifndef MAKE_BOOTLOADER
__crt0_halting:
  csrr x8, mhartid
     1a4:	f1402473          	csrr	s0,mhartid
  bnez x8, __crt0_halt
     1a8:	00041463          	bnez	s0,1b0 <__crt0_halt>

000001ac <__crt0_halt_primary>:

.global __crt0_halt_primary
__crt0_halt_primary:
  ebreak     // execution done; try to transfer control to external debugger; otherwise -> panic
     1ac:	00100073          	ebreak

000001b0 <__crt0_halt>:

.global __crt0_halt
__crt0_halt: // same code as trap handler but with different label/address to track origin
  wfi
     1b0:	10500073          	wfi
  j __crt0_halt
     1b4:	ffdff06f          	j	1b0 <__crt0_halt>

000001b8 <__crt0_panic>:
// ************************************************************************************************
.balign 4     // trap handler has to be 32-bit aligned
.option norvc // no compressed instruction to make this valid code on any platform configuration
.global __crt0_panic
__crt0_panic:
  wfi
     1b8:	10500073          	wfi
  j __crt0_panic
     1bc:	ffdff06f          	j	1b8 <__crt0_panic>

000001c0 <exp_pwl>:
// exp_pwl: Q16.16 piecewise-linear exp approximation
// Matches acc_core.vhd exactly
// ============================================================
int32_t exp_pwl(int32_t x)
{
    if (x <= EXP_MIN_INPUT)
     1c0:	fff4f7b7          	lui	a5,0xfff4f
     1c4:	8e078793          	addi	a5,a5,-1824 # fff4e8e0 <__crt0_stack_top+0x7ff2e8e0>
     1c8:	0af54e63          	blt	a0,a5,284 <exp_pwl+0xc4>
        return 0;

    if (x >= EXP_MAX_INPUT)
     1cc:	000a67b7          	lui	a5,0xa6
     1d0:	5ae78793          	addi	a5,a5,1454 # a65ae <__neorv32_ram_size+0x865ae>
     1d4:	0aa7cc63          	blt	a5,a0,28c <exp_pwl+0xcc>
     1d8:	00002737          	lui	a4,0x2
     1dc:	a2870713          	addi	a4,a4,-1496 # 1a28 <BOUNDARY>

    // Find segment
    int32_t m = SLOPE[31];
    int64_t b = INTERCEPT[31];

    for (int i = 0; i < 31; i++) {
     1e0:	00000793          	li	a5,0
     1e4:	01f00693          	li	a3,31
        if (x < BOUNDARY[i]) {
     1e8:	00072603          	lw	a2,0(a4)
     1ec:	06c55a63          	bge	a0,a2,260 <exp_pwl+0xa0>
            m = SLOPE[i];
     1f0:	00002737          	lui	a4,0x2
     1f4:	00279693          	slli	a3,a5,0x2
     1f8:	9a870713          	addi	a4,a4,-1624 # 19a8 <SLOPE>
     1fc:	00d70733          	add	a4,a4,a3
            b = INTERCEPT[i];
     200:	000026b7          	lui	a3,0x2
     204:	00379793          	slli	a5,a5,0x3
     208:	8a868693          	addi	a3,a3,-1880 # 18a8 <INTERCEPT>
     20c:	00f686b3          	add	a3,a3,a5
            m = SLOPE[i];
     210:	00072703          	lw	a4,0(a4)
            b = INTERCEPT[i];
     214:	0006a783          	lw	a5,0(a3)
     218:	0046a603          	lw	a2,4(a3)
            break;
        }
    }

    int64_t mult     = (int64_t)m * (int64_t)x;
     21c:	02a706b3          	mul	a3,a4,a0
     220:	02a71733          	mulh	a4,a4,a0
    int64_t result64 = (mult >> FRAC_WIDTH) + b;
     224:	0106d693          	srli	a3,a3,0x10
     228:	01071593          	slli	a1,a4,0x10
     22c:	00d5e6b3          	or	a3,a1,a3
     230:	41075713          	srai	a4,a4,0x10
     234:	00f68533          	add	a0,a3,a5
     238:	00d536b3          	sltu	a3,a0,a3
     23c:	00c70733          	add	a4,a4,a2
     240:	00e686b3          	add	a3,a3,a4

    if (result64 <= 0)
     244:	04d04463          	bgtz	a3,28c <exp_pwl+0xcc>
     248:	02069e63          	bnez	a3,284 <exp_pwl+0xc4>
     24c:	02050c63          	beqz	a0,284 <exp_pwl+0xc4>
        return 0;
    else if (result64 >= (int64_t)INT32_MAX_VAL)
     250:	800007b7          	lui	a5,0x80000
     254:	ffe78793          	addi	a5,a5,-2 # 7ffffffe <__neorv32_ram_size+0x7ffdfffe>
     258:	02a7ea63          	bltu	a5,a0,28c <exp_pwl+0xcc>
        return INT32_MAX_VAL;
    else
        return (int32_t)result64;
     25c:	00008067          	ret
    for (int i = 0; i < 31; i++) {
     260:	00178793          	addi	a5,a5,1
     264:	00470713          	addi	a4,a4,4
     268:	f8d790e3          	bne	a5,a3,1e8 <exp_pwl+0x28>
    int64_t b = INTERCEPT[31];
     26c:	ba3b07b7          	lui	a5,0xba3b0
    int32_t m = SLOPE[31];
     270:	5c87d737          	lui	a4,0x5c87d
    int64_t b = INTERCEPT[31];
     274:	51a78793          	addi	a5,a5,1306 # ba3b051a <__crt0_stack_top+0x3a39051a>
     278:	ffc00613          	li	a2,-4
    int32_t m = SLOPE[31];
     27c:	5ba70713          	addi	a4,a4,1466 # 5c87d5ba <__neorv32_ram_size+0x5c85d5ba>
     280:	f9dff06f          	j	21c <exp_pwl+0x5c>
        return 0;
     284:	00000513          	li	a0,0
     288:	00008067          	ret
        return INT32_MAX_VAL;
     28c:	80000537          	lui	a0,0x80000
     290:	fff50513          	addi	a0,a0,-1 # 7fffffff <__neorv32_ram_size+0x7ffdffff>
}
     294:	00008067          	ret

00000298 <sigmoid_q16>:
// ============================================================
// sigmoid_q16: sigma(x) = exp(x) / (1 + exp(x)) in Q16.16
// Requires M extension for division
// ============================================================
int32_t sigmoid_q16(int32_t x)
{
     298:	ff010113          	addi	sp,sp,-16
     29c:	00112623          	sw	ra,12(sp)
    int32_t exp_x  = exp_pwl(x);
     2a0:	f21ff0ef          	jal	1c0 <exp_pwl>
    int64_t num    = (int64_t)exp_x << FRAC_WIDTH;
    int64_t denom  = (int64_t)65536 + (int64_t)exp_x;
     2a4:	00010637          	lui	a2,0x10
    int64_t num    = (int64_t)exp_x << FRAC_WIDTH;
     2a8:	41f55793          	srai	a5,a0,0x1f
    int64_t denom  = (int64_t)65536 + (int64_t)exp_x;
     2ac:	00c50633          	add	a2,a0,a2
     2b0:	00a636b3          	sltu	a3,a2,a0
    int64_t num    = (int64_t)exp_x << FRAC_WIDTH;
     2b4:	01055593          	srli	a1,a0,0x10
     2b8:	01079713          	slli	a4,a5,0x10
    return (int32_t)(num / denom);
     2bc:	00f686b3          	add	a3,a3,a5
     2c0:	01051513          	slli	a0,a0,0x10
     2c4:	00e5e5b3          	or	a1,a1,a4
     2c8:	279000ef          	jal	d40 <__divdi3>
}
     2cc:	00c12083          	lw	ra,12(sp)
     2d0:	01010113          	addi	sp,sp,16
     2d4:	00008067          	ret

000002d8 <main>:
    {  20998,   18766}  // b3
};

int32_t outputs[o_neuron];

int main() {
     2d8:	fc010113          	addi	sp,sp,-64
/**********************************************************************//**
 * Get current processor clock frequency.
 * @return Clock frequency in Hz.
 **************************************************************************/
inline uint32_t __attribute__ ((always_inline)) neorv32_sysinfo_get_clk(void) {
  return NEORV32_SYSINFO->CLK;
     2dc:	fffe07b7          	lui	a5,0xfffe0
    // Get the actual CPU clock frequency
    uint32_t NEORV32_CLK = neorv32_sysinfo_get_clk();

    // Initialize UART at 19200 baud
    if (!neorv32_uart0_available()) return -1;
     2e0:	fff50537          	lui	a0,0xfff50
int main() {
     2e4:	03212823          	sw	s2,48(sp)
     2e8:	02112e23          	sw	ra,60(sp)
     2ec:	0007a903          	lw	s2,0(a5) # fffe0000 <__crt0_stack_top+0x7ffc0000>
     2f0:	02812c23          	sw	s0,56(sp)
     2f4:	02912a23          	sw	s1,52(sp)
     2f8:	03312623          	sw	s3,44(sp)
     2fc:	03412423          	sw	s4,40(sp)
     300:	03512223          	sw	s5,36(sp)
     304:	03612023          	sw	s6,32(sp)
     308:	01712e23          	sw	s7,28(sp)
     30c:	01812c23          	sw	s8,24(sp)
     310:	01912a23          	sw	s9,20(sp)
    if (!neorv32_uart0_available()) return -1;
     314:	43c000ef          	jal	750 <neorv32_uart_available>
     318:	fff00793          	li	a5,-1
     31c:	32050c63          	beqz	a0,654 <main+0x37c>
    neorv32_uart0_setup(BAUD_RATE, 0);
     320:	000055b7          	lui	a1,0x5
     324:	00000613          	li	a2,0
     328:	b0058593          	addi	a1,a1,-1280 # 4b00 <__neorv32_heap_size+0x2b00>
     32c:	fff50537          	lui	a0,0xfff50
     330:	45c000ef          	jal	78c <neorv32_uart_setup>

    // Print banner
    neorv32_uart0_printf("============= NEORV32 ANN Base Example =============\n");
     334:	000015b7          	lui	a1,0x1
     338:	6f458593          	addi	a1,a1,1780 # 16f4 <__fini_array_end+0x10>
     33c:	fff50537          	lui	a0,0xfff50
     340:	738000ef          	jal	a78 <neorv32_uart_printf>
    neorv32_uart0_printf("=== ANN for Indonesian Food Preference Detection ===\n");
     344:	000015b7          	lui	a1,0x1
     348:	72c58593          	addi	a1,a1,1836 # 172c <__fini_array_end+0x48>
     34c:	fff50537          	lui	a0,0xfff50
     350:	728000ef          	jal	a78 <neorv32_uart_printf>
    neorv32_uart0_printf("====================================================\n\n");
     354:	000014b7          	lui	s1,0x1
     358:	76448593          	addi	a1,s1,1892 # 1764 <__fini_array_end+0x80>
     35c:	fff50537          	lui	a0,0xfff50
     360:	718000ef          	jal	a78 <neorv32_uart_printf>

    // Print taste values
    neorv32_uart0_printf("Input Taste Values:\n");
     364:	000015b7          	lui	a1,0x1
     368:	79c58593          	addi	a1,a1,1948 # 179c <__fini_array_end+0xb8>
     36c:	fff50537          	lui	a0,0xfff50
     370:	708000ef          	jal	a78 <neorv32_uart_printf>
    neorv32_uart0_printf("Sourness: %d.%04d\n"
     374:	93c18793          	addi	a5,gp,-1732 # 8000013c <inputs>
     378:	0007a603          	lw	a2,0(a5)
     37c:	0087a803          	lw	a6,8(a5)
     380:	00c7a303          	lw	t1,12(a5)
     384:	0047a703          	lw	a4,4(a5)
     388:	01081893          	slli	a7,a6,0x10
     38c:	01061693          	slli	a3,a2,0x10
     390:	01071793          	slli	a5,a4,0x10
     394:	01031513          	slli	a0,t1,0x10
     398:	000025b7          	lui	a1,0x2
     39c:	71058593          	addi	a1,a1,1808 # 2710 <__neorv32_heap_size+0x710>
     3a0:	01055513          	srli	a0,a0,0x10
     3a4:	0108d893          	srli	a7,a7,0x10
     3a8:	0107d793          	srli	a5,a5,0x10
     3ac:	0106d693          	srli	a3,a3,0x10
     3b0:	02b888b3          	mul	a7,a7,a1
     3b4:	41035313          	srai	t1,t1,0x10
     3b8:	00612023          	sw	t1,0(sp)
     3bc:	41085813          	srai	a6,a6,0x10
     3c0:	41075713          	srai	a4,a4,0x10
     3c4:	41065613          	srai	a2,a2,0x10
     3c8:	02b787b3          	mul	a5,a5,a1
     3cc:	0108d893          	srli	a7,a7,0x10
     3d0:	02b686b3          	mul	a3,a3,a1
     3d4:	0107d793          	srli	a5,a5,0x10
     3d8:	02b505b3          	mul	a1,a0,a1
     3dc:	0106d693          	srli	a3,a3,0x10
     3e0:	fff50537          	lui	a0,0xfff50
     3e4:	4105d593          	srai	a1,a1,0x10
     3e8:	00b12223          	sw	a1,4(sp)
     3ec:	000015b7          	lui	a1,0x1
     3f0:	7b458593          	addi	a1,a1,1972 # 17b4 <__fini_array_end+0xd0>
     3f4:	684000ef          	jal	a78 <neorv32_uart_printf>
 * @return Read data (uint32_t).
 **************************************************************************/
inline uint32_t __attribute__ ((always_inline)) neorv32_cpu_csr_read(const int csr_id) {

  uint32_t csr_data;
  asm volatile ("csrr %[dst], %[id]" : [dst] "=r" (csr_data) : [id] "i" (csr_id));
     3f8:	c00029f3          	rdcycle	s3

    // Start calculation
    uint32_t start_time = neorv32_cpu_csr_read(CSR_CYCLE);

    // Hidden Layer 1 computation
    for (int i = 0; i < h1_neuron; i++) {
     3fc:	93c18a13          	addi	s4,gp,-1732 # 8000013c <inputs>
     400:	00000413          	li	s0,0
     404:	014a0c13          	addi	s8,s4,20
     408:	01400c93          	li	s9,20
        int64_t sum = 0;
        for (int j = 0; j < l1_inputs; j++) {
     40c:	8d818713          	addi	a4,gp,-1832 # 800000d8 <h1_weights>
     410:	000a0613          	mv	a2,s4
     414:	00e40733          	add	a4,s0,a4
        int64_t sum = 0;
     418:	00000513          	li	a0,0
            sum += ((int64_t)inputs[j] * (int64_t)h1_weights[j][i]) >> FRAC_WIDTH;
     41c:	00062783          	lw	a5,0(a2) # 10000 <__neorv32_heap_size+0xe000>
     420:	00072583          	lw	a1,0(a4)
        for (int j = 0; j < l1_inputs; j++) {
     424:	00460613          	addi	a2,a2,4
     428:	01470713          	addi	a4,a4,20
            sum += ((int64_t)inputs[j] * (int64_t)h1_weights[j][i]) >> FRAC_WIDTH;
     42c:	02b786b3          	mul	a3,a5,a1
     430:	02b797b3          	mulh	a5,a5,a1
     434:	0106d693          	srli	a3,a3,0x10
     438:	01079793          	slli	a5,a5,0x10
     43c:	00d7e6b3          	or	a3,a5,a3
     440:	00d50533          	add	a0,a0,a3
        for (int j = 0; j < l1_inputs; j++) {
     444:	fd861ce3          	bne	a2,s8,41c <main+0x144>
        }
        h1_outputs[i] = sigmoid_q16((int32_t)sum);
     448:	e51ff0ef          	jal	298 <sigmoid_q16>
     44c:	8c018793          	addi	a5,gp,-1856 # 800000c0 <h1_outputs>
     450:	00f407b3          	add	a5,s0,a5
     454:	00a7a023          	sw	a0,0(a5)
    for (int i = 0; i < h1_neuron; i++) {
     458:	00440413          	addi	s0,s0,4
     45c:	8c018a93          	addi	s5,gp,-1856 # 800000c0 <h1_outputs>
     460:	fb9416e3          	bne	s0,s9,40c <main+0x134>
     464:	00000a13          	li	s4,0
     468:	80000b37          	lui	s6,0x80000
     46c:	018a8b93          	addi	s7,s5,24
    }

    // Hidden Layer 2 computation
    for (int i = 0; i < h2_neuron; i++) {
     470:	01400c13          	li	s8,20
        int64_t sum = 0;
        for (int j = 0; j < l2_inputs; j++) {
     474:	048b0713          	addi	a4,s6,72 # 80000048 <h2_weights>
     478:	000a8613          	mv	a2,s5
     47c:	00ea0733          	add	a4,s4,a4
        int64_t sum = 0;
     480:	00000513          	li	a0,0
            sum += ((int64_t)h1_outputs[j] * (int64_t)h2_weights[j][i]) >> FRAC_WIDTH;
     484:	00062783          	lw	a5,0(a2)
     488:	00072583          	lw	a1,0(a4)
        for (int j = 0; j < l2_inputs; j++) {
     48c:	00460613          	addi	a2,a2,4
     490:	01470713          	addi	a4,a4,20
            sum += ((int64_t)h1_outputs[j] * (int64_t)h2_weights[j][i]) >> FRAC_WIDTH;
     494:	02b786b3          	mul	a3,a5,a1
     498:	02b797b3          	mulh	a5,a5,a1
     49c:	0106d693          	srli	a3,a3,0x10
     4a0:	01079793          	slli	a5,a5,0x10
     4a4:	00d7e6b3          	or	a3,a5,a3
     4a8:	00d50533          	add	a0,a0,a3
        for (int j = 0; j < l2_inputs; j++) {
     4ac:	fccb9ce3          	bne	s7,a2,484 <main+0x1ac>
        }
        h2_outputs[i] = sigmoid_q16((int32_t)sum);
     4b0:	de9ff0ef          	jal	298 <sigmoid_q16>
     4b4:	83018793          	addi	a5,gp,-2000 # 80000030 <h2_outputs>
     4b8:	00fa07b3          	add	a5,s4,a5
     4bc:	00a7a023          	sw	a0,0(a5)
    for (int i = 0; i < h2_neuron; i++) {
     4c0:	004a0a13          	addi	s4,s4,4
     4c4:	fb8a18e3          	bne	s4,s8,474 <main+0x19c>
    }

    // Output Layer computation
    for (int i = 0; i < o_neuron; i++) {
        int64_t sum = 0;
        for (int j = 0; j < l3_inputs; j++) {
     4c8:	83018a13          	addi	s4,gp,-2000 # 80000030 <h2_outputs>
     4cc:	800006b7          	lui	a3,0x80000
     4d0:	00068693          	mv	a3,a3
     4d4:	018a0a93          	addi	s5,s4,24
    for (int i = 0; i < h2_neuron; i++) {
     4d8:	83018793          	addi	a5,gp,-2000 # 80000030 <h2_outputs>
        int64_t sum = 0;
     4dc:	00000513          	li	a0,0
            sum += ((int64_t)h2_outputs[j] * (int64_t)o_weights[j][i]) >> FRAC_WIDTH;
     4e0:	0006a703          	lw	a4,0(a3) # 80000000 <o_weights>
     4e4:	0007a583          	lw	a1,0(a5)
        for (int j = 0; j < l3_inputs; j++) {
     4e8:	00478793          	addi	a5,a5,4
     4ec:	00868693          	addi	a3,a3,8
            sum += ((int64_t)h2_outputs[j] * (int64_t)o_weights[j][i]) >> FRAC_WIDTH;
     4f0:	02b70633          	mul	a2,a4,a1
     4f4:	02b71733          	mulh	a4,a4,a1
     4f8:	01065613          	srli	a2,a2,0x10
     4fc:	01071713          	slli	a4,a4,0x10
     500:	00c76633          	or	a2,a4,a2
     504:	00c50533          	add	a0,a0,a2
        for (int j = 0; j < l3_inputs; j++) {
     508:	fcfa9ce3          	bne	s5,a5,4e0 <main+0x208>
        }
        outputs[i] = sigmoid_q16((int32_t)sum);
     50c:	d8dff0ef          	jal	298 <sigmoid_q16>
     510:	80000737          	lui	a4,0x80000
     514:	94a1a823          	sw	a0,-1712(gp) # 80000150 <outputs>
        for (int j = 0; j < l3_inputs; j++) {
     518:	00470713          	addi	a4,a4,4 # 80000004 <o_weights+0x4>
        int64_t sum = 0;
     51c:	00000513          	li	a0,0
     520:	95018413          	addi	s0,gp,-1712 # 80000150 <outputs>
            sum += ((int64_t)h2_outputs[j] * (int64_t)o_weights[j][i]) >> FRAC_WIDTH;
     524:	000a2783          	lw	a5,0(s4)
     528:	00072603          	lw	a2,0(a4)
        for (int j = 0; j < l3_inputs; j++) {
     52c:	004a0a13          	addi	s4,s4,4
     530:	00870713          	addi	a4,a4,8
            sum += ((int64_t)h2_outputs[j] * (int64_t)o_weights[j][i]) >> FRAC_WIDTH;
     534:	02c786b3          	mul	a3,a5,a2
     538:	02c797b3          	mulh	a5,a5,a2
     53c:	0106d693          	srli	a3,a3,0x10
     540:	01079793          	slli	a5,a5,0x10
     544:	00d7e6b3          	or	a3,a5,a3
     548:	00d50533          	add	a0,a0,a3
        for (int j = 0; j < l3_inputs; j++) {
     54c:	fd4a9ce3          	bne	s5,s4,524 <main+0x24c>
        outputs[i] = sigmoid_q16((int32_t)sum);
     550:	d49ff0ef          	jal	298 <sigmoid_q16>
     554:	00a42223          	sw	a0,4(s0)
     558:	c00027f3          	rdcycle	a5
    }

    // End calculation
    uint32_t end_time           = neorv32_cpu_csr_read(CSR_CYCLE);
    uint32_t elapsed_cycles     = end_time - start_time;
    uint32_t elapsed_time_ns    = (uint32_t)(((uint64_t)elapsed_cycles * 1000ULL) / (NEORV32_CLK / 1000000));
     55c:	000f4637          	lui	a2,0xf4
     560:	24060613          	addi	a2,a2,576 # f4240 <__neorv32_ram_size+0xd4240>
     564:	02c95633          	divu	a2,s2,a2
    uint32_t elapsed_cycles     = end_time - start_time;
     568:	413789b3          	sub	s3,a5,s3
    uint32_t elapsed_time_ns    = (uint32_t)(((uint64_t)elapsed_cycles * 1000ULL) / (NEORV32_CLK / 1000000));
     56c:	3e800513          	li	a0,1000
     570:	00000693          	li	a3,0

    // Print results
    neorv32_uart0_printf("Output Values:\n");
    for (int i = 0; i < o_neuron; i++) {
        neorv32_uart0_printf("%s Value: %d.%04d\n", i ? "Not Tasty" : "Tasty", Q16_TO_INT(outputs[i]), Q16_TO_FRAC(outputs[i]));
     574:	00002937          	lui	s2,0x2
     578:	71090913          	addi	s2,s2,1808 # 2710 <__neorv32_heap_size+0x710>
     57c:	00002b37          	lui	s6,0x2
     580:	00001ab7          	lui	s5,0x1
    uint32_t elapsed_time_ns    = (uint32_t)(((uint64_t)elapsed_cycles * 1000ULL) / (NEORV32_CLK / 1000000));
     584:	02a9b5b3          	mulhu	a1,s3,a0
     588:	02a98533          	mul	a0,s3,a0
     58c:	4ad000ef          	jal	1238 <__udivdi3>
    neorv32_uart0_printf("Output Values:\n");
     590:	000025b7          	lui	a1,0x2
     594:	80458593          	addi	a1,a1,-2044 # 1804 <__fini_array_end+0x120>
    uint32_t elapsed_time_ns    = (uint32_t)(((uint64_t)elapsed_cycles * 1000ULL) / (NEORV32_CLK / 1000000));
     598:	00050a13          	mv	s4,a0
    neorv32_uart0_printf("Output Values:\n");
     59c:	fff50537          	lui	a0,0xfff50
     5a0:	4d8000ef          	jal	a78 <neorv32_uart_printf>
        neorv32_uart0_printf("%s Value: %d.%04d\n", i ? "Not Tasty" : "Tasty", Q16_TO_INT(outputs[i]), Q16_TO_FRAC(outputs[i]));
     5a4:	00042683          	lw	a3,0(s0)
     5a8:	6eca8613          	addi	a2,s5,1772 # 16ec <__fini_array_end+0x8>
     5ac:	814b0593          	addi	a1,s6,-2028 # 1814 <__fini_array_end+0x130>
     5b0:	01069713          	slli	a4,a3,0x10
     5b4:	01075713          	srli	a4,a4,0x10
     5b8:	03270733          	mul	a4,a4,s2
     5bc:	4106d693          	srai	a3,a3,0x10
     5c0:	fff50537          	lui	a0,0xfff50
     5c4:	01075713          	srli	a4,a4,0x10
     5c8:	4b0000ef          	jal	a78 <neorv32_uart_printf>
     5cc:	00442683          	lw	a3,4(s0)
     5d0:	814b0593          	addi	a1,s6,-2028
     5d4:	fff50537          	lui	a0,0xfff50
     5d8:	01069713          	slli	a4,a3,0x10
     5dc:	01075713          	srli	a4,a4,0x10
     5e0:	03270733          	mul	a4,a4,s2
     5e4:	00001937          	lui	s2,0x1
     5e8:	6e890613          	addi	a2,s2,1768 # 16e8 <__fini_array_end+0x4>
     5ec:	4106d693          	srai	a3,a3,0x10
     5f0:	01075713          	srli	a4,a4,0x10
     5f4:	484000ef          	jal	a78 <neorv32_uart_printf>
    }
    neorv32_uart0_printf("Conclusion: %s\n", (outputs[0] > outputs[1]) ? "Tasty" : "Not Tasty");
     5f8:	00042703          	lw	a4,0(s0)
     5fc:	00442783          	lw	a5,4(s0)
     600:	6e890613          	addi	a2,s2,1768
     604:	00e7d463          	bge	a5,a4,60c <main+0x334>
     608:	6eca8613          	addi	a2,s5,1772
     60c:	000025b7          	lui	a1,0x2
     610:	82858593          	addi	a1,a1,-2008 # 1828 <__fini_array_end+0x144>
     614:	fff50537          	lui	a0,0xfff50
     618:	460000ef          	jal	a78 <neorv32_uart_printf>
    neorv32_uart0_printf("Elapsed Time: %u cycles (%u ns)\n", elapsed_cycles, elapsed_time_ns);
     61c:	000025b7          	lui	a1,0x2
     620:	000a0693          	mv	a3,s4
     624:	00098613          	mv	a2,s3
     628:	83858593          	addi	a1,a1,-1992 # 1838 <__fini_array_end+0x154>
     62c:	fff50537          	lui	a0,0xfff50
     630:	448000ef          	jal	a78 <neorv32_uart_printf>

    // Finish execution
    neorv32_uart0_printf("\n===================== THE END ======================\n");
     634:	000025b7          	lui	a1,0x2
     638:	85c58593          	addi	a1,a1,-1956 # 185c <__fini_array_end+0x178>
     63c:	fff50537          	lui	a0,0xfff50
     640:	438000ef          	jal	a78 <neorv32_uart_printf>
    neorv32_uart0_printf("====================================================\n\n");
     644:	76448593          	addi	a1,s1,1892
     648:	fff50537          	lui	a0,0xfff50
     64c:	42c000ef          	jal	a78 <neorv32_uart_printf>
    return 0;
     650:	00000793          	li	a5,0
     654:	03c12083          	lw	ra,60(sp)
     658:	03812403          	lw	s0,56(sp)
     65c:	03412483          	lw	s1,52(sp)
     660:	03012903          	lw	s2,48(sp)
     664:	02c12983          	lw	s3,44(sp)
     668:	02812a03          	lw	s4,40(sp)
     66c:	02412a83          	lw	s5,36(sp)
     670:	02012b03          	lw	s6,32(sp)
     674:	01c12b83          	lw	s7,28(sp)
     678:	01812c03          	lw	s8,24(sp)
     67c:	01412c83          	lw	s9,20(sp)
     680:	00078513          	mv	a0,a5
     684:	04010113          	addi	sp,sp,64
     688:	00008067          	ret

0000068c <neorv32_aux_itoa>:
 *
 * @param[in,out] buffer Pointer to array for the result string [33 chars].
 * @param[in] num Number to convert.
 * @param[in] base Base of number representation (2..16).
 **************************************************************************/
void neorv32_aux_itoa(char *buffer, uint32_t num, uint32_t base) {
     68c:	fb010113          	addi	sp,sp,-80
     690:	05212023          	sw	s2,64(sp)
     694:	00058913          	mv	s2,a1

  const char digits[16] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
     698:	000025b7          	lui	a1,0x2
void neorv32_aux_itoa(char *buffer, uint32_t num, uint32_t base) {
     69c:	04812423          	sw	s0,72(sp)
     6a0:	04912223          	sw	s1,68(sp)
  const char digits[16] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
     6a4:	89458593          	addi	a1,a1,-1900 # 1894 <__fini_array_end+0x1b0>
void neorv32_aux_itoa(char *buffer, uint32_t num, uint32_t base) {
     6a8:	00060493          	mv	s1,a2
     6ac:	00050413          	mv	s0,a0
  const char digits[16] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
     6b0:	01000613          	li	a2,16
     6b4:	00c10513          	addi	a0,sp,12
void neorv32_aux_itoa(char *buffer, uint32_t num, uint32_t base) {
     6b8:	04112623          	sw	ra,76(sp)
  const char digits[16] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
     6bc:	4d0000ef          	jal	b8c <memcpy>
  char *tmp_ptr = 0;
  unsigned int i = 0;

  // prevent uninitialized stack bytes
  for (i=0; i<sizeof(tmp); i++) {
    tmp[i] = 0;
     6c0:	01c10693          	addi	a3,sp,28
     6c4:	02400613          	li	a2,36
     6c8:	00000593          	li	a1,0
     6cc:	00068513          	mv	a0,a3
     6d0:	3e0000ef          	jal	ab0 <memset>
  }

  if ((base < 2) || (base > 16)) { // invalid base?
     6d4:	ffe48613          	addi	a2,s1,-2
     6d8:	00e00713          	li	a4,14
     6dc:	02c77063          	bgeu	a4,a2,6fc <neorv32_aux_itoa+0x70>
      buffer++;
    }
  }

  // terminate result string
  *buffer = '\0';
     6e0:	00040023          	sb	zero,0(s0)
}
     6e4:	04c12083          	lw	ra,76(sp)
     6e8:	04812403          	lw	s0,72(sp)
     6ec:	04412483          	lw	s1,68(sp)
     6f0:	04012903          	lw	s2,64(sp)
     6f4:	05010113          	addi	sp,sp,80
     6f8:	00008067          	ret
     6fc:	00050693          	mv	a3,a0
     700:	03f10793          	addi	a5,sp,63
    *tmp_ptr = digits[num%base];
     704:	02997733          	remu	a4,s2,s1
    tmp_ptr--;
     708:	fff78793          	addi	a5,a5,-1
    *tmp_ptr = digits[num%base];
     70c:	04070713          	addi	a4,a4,64
     710:	00270733          	add	a4,a4,sp
     714:	fcc74703          	lbu	a4,-52(a4)
     718:	00e78023          	sb	a4,0(a5)
    num /= base;
     71c:	00090713          	mv	a4,s2
     720:	02995933          	divu	s2,s2,s1
  } while (num != 0);
     724:	fe9770e3          	bgeu	a4,s1,704 <neorv32_aux_itoa+0x78>
  for (i=0; i<sizeof(tmp); i++) {
     728:	00000793          	li	a5,0
     72c:	02400613          	li	a2,36
    if (tmp[i] != '\0') {
     730:	00f68733          	add	a4,a3,a5
     734:	00074703          	lbu	a4,0(a4)
     738:	00070663          	beqz	a4,744 <neorv32_aux_itoa+0xb8>
      *buffer = tmp[i];
     73c:	00e40023          	sb	a4,0(s0)
      buffer++;
     740:	00140413          	addi	s0,s0,1
  for (i=0; i<sizeof(tmp); i++) {
     744:	00178793          	addi	a5,a5,1
     748:	fec794e3          	bne	a5,a2,730 <neorv32_aux_itoa+0xa4>
     74c:	f95ff06f          	j	6e0 <neorv32_aux_itoa+0x54>

00000750 <neorv32_uart_available>:
 * @param[in,out] Hardware handle to UART register struct, #neorv32_uart_t.
 * @return 0 if UART0/1 was not synthesized, non-zero if UART0/1 is available.
 **************************************************************************/
int neorv32_uart_available(neorv32_uart_t *UARTx) {

  if (UARTx == NEORV32_UART0) {
     750:	fff50737          	lui	a4,0xfff50
int neorv32_uart_available(neorv32_uart_t *UARTx) {
     754:	00050793          	mv	a5,a0
  if (UARTx == NEORV32_UART0) {
     758:	00e51c63          	bne	a0,a4,770 <neorv32_uart_available+0x20>
    return (int)(NEORV32_SYSINFO->SOC & (1 << SYSINFO_SOC_IO_UART0));
     75c:	fffe07b7          	lui	a5,0xfffe0
     760:	0087a503          	lw	a0,8(a5) # fffe0008 <__crt0_stack_top+0x7ffc0008>
     764:	000207b7          	lui	a5,0x20
  }
  else if (UARTx == NEORV32_UART1) {
    return (int)(NEORV32_SYSINFO->SOC & (1 << SYSINFO_SOC_IO_UART1));
     768:	00f57533          	and	a0,a0,a5
  }
  else {
    return 0;
  }
}
     76c:	00008067          	ret
  else if (UARTx == NEORV32_UART1) {
     770:	fff60737          	lui	a4,0xfff60
    return 0;
     774:	00000513          	li	a0,0
  else if (UARTx == NEORV32_UART1) {
     778:	fee79ae3          	bne	a5,a4,76c <neorv32_uart_available+0x1c>
    return (int)(NEORV32_SYSINFO->SOC & (1 << SYSINFO_SOC_IO_UART1));
     77c:	fffe07b7          	lui	a5,0xfffe0
     780:	0087a503          	lw	a0,8(a5) # fffe0008 <__crt0_stack_top+0x7ffc0008>
     784:	020007b7          	lui	a5,0x2000
     788:	fe1ff06f          	j	768 <neorv32_uart_available+0x18>

0000078c <neorv32_uart_setup>:

  uint32_t prsc_sel = 0;
  uint32_t baud_div = 0;

  // reset
  UARTx->CTRL = 0;
     78c:	00052023          	sw	zero,0(a0) # fff50000 <__crt0_stack_top+0x7ff30000>
     790:	fffe07b7          	lui	a5,0xfffe0
     794:	0007a783          	lw	a5,0(a5) # fffe0000 <__crt0_stack_top+0x7ffc0000>

  // raw clock prescaler
  uint32_t clock = neorv32_sysinfo_get_clk(); // system clock in Hz
#ifndef MAKE_BOOTLOADER // use div instructions / library functions
  baud_div = clock / (2*baudrate);
     798:	00159593          	slli	a1,a1,0x1
  uint32_t prsc_sel = 0;
     79c:	00000713          	li	a4,0
  baud_div = clock / (2*baudrate);
     7a0:	02b7d7b3          	divu	a5,a5,a1
    baud_div++;
  }
#endif

  // find baud prescaler (10-bit wide))
  while (baud_div >= 0x3ffU) {
     7a4:	3fe00593          	li	a1,1022
     7a8:	02f5ec63          	bltu	a1,a5,7e0 <neorv32_uart_setup+0x54>
  }

  uint32_t tmp = 0;
  tmp |= (uint32_t)(1              & 1U)     << UART_CTRL_EN;
  tmp |= (uint32_t)(prsc_sel       & 3U)     << UART_CTRL_PRSC_LSB;
  tmp |= (uint32_t)((baud_div - 1) & 0x3ffU) << UART_CTRL_BAUD_LSB;
     7ac:	fff78793          	addi	a5,a5,-1
     7b0:	00679793          	slli	a5,a5,0x6
     7b4:	01079793          	slli	a5,a5,0x10
  tmp |= (uint32_t)(irq_mask       & (0xfu   << UART_CTRL_IRQ_RX_NEMPTY));
     7b8:	00f006b7          	lui	a3,0xf00
  tmp |= (uint32_t)((baud_div - 1) & 0x3ffU) << UART_CTRL_BAUD_LSB;
     7bc:	0107d793          	srli	a5,a5,0x10
  tmp |= (uint32_t)(irq_mask       & (0xfu   << UART_CTRL_IRQ_RX_NEMPTY));
     7c0:	00d67633          	and	a2,a2,a3
  tmp |= (uint32_t)(prsc_sel       & 3U)     << UART_CTRL_PRSC_LSB;
     7c4:	00371713          	slli	a4,a4,0x3
  tmp |= (uint32_t)(irq_mask       & (0xfu   << UART_CTRL_IRQ_RX_NEMPTY));
     7c8:	00c7e7b3          	or	a5,a5,a2
  tmp |= (uint32_t)(prsc_sel       & 3U)     << UART_CTRL_PRSC_LSB;
     7cc:	01877713          	andi	a4,a4,24
  tmp |= (uint32_t)(irq_mask       & (0xfu   << UART_CTRL_IRQ_RX_NEMPTY));
     7d0:	00e7e7b3          	or	a5,a5,a4
     7d4:	0017e793          	ori	a5,a5,1
  if (((uint32_t)UARTx) == NEORV32_UART1_BASE) {
    tmp |= 1U << UART_CTRL_SIM_MODE;
  }
#endif

  UARTx->CTRL = tmp;
     7d8:	00f52023          	sw	a5,0(a0)
}
     7dc:	00008067          	ret
    if ((prsc_sel == 2) || (prsc_sel == 4))
     7e0:	ffe70693          	addi	a3,a4,-2 # fff5fffe <__crt0_stack_top+0x7ff3fffe>
     7e4:	ffd6f693          	andi	a3,a3,-3
     7e8:	00069863          	bnez	a3,7f8 <neorv32_uart_setup+0x6c>
      baud_div >>= 3;
     7ec:	0037d793          	srli	a5,a5,0x3
    prsc_sel++;
     7f0:	00170713          	addi	a4,a4,1
     7f4:	fb5ff06f          	j	7a8 <neorv32_uart_setup+0x1c>
      baud_div >>= 1;
     7f8:	0017d793          	srli	a5,a5,0x1
     7fc:	ff5ff06f          	j	7f0 <neorv32_uart_setup+0x64>

00000800 <neorv32_uart_putc>:
 * @param[in,out] UARTx Hardware handle to UART register struct, #neorv32_uart_t.
 * @param[in] c Char to be send.
 **************************************************************************/
void neorv32_uart_putc(neorv32_uart_t *UARTx, char c) {

  while ((UARTx->CTRL & (1<<UART_CTRL_TX_NFULL)) == 0); // wait for free space in TX FIFO
     800:	00052783          	lw	a5,0(a0)
     804:	00c79713          	slli	a4,a5,0xc
     808:	fe075ce3          	bgez	a4,800 <neorv32_uart_putc>
void neorv32_uart_tx_put(neorv32_uart_t *UARTx, char c) {

#ifdef UART_SEMIHOSTING
  neorv32_semihosting_putc(c);
#else
  UARTx->DATA = (uint32_t)c << UART_DATA_RTX_LSB;
     80c:	00b52223          	sw	a1,4(a0)
}
     810:	00008067          	ret

00000814 <neorv32_uart_puts>:
 * @warning "/n" line breaks are automatically converted to "/r/n".
 *
 * @param[in,out] UARTx Hardware handle to UART register struct, #neorv32_uart_t.
 * @param[in] s Pointer to string.
 **************************************************************************/
void neorv32_uart_puts(neorv32_uart_t *UARTx, const char *s) {
     814:	fe010113          	addi	sp,sp,-32
     818:	00812c23          	sw	s0,24(sp)
     81c:	00912a23          	sw	s1,20(sp)
     820:	01312623          	sw	s3,12(sp)
     824:	00112e23          	sw	ra,28(sp)
     828:	01212823          	sw	s2,16(sp)
     82c:	00050493          	mv	s1,a0
     830:	00058413          	mv	s0,a1
#ifdef UART_SEMIHOSTING
  neorv32_semihosting_puts(s);
#else
  char c = 0;
  while ((c = *s++)) {
    if (c == '\n') {
     834:	00a00993          	li	s3,10
  while ((c = *s++)) {
     838:	00044903          	lbu	s2,0(s0)
     83c:	00140413          	addi	s0,s0,1
     840:	02091063          	bnez	s2,860 <neorv32_uart_puts+0x4c>
      neorv32_uart_putc(UARTx, '\r');
    }
    neorv32_uart_putc(UARTx, c);
  }
#endif
}
     844:	01c12083          	lw	ra,28(sp)
     848:	01812403          	lw	s0,24(sp)
     84c:	01412483          	lw	s1,20(sp)
     850:	01012903          	lw	s2,16(sp)
     854:	00c12983          	lw	s3,12(sp)
     858:	02010113          	addi	sp,sp,32
     85c:	00008067          	ret
    if (c == '\n') {
     860:	01391863          	bne	s2,s3,870 <neorv32_uart_puts+0x5c>
      neorv32_uart_putc(UARTx, '\r');
     864:	00d00593          	li	a1,13
     868:	00048513          	mv	a0,s1
     86c:	f95ff0ef          	jal	800 <neorv32_uart_putc>
    neorv32_uart_putc(UARTx, c);
     870:	00090593          	mv	a1,s2
     874:	00048513          	mv	a0,s1
     878:	f89ff0ef          	jal	800 <neorv32_uart_putc>
     87c:	fbdff06f          	j	838 <neorv32_uart_puts+0x24>

00000880 <neorv32_uart_vprintf>:
 *
 * @param[in,out] UARTx Hardware handle to UART register struct, #neorv32_uart_t.
 * @param[in] format Pointer to format string.
 * @param[in] args A value identifying a variable arguments list.
 **************************************************************************/
void neorv32_uart_vprintf(neorv32_uart_t *UARTx, const char *format, va_list args) {
     880:	fa010113          	addi	sp,sp,-96
     884:	04812c23          	sw	s0,88(sp)
     888:	04912a23          	sw	s1,84(sp)
     88c:	05212823          	sw	s2,80(sp)
     890:	00050493          	mv	s1,a0
     894:	00058913          	mv	s2,a1
     898:	00060413          	mv	s0,a2
  int32_t n = 0;
  unsigned int i = 0;

  // prevent uninitialized stack bytes
  for (i=0; i<sizeof(string_buf); i++) {
    string_buf[i] = 0;
     89c:	00000593          	li	a1,0
     8a0:	02400613          	li	a2,36
     8a4:	00c10513          	addi	a0,sp,12
void neorv32_uart_vprintf(neorv32_uart_t *UARTx, const char *format, va_list args) {
     8a8:	05312623          	sw	s3,76(sp)
     8ac:	05512223          	sw	s5,68(sp)
     8b0:	05612023          	sw	s6,64(sp)
     8b4:	03712e23          	sw	s7,60(sp)
     8b8:	03812c23          	sw	s8,56(sp)
     8bc:	03912a23          	sw	s9,52(sp)
     8c0:	04112e23          	sw	ra,92(sp)
     8c4:	05412423          	sw	s4,72(sp)
     8c8:	03a12823          	sw	s10,48(sp)
  }

  while ((c = *format++)) {
    if (c == '%') {
     8cc:	02500a93          	li	s5,37
    string_buf[i] = 0;
     8d0:	1e0000ef          	jal	ab0 <memset>
          neorv32_uart_putc(UARTx, c);
          break;
      }
    }
    else {
      if (c == '\n') {
     8d4:	00a00b13          	li	s6,10
      c = tolower(*format++);
     8d8:	00002bb7          	lui	s7,0x2
     8dc:	00100c13          	li	s8,1
      switch (c) {
     8e0:	07000993          	li	s3,112
     8e4:	07500c93          	li	s9,117
  while ((c = *format++)) {
     8e8:	00094d03          	lbu	s10,0(s2)
     8ec:	020d1e63          	bnez	s10,928 <neorv32_uart_vprintf+0xa8>
        neorv32_uart_putc(UARTx, '\r');
      }
      neorv32_uart_putc(UARTx, c);
    }
  }
}
     8f0:	05c12083          	lw	ra,92(sp)
     8f4:	05812403          	lw	s0,88(sp)
     8f8:	05412483          	lw	s1,84(sp)
     8fc:	05012903          	lw	s2,80(sp)
     900:	04c12983          	lw	s3,76(sp)
     904:	04812a03          	lw	s4,72(sp)
     908:	04412a83          	lw	s5,68(sp)
     90c:	04012b03          	lw	s6,64(sp)
     910:	03c12b83          	lw	s7,60(sp)
     914:	03812c03          	lw	s8,56(sp)
     918:	03412c83          	lw	s9,52(sp)
     91c:	03012d03          	lw	s10,48(sp)
     920:	06010113          	addi	sp,sp,96
     924:	00008067          	ret
    if (c == '%') {
     928:	135d1a63          	bne	s10,s5,a5c <neorv32_uart_vprintf+0x1dc>
      c = tolower(*format++);
     92c:	00290a13          	addi	s4,s2,2
     930:	00194903          	lbu	s2,1(s2)
     934:	aa5b8793          	addi	a5,s7,-1371 # 1aa5 <_ctype_+0x1>
     938:	00f907b3          	add	a5,s2,a5
     93c:	0007c783          	lbu	a5,0(a5)
     940:	0037f793          	andi	a5,a5,3
     944:	01879463          	bne	a5,s8,94c <neorv32_uart_vprintf+0xcc>
     948:	02090913          	addi	s2,s2,32
      switch (c) {
     94c:	0ff97593          	zext.b	a1,s2
     950:	0d358863          	beq	a1,s3,a20 <neorv32_uart_vprintf+0x1a0>
     954:	06b9cc63          	blt	s3,a1,9cc <neorv32_uart_vprintf+0x14c>
     958:	06300793          	li	a5,99
     95c:	08f58c63          	beq	a1,a5,9f4 <neorv32_uart_vprintf+0x174>
     960:	02b7c463          	blt	a5,a1,988 <neorv32_uart_vprintf+0x108>
     964:	02500793          	li	a5,37
     968:	00f58a63          	beq	a1,a5,97c <neorv32_uart_vprintf+0xfc>
          neorv32_uart_putc(UARTx, '%');
     96c:	02500593          	li	a1,37
     970:	00048513          	mv	a0,s1
     974:	e8dff0ef          	jal	800 <neorv32_uart_putc>
          neorv32_uart_putc(UARTx, c);
     978:	0ff97593          	zext.b	a1,s2
      neorv32_uart_putc(UARTx, c);
     97c:	00048513          	mv	a0,s1
     980:	e81ff0ef          	jal	800 <neorv32_uart_putc>
     984:	0840006f          	j	a08 <neorv32_uart_vprintf+0x188>
      switch (c) {
     988:	06400793          	li	a5,100
     98c:	00f58663          	beq	a1,a5,998 <neorv32_uart_vprintf+0x118>
     990:	06900793          	li	a5,105
     994:	fcf59ce3          	bne	a1,a5,96c <neorv32_uart_vprintf+0xec>
          n = (int32_t)va_arg(args, int32_t);
     998:	00440913          	addi	s2,s0,4
     99c:	00042403          	lw	s0,0(s0)
          if (n < 0) {
     9a0:	00045a63          	bgez	s0,9b4 <neorv32_uart_vprintf+0x134>
            neorv32_uart_putc(UARTx, '-');
     9a4:	02d00593          	li	a1,45
     9a8:	00048513          	mv	a0,s1
            n = -n;
     9ac:	40800433          	neg	s0,s0
            neorv32_uart_putc(UARTx, '-');
     9b0:	e51ff0ef          	jal	800 <neorv32_uart_putc>
          neorv32_aux_itoa(string_buf, (uint32_t)n, 10);
     9b4:	00a00613          	li	a2,10
     9b8:	00040593          	mv	a1,s0
          neorv32_aux_itoa(string_buf, va_arg(args, uint32_t), 10);
     9bc:	00c10513          	addi	a0,sp,12
     9c0:	ccdff0ef          	jal	68c <neorv32_aux_itoa>
          neorv32_uart_puts(UARTx, string_buf);
     9c4:	00c10593          	addi	a1,sp,12
     9c8:	0200006f          	j	9e8 <neorv32_uart_vprintf+0x168>
      switch (c) {
     9cc:	05958263          	beq	a1,s9,a10 <neorv32_uart_vprintf+0x190>
     9d0:	07800793          	li	a5,120
     9d4:	04f58663          	beq	a1,a5,a20 <neorv32_uart_vprintf+0x1a0>
     9d8:	07300793          	li	a5,115
     9dc:	f8f598e3          	bne	a1,a5,96c <neorv32_uart_vprintf+0xec>
          neorv32_uart_puts(UARTx, va_arg(args, char*));
     9e0:	00042583          	lw	a1,0(s0)
     9e4:	00440913          	addi	s2,s0,4
          neorv32_uart_puts(UARTx, string_buf);
     9e8:	00048513          	mv	a0,s1
     9ec:	e29ff0ef          	jal	814 <neorv32_uart_puts>
          break;
     9f0:	0140006f          	j	a04 <neorv32_uart_vprintf+0x184>
          neorv32_uart_putc(UARTx, (char)va_arg(args, int));
     9f4:	00044583          	lbu	a1,0(s0)
     9f8:	00048513          	mv	a0,s1
     9fc:	00440913          	addi	s2,s0,4
     a00:	e01ff0ef          	jal	800 <neorv32_uart_putc>
     a04:	00090413          	mv	s0,s2
          neorv32_uart_puts(UARTx, va_arg(args, char*));
     a08:	000a0913          	mv	s2,s4
     a0c:	eddff06f          	j	8e8 <neorv32_uart_vprintf+0x68>
          neorv32_aux_itoa(string_buf, va_arg(args, uint32_t), 10);
     a10:	00042583          	lw	a1,0(s0)
     a14:	00440913          	addi	s2,s0,4
     a18:	00a00613          	li	a2,10
     a1c:	fa1ff06f          	j	9bc <neorv32_uart_vprintf+0x13c>
          neorv32_aux_itoa(string_buf, va_arg(args, uint32_t), 16);
     a20:	00042583          	lw	a1,0(s0)
     a24:	01000613          	li	a2,16
     a28:	00c10513          	addi	a0,sp,12
     a2c:	c61ff0ef          	jal	68c <neorv32_aux_itoa>
          i = 8 - strlen(string_buf);
     a30:	00c10513          	addi	a0,sp,12
          neorv32_aux_itoa(string_buf, va_arg(args, uint32_t), 16);
     a34:	00440913          	addi	s2,s0,4
          i = 8 - strlen(string_buf);
     a38:	27c000ef          	jal	cb4 <strlen>
     a3c:	00800413          	li	s0,8
     a40:	40a40433          	sub	s0,s0,a0
          while (i--) { // add leading zeros
     a44:	f80400e3          	beqz	s0,9c4 <neorv32_uart_vprintf+0x144>
            neorv32_uart_putc(UARTx, '0');
     a48:	03000593          	li	a1,48
     a4c:	00048513          	mv	a0,s1
     a50:	db1ff0ef          	jal	800 <neorv32_uart_putc>
     a54:	fff40413          	addi	s0,s0,-1
     a58:	fedff06f          	j	a44 <neorv32_uart_vprintf+0x1c4>
      if (c == '\n') {
     a5c:	016d1863          	bne	s10,s6,a6c <neorv32_uart_vprintf+0x1ec>
        neorv32_uart_putc(UARTx, '\r');
     a60:	00d00593          	li	a1,13
     a64:	00048513          	mv	a0,s1
     a68:	d99ff0ef          	jal	800 <neorv32_uart_putc>
  while ((c = *format++)) {
     a6c:	00190a13          	addi	s4,s2,1
      neorv32_uart_putc(UARTx, c);
     a70:	000d0593          	mv	a1,s10
     a74:	f09ff06f          	j	97c <neorv32_uart_vprintf+0xfc>

00000a78 <neorv32_uart_printf>:
 * @note This function is blocking.
 *
 * @param[in,out] UARTx Hardware handle to UART register struct, #neorv32_uart_t.
 * @param[in] format Pointer to format string. See neorv32_uart_vprintf.
 **************************************************************************/
void neorv32_uart_printf(neorv32_uart_t *UARTx, const char *format, ...) {
     a78:	fc010113          	addi	sp,sp,-64
     a7c:	02c12423          	sw	a2,40(sp)

  va_list args;
  va_start(args, format);
     a80:	02810613          	addi	a2,sp,40
void neorv32_uart_printf(neorv32_uart_t *UARTx, const char *format, ...) {
     a84:	00112e23          	sw	ra,28(sp)
     a88:	02d12623          	sw	a3,44(sp)
     a8c:	02e12823          	sw	a4,48(sp)
     a90:	02f12a23          	sw	a5,52(sp)
     a94:	03012c23          	sw	a6,56(sp)
     a98:	03112e23          	sw	a7,60(sp)
  va_start(args, format);
     a9c:	00c12623          	sw	a2,12(sp)
  neorv32_uart_vprintf(UARTx, format, args);
     aa0:	de1ff0ef          	jal	880 <neorv32_uart_vprintf>
  va_end(args);
}
     aa4:	01c12083          	lw	ra,28(sp)
     aa8:	04010113          	addi	sp,sp,64
     aac:	00008067          	ret

00000ab0 <memset>:
     ab0:	00f00313          	li	t1,15
     ab4:	00050713          	mv	a4,a0
     ab8:	02c37e63          	bgeu	t1,a2,af4 <memset+0x44>
     abc:	00f77793          	andi	a5,a4,15
     ac0:	0a079063          	bnez	a5,b60 <memset+0xb0>
     ac4:	08059263          	bnez	a1,b48 <memset+0x98>
     ac8:	ff067693          	andi	a3,a2,-16
     acc:	00f67613          	andi	a2,a2,15
     ad0:	00e686b3          	add	a3,a3,a4
     ad4:	00b72023          	sw	a1,0(a4)
     ad8:	00b72223          	sw	a1,4(a4)
     adc:	00b72423          	sw	a1,8(a4)
     ae0:	00b72623          	sw	a1,12(a4)
     ae4:	01070713          	addi	a4,a4,16
     ae8:	fed766e3          	bltu	a4,a3,ad4 <memset+0x24>
     aec:	00061463          	bnez	a2,af4 <memset+0x44>
     af0:	00008067          	ret
     af4:	40c306b3          	sub	a3,t1,a2
     af8:	00269693          	slli	a3,a3,0x2
     afc:	00000297          	auipc	t0,0x0
     b00:	005686b3          	add	a3,a3,t0
     b04:	00c68067          	jr	12(a3) # f0000c <__neorv32_ram_size+0xee000c>
     b08:	00b70723          	sb	a1,14(a4)
     b0c:	00b706a3          	sb	a1,13(a4)
     b10:	00b70623          	sb	a1,12(a4)
     b14:	00b705a3          	sb	a1,11(a4)
     b18:	00b70523          	sb	a1,10(a4)
     b1c:	00b704a3          	sb	a1,9(a4)
     b20:	00b70423          	sb	a1,8(a4)
     b24:	00b703a3          	sb	a1,7(a4)
     b28:	00b70323          	sb	a1,6(a4)
     b2c:	00b702a3          	sb	a1,5(a4)
     b30:	00b70223          	sb	a1,4(a4)
     b34:	00b701a3          	sb	a1,3(a4)
     b38:	00b70123          	sb	a1,2(a4)
     b3c:	00b700a3          	sb	a1,1(a4)
     b40:	00b70023          	sb	a1,0(a4)
     b44:	00008067          	ret
     b48:	0ff5f593          	zext.b	a1,a1
     b4c:	00859693          	slli	a3,a1,0x8
     b50:	00d5e5b3          	or	a1,a1,a3
     b54:	01059693          	slli	a3,a1,0x10
     b58:	00d5e5b3          	or	a1,a1,a3
     b5c:	f6dff06f          	j	ac8 <memset+0x18>
     b60:	00279693          	slli	a3,a5,0x2
     b64:	00000297          	auipc	t0,0x0
     b68:	005686b3          	add	a3,a3,t0
     b6c:	00008293          	mv	t0,ra
     b70:	fa0680e7          	jalr	-96(a3)
     b74:	00028093          	mv	ra,t0
     b78:	ff078793          	addi	a5,a5,-16
     b7c:	40f70733          	sub	a4,a4,a5
     b80:	00f60633          	add	a2,a2,a5
     b84:	f6c378e3          	bgeu	t1,a2,af4 <memset+0x44>
     b88:	f3dff06f          	j	ac4 <memset+0x14>

00000b8c <memcpy>:
     b8c:	00a5c7b3          	xor	a5,a1,a0
     b90:	0037f793          	andi	a5,a5,3
     b94:	00c508b3          	add	a7,a0,a2
     b98:	06079663          	bnez	a5,c04 <memcpy+0x78>
     b9c:	00300793          	li	a5,3
     ba0:	06c7f263          	bgeu	a5,a2,c04 <memcpy+0x78>
     ba4:	00357793          	andi	a5,a0,3
     ba8:	00050713          	mv	a4,a0
     bac:	0c079a63          	bnez	a5,c80 <memcpy+0xf4>
     bb0:	ffc8f613          	andi	a2,a7,-4
     bb4:	40e606b3          	sub	a3,a2,a4
     bb8:	02000793          	li	a5,32
     bbc:	06d7c463          	blt	a5,a3,c24 <memcpy+0x98>
     bc0:	00058693          	mv	a3,a1
     bc4:	00070793          	mv	a5,a4
     bc8:	02c77a63          	bgeu	a4,a2,bfc <memcpy+0x70>
     bcc:	0006a803          	lw	a6,0(a3)
     bd0:	00478793          	addi	a5,a5,4
     bd4:	00468693          	addi	a3,a3,4
     bd8:	ff07ae23          	sw	a6,-4(a5)
     bdc:	fec7e8e3          	bltu	a5,a2,bcc <memcpy+0x40>
     be0:	fff60613          	addi	a2,a2,-1
     be4:	40e60633          	sub	a2,a2,a4
     be8:	ffc67613          	andi	a2,a2,-4
     bec:	00458593          	addi	a1,a1,4
     bf0:	00470713          	addi	a4,a4,4
     bf4:	00c585b3          	add	a1,a1,a2
     bf8:	00c70733          	add	a4,a4,a2
     bfc:	01176863          	bltu	a4,a7,c0c <memcpy+0x80>
     c00:	00008067          	ret
     c04:	00050713          	mv	a4,a0
     c08:	ff157ce3          	bgeu	a0,a7,c00 <memcpy+0x74>
     c0c:	0005c783          	lbu	a5,0(a1)
     c10:	00170713          	addi	a4,a4,1
     c14:	00158593          	addi	a1,a1,1
     c18:	fef70fa3          	sb	a5,-1(a4)
     c1c:	fee898e3          	bne	a7,a4,c0c <memcpy+0x80>
     c20:	00008067          	ret
     c24:	0205a683          	lw	a3,32(a1)
     c28:	0005a383          	lw	t2,0(a1)
     c2c:	0045a283          	lw	t0,4(a1)
     c30:	0085af83          	lw	t6,8(a1)
     c34:	00c5af03          	lw	t5,12(a1)
     c38:	0105ae83          	lw	t4,16(a1)
     c3c:	0145ae03          	lw	t3,20(a1)
     c40:	0185a303          	lw	t1,24(a1)
     c44:	01c5a803          	lw	a6,28(a1)
     c48:	02470713          	addi	a4,a4,36
     c4c:	fed72e23          	sw	a3,-4(a4)
     c50:	fc772e23          	sw	t2,-36(a4)
     c54:	40e606b3          	sub	a3,a2,a4
     c58:	fe572023          	sw	t0,-32(a4)
     c5c:	fff72223          	sw	t6,-28(a4)
     c60:	ffe72423          	sw	t5,-24(a4)
     c64:	ffd72623          	sw	t4,-20(a4)
     c68:	ffc72823          	sw	t3,-16(a4)
     c6c:	fe672a23          	sw	t1,-12(a4)
     c70:	ff072c23          	sw	a6,-8(a4)
     c74:	02458593          	addi	a1,a1,36
     c78:	fad7c6e3          	blt	a5,a3,c24 <memcpy+0x98>
     c7c:	f45ff06f          	j	bc0 <memcpy+0x34>
     c80:	0005c683          	lbu	a3,0(a1)
     c84:	00170713          	addi	a4,a4,1
     c88:	00377793          	andi	a5,a4,3
     c8c:	fed70fa3          	sb	a3,-1(a4)
     c90:	00158593          	addi	a1,a1,1
     c94:	f0078ee3          	beqz	a5,bb0 <memcpy+0x24>
     c98:	0005c683          	lbu	a3,0(a1)
     c9c:	00170713          	addi	a4,a4,1
     ca0:	00377793          	andi	a5,a4,3
     ca4:	fed70fa3          	sb	a3,-1(a4)
     ca8:	00158593          	addi	a1,a1,1
     cac:	fc079ae3          	bnez	a5,c80 <memcpy+0xf4>
     cb0:	f01ff06f          	j	bb0 <memcpy+0x24>

00000cb4 <strlen>:
     cb4:	00357793          	andi	a5,a0,3
     cb8:	00050713          	mv	a4,a0
     cbc:	04079c63          	bnez	a5,d14 <strlen+0x60>
     cc0:	7f7f86b7          	lui	a3,0x7f7f8
     cc4:	f7f68693          	addi	a3,a3,-129 # 7f7f7f7f <__neorv32_ram_size+0x7f7d7f7f>
     cc8:	fff00593          	li	a1,-1
     ccc:	00072603          	lw	a2,0(a4)
     cd0:	00470713          	addi	a4,a4,4
     cd4:	00d677b3          	and	a5,a2,a3
     cd8:	00d787b3          	add	a5,a5,a3
     cdc:	00c7e7b3          	or	a5,a5,a2
     ce0:	00d7e7b3          	or	a5,a5,a3
     ce4:	feb784e3          	beq	a5,a1,ccc <strlen+0x18>
     ce8:	ffc74683          	lbu	a3,-4(a4)
     cec:	40a707b3          	sub	a5,a4,a0
     cf0:	04068463          	beqz	a3,d38 <strlen+0x84>
     cf4:	ffd74683          	lbu	a3,-3(a4)
     cf8:	02068c63          	beqz	a3,d30 <strlen+0x7c>
     cfc:	ffe74503          	lbu	a0,-2(a4)
     d00:	00a03533          	snez	a0,a0
     d04:	00f50533          	add	a0,a0,a5
     d08:	ffe50513          	addi	a0,a0,-2
     d0c:	00008067          	ret
     d10:	fa0688e3          	beqz	a3,cc0 <strlen+0xc>
     d14:	00074783          	lbu	a5,0(a4)
     d18:	00170713          	addi	a4,a4,1
     d1c:	00377693          	andi	a3,a4,3
     d20:	fe0798e3          	bnez	a5,d10 <strlen+0x5c>
     d24:	40a70733          	sub	a4,a4,a0
     d28:	fff70513          	addi	a0,a4,-1
     d2c:	00008067          	ret
     d30:	ffd78513          	addi	a0,a5,-3
     d34:	00008067          	ret
     d38:	ffc78513          	addi	a0,a5,-4
     d3c:	00008067          	ret

00000d40 <__divdi3>:
     d40:	00000813          	li	a6,0
     d44:	1205c663          	bltz	a1,e70 <__divdi3+0x130>
     d48:	0006dc63          	bgez	a3,d60 <__divdi3+0x20>
     d4c:	00c037b3          	snez	a5,a2
     d50:	40d006b3          	neg	a3,a3
     d54:	fff84813          	not	a6,a6
     d58:	40f686b3          	sub	a3,a3,a5
     d5c:	40c00633          	neg	a2,a2
     d60:	00060893          	mv	a7,a2
     d64:	00050793          	mv	a5,a0
     d68:	00058313          	mv	t1,a1
     d6c:	0e069a63          	bnez	a3,e60 <__divdi3+0x120>
     d70:	16c5f463          	bgeu	a1,a2,ed8 <__divdi3+0x198>
     d74:	00010737          	lui	a4,0x10
     d78:	22e66463          	bltu	a2,a4,fa0 <__divdi3+0x260>
     d7c:	01000737          	lui	a4,0x1000
     d80:	01800693          	li	a3,24
     d84:	00e67463          	bgeu	a2,a4,d8c <__divdi3+0x4c>
     d88:	01000693          	li	a3,16
     d8c:	00d65e33          	srl	t3,a2,a3
     d90:	00001717          	auipc	a4,0x1
     d94:	e1870713          	addi	a4,a4,-488 # 1ba8 <__clz_tab>
     d98:	01c70733          	add	a4,a4,t3
     d9c:	00074703          	lbu	a4,0(a4)
     da0:	02000e13          	li	t3,32
     da4:	00d70733          	add	a4,a4,a3
     da8:	40ee06b3          	sub	a3,t3,a4
     dac:	00ee0c63          	beq	t3,a4,dc4 <__divdi3+0x84>
     db0:	00d59333          	sll	t1,a1,a3
     db4:	00e55733          	srl	a4,a0,a4
     db8:	00676333          	or	t1,a4,t1
     dbc:	00d618b3          	sll	a7,a2,a3
     dc0:	00d517b3          	sll	a5,a0,a3
     dc4:	0108d613          	srli	a2,a7,0x10
     dc8:	02c35533          	divu	a0,t1,a2
     dcc:	01089693          	slli	a3,a7,0x10
     dd0:	0106d693          	srli	a3,a3,0x10
     dd4:	0107d713          	srli	a4,a5,0x10
     dd8:	02c37333          	remu	t1,t1,a2
     ddc:	02a685b3          	mul	a1,a3,a0
     de0:	01031313          	slli	t1,t1,0x10
     de4:	00676733          	or	a4,a4,t1
     de8:	00b77c63          	bgeu	a4,a1,e00 <__divdi3+0xc0>
     dec:	00e88733          	add	a4,a7,a4
     df0:	fff50313          	addi	t1,a0,-1
     df4:	01176463          	bltu	a4,a7,dfc <__divdi3+0xbc>
     df8:	42b76463          	bltu	a4,a1,1220 <__divdi3+0x4e0>
     dfc:	00030513          	mv	a0,t1
     e00:	40b70733          	sub	a4,a4,a1
     e04:	02c755b3          	divu	a1,a4,a2
     e08:	01079793          	slli	a5,a5,0x10
     e0c:	0107d793          	srli	a5,a5,0x10
     e10:	02c77733          	remu	a4,a4,a2
     e14:	02b686b3          	mul	a3,a3,a1
     e18:	01071713          	slli	a4,a4,0x10
     e1c:	00e7e7b3          	or	a5,a5,a4
     e20:	00d7fe63          	bgeu	a5,a3,e3c <__divdi3+0xfc>
     e24:	00f887b3          	add	a5,a7,a5
     e28:	fff58713          	addi	a4,a1,-1
     e2c:	0117e663          	bltu	a5,a7,e38 <__divdi3+0xf8>
     e30:	ffe58593          	addi	a1,a1,-2
     e34:	00d7e463          	bltu	a5,a3,e3c <__divdi3+0xfc>
     e38:	00070593          	mv	a1,a4
     e3c:	01051513          	slli	a0,a0,0x10
     e40:	00b56533          	or	a0,a0,a1
     e44:	00000593          	li	a1,0
     e48:	00080a63          	beqz	a6,e5c <__divdi3+0x11c>
     e4c:	00a037b3          	snez	a5,a0
     e50:	40b005b3          	neg	a1,a1
     e54:	40f585b3          	sub	a1,a1,a5
     e58:	40a00533          	neg	a0,a0
     e5c:	00008067          	ret
     e60:	02d5f463          	bgeu	a1,a3,e88 <__divdi3+0x148>
     e64:	00000593          	li	a1,0
     e68:	00000513          	li	a0,0
     e6c:	fddff06f          	j	e48 <__divdi3+0x108>
     e70:	00a037b3          	snez	a5,a0
     e74:	40b005b3          	neg	a1,a1
     e78:	40f585b3          	sub	a1,a1,a5
     e7c:	40a00533          	neg	a0,a0
     e80:	fff00813          	li	a6,-1
     e84:	ec5ff06f          	j	d48 <__divdi3+0x8>
     e88:	000107b7          	lui	a5,0x10
     e8c:	1ef6e863          	bltu	a3,a5,107c <__divdi3+0x33c>
     e90:	01000737          	lui	a4,0x1000
     e94:	01800793          	li	a5,24
     e98:	00e6f463          	bgeu	a3,a4,ea0 <__divdi3+0x160>
     e9c:	01000793          	li	a5,16
     ea0:	00f6d8b3          	srl	a7,a3,a5
     ea4:	00001717          	auipc	a4,0x1
     ea8:	d0470713          	addi	a4,a4,-764 # 1ba8 <__clz_tab>
     eac:	01170733          	add	a4,a4,a7
     eb0:	00074703          	lbu	a4,0(a4)
     eb4:	02000313          	li	t1,32
     eb8:	00f70733          	add	a4,a4,a5
     ebc:	40e308b3          	sub	a7,t1,a4
     ec0:	1ee31663          	bne	t1,a4,10ac <__divdi3+0x36c>
     ec4:	32b6e263          	bltu	a3,a1,11e8 <__divdi3+0x4a8>
     ec8:	00c53533          	sltu	a0,a0,a2
     ecc:	00153513          	seqz	a0,a0
     ed0:	00000593          	li	a1,0
     ed4:	f75ff06f          	j	e48 <__divdi3+0x108>
     ed8:	0c060c63          	beqz	a2,fb0 <__divdi3+0x270>
     edc:	00010737          	lui	a4,0x10
     ee0:	2ee67a63          	bgeu	a2,a4,11d4 <__divdi3+0x494>
     ee4:	10063693          	sltiu	a3,a2,256
     ee8:	0016b693          	seqz	a3,a3
     eec:	00369693          	slli	a3,a3,0x3
     ef0:	00d65333          	srl	t1,a2,a3
     ef4:	00001717          	auipc	a4,0x1
     ef8:	cb470713          	addi	a4,a4,-844 # 1ba8 <__clz_tab>
     efc:	00670733          	add	a4,a4,t1
     f00:	00074703          	lbu	a4,0(a4)
     f04:	02000313          	li	t1,32
     f08:	00d70733          	add	a4,a4,a3
     f0c:	40e30f33          	sub	t5,t1,a4
     f10:	0ce31463          	bne	t1,a4,fd8 <__divdi3+0x298>
     f14:	40c58733          	sub	a4,a1,a2
     f18:	01065313          	srli	t1,a2,0x10
     f1c:	01061613          	slli	a2,a2,0x10
     f20:	01065613          	srli	a2,a2,0x10
     f24:	00100593          	li	a1,1
     f28:	02675533          	divu	a0,a4,t1
     f2c:	0107d693          	srli	a3,a5,0x10
     f30:	02677733          	remu	a4,a4,t1
     f34:	02c50e33          	mul	t3,a0,a2
     f38:	01071713          	slli	a4,a4,0x10
     f3c:	00e6e733          	or	a4,a3,a4
     f40:	01c77c63          	bgeu	a4,t3,f58 <__divdi3+0x218>
     f44:	00e88733          	add	a4,a7,a4
     f48:	fff50693          	addi	a3,a0,-1
     f4c:	01176463          	bltu	a4,a7,f54 <__divdi3+0x214>
     f50:	2dc76263          	bltu	a4,t3,1214 <__divdi3+0x4d4>
     f54:	00068513          	mv	a0,a3
     f58:	41c70733          	sub	a4,a4,t3
     f5c:	026756b3          	divu	a3,a4,t1
     f60:	01079793          	slli	a5,a5,0x10
     f64:	0107d793          	srli	a5,a5,0x10
     f68:	02677733          	remu	a4,a4,t1
     f6c:	02c68633          	mul	a2,a3,a2
     f70:	01071713          	slli	a4,a4,0x10
     f74:	00e7e7b3          	or	a5,a5,a4
     f78:	00c7fe63          	bgeu	a5,a2,f94 <__divdi3+0x254>
     f7c:	00f887b3          	add	a5,a7,a5
     f80:	fff68713          	addi	a4,a3,-1
     f84:	0117e663          	bltu	a5,a7,f90 <__divdi3+0x250>
     f88:	ffe68693          	addi	a3,a3,-2
     f8c:	00c7e463          	bltu	a5,a2,f94 <__divdi3+0x254>
     f90:	00070693          	mv	a3,a4
     f94:	01051513          	slli	a0,a0,0x10
     f98:	00d56533          	or	a0,a0,a3
     f9c:	eadff06f          	j	e48 <__divdi3+0x108>
     fa0:	10063693          	sltiu	a3,a2,256
     fa4:	0016b693          	seqz	a3,a3
     fa8:	00369693          	slli	a3,a3,0x3
     fac:	de1ff06f          	j	d8c <__divdi3+0x4c>
     fb0:	00000313          	li	t1,0
     fb4:	00001717          	auipc	a4,0x1
     fb8:	bf470713          	addi	a4,a4,-1036 # 1ba8 <__clz_tab>
     fbc:	00670733          	add	a4,a4,t1
     fc0:	00074703          	lbu	a4,0(a4)
     fc4:	00000693          	li	a3,0
     fc8:	02000313          	li	t1,32
     fcc:	00d70733          	add	a4,a4,a3
     fd0:	40e30f33          	sub	t5,t1,a4
     fd4:	f4e300e3          	beq	t1,a4,f14 <__divdi3+0x1d4>
     fd8:	01e618b3          	sll	a7,a2,t5
     fdc:	00e5de33          	srl	t3,a1,a4
     fe0:	0108d313          	srli	t1,a7,0x10
     fe4:	026e5eb3          	divu	t4,t3,t1
     fe8:	01089613          	slli	a2,a7,0x10
     fec:	01e595b3          	sll	a1,a1,t5
     ff0:	01065613          	srli	a2,a2,0x10
     ff4:	00e55733          	srl	a4,a0,a4
     ff8:	00b76733          	or	a4,a4,a1
     ffc:	01075693          	srli	a3,a4,0x10
    1000:	01e517b3          	sll	a5,a0,t5
    1004:	026e7e33          	remu	t3,t3,t1
    1008:	03d605b3          	mul	a1,a2,t4
    100c:	010e1e13          	slli	t3,t3,0x10
    1010:	01c6e6b3          	or	a3,a3,t3
    1014:	00b6fe63          	bgeu	a3,a1,1030 <__divdi3+0x2f0>
    1018:	00d886b3          	add	a3,a7,a3
    101c:	fffe8513          	addi	a0,t4,-1
    1020:	1f16e263          	bltu	a3,a7,1204 <__divdi3+0x4c4>
    1024:	1eb6f063          	bgeu	a3,a1,1204 <__divdi3+0x4c4>
    1028:	ffee8e93          	addi	t4,t4,-2
    102c:	011686b3          	add	a3,a3,a7
    1030:	40b686b3          	sub	a3,a3,a1
    1034:	0266d533          	divu	a0,a3,t1
    1038:	01071713          	slli	a4,a4,0x10
    103c:	01075713          	srli	a4,a4,0x10
    1040:	0266f6b3          	remu	a3,a3,t1
    1044:	02a60e33          	mul	t3,a2,a0
    1048:	01069693          	slli	a3,a3,0x10
    104c:	00d76733          	or	a4,a4,a3
    1050:	01c77e63          	bgeu	a4,t3,106c <__divdi3+0x32c>
    1054:	00e88733          	add	a4,a7,a4
    1058:	fff50693          	addi	a3,a0,-1
    105c:	19176c63          	bltu	a4,a7,11f4 <__divdi3+0x4b4>
    1060:	19c77a63          	bgeu	a4,t3,11f4 <__divdi3+0x4b4>
    1064:	ffe50513          	addi	a0,a0,-2
    1068:	01170733          	add	a4,a4,a7
    106c:	010e9593          	slli	a1,t4,0x10
    1070:	00a5e5b3          	or	a1,a1,a0
    1074:	41c70733          	sub	a4,a4,t3
    1078:	eb1ff06f          	j	f28 <__divdi3+0x1e8>
    107c:	1006b793          	sltiu	a5,a3,256
    1080:	0017b793          	seqz	a5,a5
    1084:	00379793          	slli	a5,a5,0x3
    1088:	00f6d8b3          	srl	a7,a3,a5
    108c:	00001717          	auipc	a4,0x1
    1090:	b1c70713          	addi	a4,a4,-1252 # 1ba8 <__clz_tab>
    1094:	01170733          	add	a4,a4,a7
    1098:	00074703          	lbu	a4,0(a4)
    109c:	02000313          	li	t1,32
    10a0:	00f70733          	add	a4,a4,a5
    10a4:	40e308b3          	sub	a7,t1,a4
    10a8:	e0e30ee3          	beq	t1,a4,ec4 <__divdi3+0x184>
    10ac:	00e65eb3          	srl	t4,a2,a4
    10b0:	011696b3          	sll	a3,a3,a7
    10b4:	00deeeb3          	or	t4,t4,a3
    10b8:	00e5d333          	srl	t1,a1,a4
    10bc:	010edf13          	srli	t5,t4,0x10
    10c0:	03e357b3          	divu	a5,t1,t5
    10c4:	010e9e13          	slli	t3,t4,0x10
    10c8:	011595b3          	sll	a1,a1,a7
    10cc:	010e5e13          	srli	t3,t3,0x10
    10d0:	00e55733          	srl	a4,a0,a4
    10d4:	00b76733          	or	a4,a4,a1
    10d8:	01075693          	srli	a3,a4,0x10
    10dc:	01161633          	sll	a2,a2,a7
    10e0:	03e37333          	remu	t1,t1,t5
    10e4:	02fe05b3          	mul	a1,t3,a5
    10e8:	01031313          	slli	t1,t1,0x10
    10ec:	0066e6b3          	or	a3,a3,t1
    10f0:	00b6fe63          	bgeu	a3,a1,110c <__divdi3+0x3cc>
    10f4:	00de86b3          	add	a3,t4,a3
    10f8:	fff78313          	addi	t1,a5,-1 # ffff <__neorv32_heap_size+0xdfff>
    10fc:	11d6e863          	bltu	a3,t4,120c <__divdi3+0x4cc>
    1100:	10b6f663          	bgeu	a3,a1,120c <__divdi3+0x4cc>
    1104:	ffe78793          	addi	a5,a5,-2
    1108:	01d686b3          	add	a3,a3,t4
    110c:	40b686b3          	sub	a3,a3,a1
    1110:	03e6d333          	divu	t1,a3,t5
    1114:	01071713          	slli	a4,a4,0x10
    1118:	01075713          	srli	a4,a4,0x10
    111c:	03e6f6b3          	remu	a3,a3,t5
    1120:	026e05b3          	mul	a1,t3,t1
    1124:	01069693          	slli	a3,a3,0x10
    1128:	00d76733          	or	a4,a4,a3
    112c:	00b77e63          	bgeu	a4,a1,1148 <__divdi3+0x408>
    1130:	00ee8733          	add	a4,t4,a4
    1134:	fff30693          	addi	a3,t1,-1
    1138:	0dd76263          	bltu	a4,t4,11fc <__divdi3+0x4bc>
    113c:	0cb77063          	bgeu	a4,a1,11fc <__divdi3+0x4bc>
    1140:	ffe30313          	addi	t1,t1,-2
    1144:	01d70733          	add	a4,a4,t4
    1148:	01079793          	slli	a5,a5,0x10
    114c:	01031693          	slli	a3,t1,0x10
    1150:	01061e13          	slli	t3,a2,0x10
    1154:	0067e7b3          	or	a5,a5,t1
    1158:	0106d693          	srli	a3,a3,0x10
    115c:	010e5e13          	srli	t3,t3,0x10
    1160:	0107d313          	srli	t1,a5,0x10
    1164:	01065613          	srli	a2,a2,0x10
    1168:	03c30eb3          	mul	t4,t1,t3
    116c:	40b70733          	sub	a4,a4,a1
    1170:	03c68e33          	mul	t3,a3,t3
    1174:	02c686b3          	mul	a3,a3,a2
    1178:	010e5593          	srli	a1,t3,0x10
    117c:	01d686b3          	add	a3,a3,t4
    1180:	00d586b3          	add	a3,a1,a3
    1184:	02c30333          	mul	t1,t1,a2
    1188:	01d6f663          	bgeu	a3,t4,1194 <__divdi3+0x454>
    118c:	00010637          	lui	a2,0x10
    1190:	00c30333          	add	t1,t1,a2
    1194:	0106d613          	srli	a2,a3,0x10
    1198:	00660633          	add	a2,a2,t1
    119c:	02c76663          	bltu	a4,a2,11c8 <__divdi3+0x488>
    11a0:	00c70863          	beq	a4,a2,11b0 <__divdi3+0x470>
    11a4:	00078513          	mv	a0,a5
    11a8:	00000593          	li	a1,0
    11ac:	c9dff06f          	j	e48 <__divdi3+0x108>
    11b0:	010e1e13          	slli	t3,t3,0x10
    11b4:	010e5e13          	srli	t3,t3,0x10
    11b8:	01069693          	slli	a3,a3,0x10
    11bc:	01151533          	sll	a0,a0,a7
    11c0:	01c686b3          	add	a3,a3,t3
    11c4:	fed570e3          	bgeu	a0,a3,11a4 <__divdi3+0x464>
    11c8:	fff78513          	addi	a0,a5,-1
    11cc:	00000593          	li	a1,0
    11d0:	c79ff06f          	j	e48 <__divdi3+0x108>
    11d4:	01000737          	lui	a4,0x1000
    11d8:	04e67a63          	bgeu	a2,a4,122c <__divdi3+0x4ec>
    11dc:	01065313          	srli	t1,a2,0x10
    11e0:	01000693          	li	a3,16
    11e4:	d11ff06f          	j	ef4 <__divdi3+0x1b4>
    11e8:	00000593          	li	a1,0
    11ec:	00100513          	li	a0,1
    11f0:	c59ff06f          	j	e48 <__divdi3+0x108>
    11f4:	00068513          	mv	a0,a3
    11f8:	e75ff06f          	j	106c <__divdi3+0x32c>
    11fc:	00068313          	mv	t1,a3
    1200:	f49ff06f          	j	1148 <__divdi3+0x408>
    1204:	00050e93          	mv	t4,a0
    1208:	e29ff06f          	j	1030 <__divdi3+0x2f0>
    120c:	00030793          	mv	a5,t1
    1210:	efdff06f          	j	110c <__divdi3+0x3cc>
    1214:	ffe50513          	addi	a0,a0,-2
    1218:	01170733          	add	a4,a4,a7
    121c:	d3dff06f          	j	f58 <__divdi3+0x218>
    1220:	ffe50513          	addi	a0,a0,-2
    1224:	01170733          	add	a4,a4,a7
    1228:	bd9ff06f          	j	e00 <__divdi3+0xc0>
    122c:	01865313          	srli	t1,a2,0x18
    1230:	01800693          	li	a3,24
    1234:	cc1ff06f          	j	ef4 <__divdi3+0x1b4>

00001238 <__udivdi3>:
    1238:	00060813          	mv	a6,a2
    123c:	00050893          	mv	a7,a0
    1240:	00058713          	mv	a4,a1
    1244:	0e069063          	bnez	a3,1324 <__udivdi3+0xec>
    1248:	12c5fe63          	bgeu	a1,a2,1384 <__udivdi3+0x14c>
    124c:	000107b7          	lui	a5,0x10
    1250:	1ef66e63          	bltu	a2,a5,144c <__udivdi3+0x214>
    1254:	010007b7          	lui	a5,0x1000
    1258:	01800693          	li	a3,24
    125c:	00f67463          	bgeu	a2,a5,1264 <__udivdi3+0x2c>
    1260:	01000693          	li	a3,16
    1264:	00d65333          	srl	t1,a2,a3
    1268:	00001797          	auipc	a5,0x1
    126c:	94078793          	addi	a5,a5,-1728 # 1ba8 <__clz_tab>
    1270:	006787b3          	add	a5,a5,t1
    1274:	0007c783          	lbu	a5,0(a5)
    1278:	02000313          	li	t1,32
    127c:	00d787b3          	add	a5,a5,a3
    1280:	40f306b3          	sub	a3,t1,a5
    1284:	00f30c63          	beq	t1,a5,129c <__udivdi3+0x64>
    1288:	00d59733          	sll	a4,a1,a3
    128c:	00f557b3          	srl	a5,a0,a5
    1290:	00e7e733          	or	a4,a5,a4
    1294:	00d61833          	sll	a6,a2,a3
    1298:	00d518b3          	sll	a7,a0,a3
    129c:	01085613          	srli	a2,a6,0x10
    12a0:	02c75533          	divu	a0,a4,a2
    12a4:	01081693          	slli	a3,a6,0x10
    12a8:	0106d693          	srli	a3,a3,0x10
    12ac:	0108d793          	srli	a5,a7,0x10
    12b0:	02c77733          	remu	a4,a4,a2
    12b4:	02a685b3          	mul	a1,a3,a0
    12b8:	01071713          	slli	a4,a4,0x10
    12bc:	00e7e7b3          	or	a5,a5,a4
    12c0:	00b7fc63          	bgeu	a5,a1,12d8 <__udivdi3+0xa0>
    12c4:	00f807b3          	add	a5,a6,a5
    12c8:	fff50713          	addi	a4,a0,-1
    12cc:	0107e463          	bltu	a5,a6,12d4 <__udivdi3+0x9c>
    12d0:	3eb7ee63          	bltu	a5,a1,16cc <__udivdi3+0x494>
    12d4:	00070513          	mv	a0,a4
    12d8:	40b787b3          	sub	a5,a5,a1
    12dc:	02c7d733          	divu	a4,a5,a2
    12e0:	01089893          	slli	a7,a7,0x10
    12e4:	0108d893          	srli	a7,a7,0x10
    12e8:	02c7f7b3          	remu	a5,a5,a2
    12ec:	02e686b3          	mul	a3,a3,a4
    12f0:	01079793          	slli	a5,a5,0x10
    12f4:	00f8e8b3          	or	a7,a7,a5
    12f8:	00d8fe63          	bgeu	a7,a3,1314 <__udivdi3+0xdc>
    12fc:	011808b3          	add	a7,a6,a7
    1300:	fff70793          	addi	a5,a4,-1 # ffffff <__neorv32_ram_size+0xfdffff>
    1304:	0108e663          	bltu	a7,a6,1310 <__udivdi3+0xd8>
    1308:	ffe70713          	addi	a4,a4,-2
    130c:	00d8e463          	bltu	a7,a3,1314 <__udivdi3+0xdc>
    1310:	00078713          	mv	a4,a5
    1314:	01051513          	slli	a0,a0,0x10
    1318:	00e56533          	or	a0,a0,a4
    131c:	00000593          	li	a1,0
    1320:	00008067          	ret
    1324:	00d5f863          	bgeu	a1,a3,1334 <__udivdi3+0xfc>
    1328:	00000593          	li	a1,0
    132c:	00000513          	li	a0,0
    1330:	00008067          	ret
    1334:	000107b7          	lui	a5,0x10
    1338:	1ef6e863          	bltu	a3,a5,1528 <__udivdi3+0x2f0>
    133c:	01000737          	lui	a4,0x1000
    1340:	01800793          	li	a5,24
    1344:	00e6f463          	bgeu	a3,a4,134c <__udivdi3+0x114>
    1348:	01000793          	li	a5,16
    134c:	00f6d833          	srl	a6,a3,a5
    1350:	00001717          	auipc	a4,0x1
    1354:	85870713          	addi	a4,a4,-1960 # 1ba8 <__clz_tab>
    1358:	01070733          	add	a4,a4,a6
    135c:	00074703          	lbu	a4,0(a4)
    1360:	02000813          	li	a6,32
    1364:	00f70733          	add	a4,a4,a5
    1368:	40e808b3          	sub	a7,a6,a4
    136c:	1ee81663          	bne	a6,a4,1558 <__udivdi3+0x320>
    1370:	32b6e263          	bltu	a3,a1,1694 <__udivdi3+0x45c>
    1374:	00c53533          	sltu	a0,a0,a2
    1378:	00153513          	seqz	a0,a0
    137c:	00000593          	li	a1,0
    1380:	00008067          	ret
    1384:	0c060c63          	beqz	a2,145c <__udivdi3+0x224>
    1388:	000107b7          	lui	a5,0x10
    138c:	2ef67a63          	bgeu	a2,a5,1680 <__udivdi3+0x448>
    1390:	10063713          	sltiu	a4,a2,256
    1394:	00173713          	seqz	a4,a4
    1398:	00371713          	slli	a4,a4,0x3
    139c:	00e656b3          	srl	a3,a2,a4
    13a0:	00001797          	auipc	a5,0x1
    13a4:	80878793          	addi	a5,a5,-2040 # 1ba8 <__clz_tab>
    13a8:	00d787b3          	add	a5,a5,a3
    13ac:	0007c783          	lbu	a5,0(a5)
    13b0:	02000693          	li	a3,32
    13b4:	00e787b3          	add	a5,a5,a4
    13b8:	40f68eb3          	sub	t4,a3,a5
    13bc:	0cf69463          	bne	a3,a5,1484 <__udivdi3+0x24c>
    13c0:	40c587b3          	sub	a5,a1,a2
    13c4:	01065693          	srli	a3,a2,0x10
    13c8:	01061613          	slli	a2,a2,0x10
    13cc:	01065613          	srli	a2,a2,0x10
    13d0:	00100593          	li	a1,1
    13d4:	02d7d533          	divu	a0,a5,a3
    13d8:	0108d713          	srli	a4,a7,0x10
    13dc:	02d7f7b3          	remu	a5,a5,a3
    13e0:	02c50333          	mul	t1,a0,a2
    13e4:	01079793          	slli	a5,a5,0x10
    13e8:	00f767b3          	or	a5,a4,a5
    13ec:	0067fc63          	bgeu	a5,t1,1404 <__udivdi3+0x1cc>
    13f0:	00f807b3          	add	a5,a6,a5
    13f4:	fff50713          	addi	a4,a0,-1
    13f8:	0107e463          	bltu	a5,a6,1400 <__udivdi3+0x1c8>
    13fc:	2c67e263          	bltu	a5,t1,16c0 <__udivdi3+0x488>
    1400:	00070513          	mv	a0,a4
    1404:	406787b3          	sub	a5,a5,t1
    1408:	02d7d733          	divu	a4,a5,a3
    140c:	01089893          	slli	a7,a7,0x10
    1410:	0108d893          	srli	a7,a7,0x10
    1414:	02d7f7b3          	remu	a5,a5,a3
    1418:	02c70633          	mul	a2,a4,a2
    141c:	01079793          	slli	a5,a5,0x10
    1420:	00f8e8b3          	or	a7,a7,a5
    1424:	00c8fe63          	bgeu	a7,a2,1440 <__udivdi3+0x208>
    1428:	011808b3          	add	a7,a6,a7
    142c:	fff70793          	addi	a5,a4,-1
    1430:	0108e663          	bltu	a7,a6,143c <__udivdi3+0x204>
    1434:	ffe70713          	addi	a4,a4,-2
    1438:	00c8e463          	bltu	a7,a2,1440 <__udivdi3+0x208>
    143c:	00078713          	mv	a4,a5
    1440:	01051513          	slli	a0,a0,0x10
    1444:	00e56533          	or	a0,a0,a4
    1448:	00008067          	ret
    144c:	10063693          	sltiu	a3,a2,256
    1450:	0016b693          	seqz	a3,a3
    1454:	00369693          	slli	a3,a3,0x3
    1458:	e0dff06f          	j	1264 <__udivdi3+0x2c>
    145c:	00000693          	li	a3,0
    1460:	00000797          	auipc	a5,0x0
    1464:	74878793          	addi	a5,a5,1864 # 1ba8 <__clz_tab>
    1468:	00d787b3          	add	a5,a5,a3
    146c:	0007c783          	lbu	a5,0(a5)
    1470:	00000713          	li	a4,0
    1474:	02000693          	li	a3,32
    1478:	00e787b3          	add	a5,a5,a4
    147c:	40f68eb3          	sub	t4,a3,a5
    1480:	f4f680e3          	beq	a3,a5,13c0 <__udivdi3+0x188>
    1484:	01d61833          	sll	a6,a2,t4
    1488:	00f5d333          	srl	t1,a1,a5
    148c:	01085693          	srli	a3,a6,0x10
    1490:	02d35e33          	divu	t3,t1,a3
    1494:	01081613          	slli	a2,a6,0x10
    1498:	01d595b3          	sll	a1,a1,t4
    149c:	01065613          	srli	a2,a2,0x10
    14a0:	00f557b3          	srl	a5,a0,a5
    14a4:	00b7e7b3          	or	a5,a5,a1
    14a8:	0107d713          	srli	a4,a5,0x10
    14ac:	01d518b3          	sll	a7,a0,t4
    14b0:	02d37333          	remu	t1,t1,a3
    14b4:	03c605b3          	mul	a1,a2,t3
    14b8:	01031313          	slli	t1,t1,0x10
    14bc:	00676733          	or	a4,a4,t1
    14c0:	00b77e63          	bgeu	a4,a1,14dc <__udivdi3+0x2a4>
    14c4:	00e80733          	add	a4,a6,a4
    14c8:	fffe0513          	addi	a0,t3,-1
    14cc:	1f076263          	bltu	a4,a6,16b0 <__udivdi3+0x478>
    14d0:	1eb77063          	bgeu	a4,a1,16b0 <__udivdi3+0x478>
    14d4:	ffee0e13          	addi	t3,t3,-2
    14d8:	01070733          	add	a4,a4,a6
    14dc:	40b70733          	sub	a4,a4,a1
    14e0:	02d75533          	divu	a0,a4,a3
    14e4:	01079793          	slli	a5,a5,0x10
    14e8:	0107d793          	srli	a5,a5,0x10
    14ec:	02d77733          	remu	a4,a4,a3
    14f0:	02a60333          	mul	t1,a2,a0
    14f4:	01071713          	slli	a4,a4,0x10
    14f8:	00e7e7b3          	or	a5,a5,a4
    14fc:	0067fe63          	bgeu	a5,t1,1518 <__udivdi3+0x2e0>
    1500:	00f807b3          	add	a5,a6,a5
    1504:	fff50713          	addi	a4,a0,-1
    1508:	1907ec63          	bltu	a5,a6,16a0 <__udivdi3+0x468>
    150c:	1867fa63          	bgeu	a5,t1,16a0 <__udivdi3+0x468>
    1510:	ffe50513          	addi	a0,a0,-2
    1514:	010787b3          	add	a5,a5,a6
    1518:	010e1593          	slli	a1,t3,0x10
    151c:	00a5e5b3          	or	a1,a1,a0
    1520:	406787b3          	sub	a5,a5,t1
    1524:	eb1ff06f          	j	13d4 <__udivdi3+0x19c>
    1528:	1006b793          	sltiu	a5,a3,256
    152c:	0017b793          	seqz	a5,a5
    1530:	00379793          	slli	a5,a5,0x3
    1534:	00f6d833          	srl	a6,a3,a5
    1538:	00000717          	auipc	a4,0x0
    153c:	67070713          	addi	a4,a4,1648 # 1ba8 <__clz_tab>
    1540:	01070733          	add	a4,a4,a6
    1544:	00074703          	lbu	a4,0(a4)
    1548:	02000813          	li	a6,32
    154c:	00f70733          	add	a4,a4,a5
    1550:	40e808b3          	sub	a7,a6,a4
    1554:	e0e80ee3          	beq	a6,a4,1370 <__udivdi3+0x138>
    1558:	00e65e33          	srl	t3,a2,a4
    155c:	011696b3          	sll	a3,a3,a7
    1560:	00de6e33          	or	t3,t3,a3
    1564:	00e5d833          	srl	a6,a1,a4
    1568:	010e5e93          	srli	t4,t3,0x10
    156c:	03d857b3          	divu	a5,a6,t4
    1570:	010e1313          	slli	t1,t3,0x10
    1574:	011595b3          	sll	a1,a1,a7
    1578:	01035313          	srli	t1,t1,0x10
    157c:	00e55733          	srl	a4,a0,a4
    1580:	00b76733          	or	a4,a4,a1
    1584:	01075693          	srli	a3,a4,0x10
    1588:	01161633          	sll	a2,a2,a7
    158c:	03d87833          	remu	a6,a6,t4
    1590:	02f305b3          	mul	a1,t1,a5
    1594:	01081813          	slli	a6,a6,0x10
    1598:	0106e6b3          	or	a3,a3,a6
    159c:	00b6fe63          	bgeu	a3,a1,15b8 <__udivdi3+0x380>
    15a0:	00de06b3          	add	a3,t3,a3
    15a4:	fff78813          	addi	a6,a5,-1
    15a8:	11c6e863          	bltu	a3,t3,16b8 <__udivdi3+0x480>
    15ac:	10b6f663          	bgeu	a3,a1,16b8 <__udivdi3+0x480>
    15b0:	ffe78793          	addi	a5,a5,-2
    15b4:	01c686b3          	add	a3,a3,t3
    15b8:	40b686b3          	sub	a3,a3,a1
    15bc:	03d6d833          	divu	a6,a3,t4
    15c0:	01071713          	slli	a4,a4,0x10
    15c4:	01075713          	srli	a4,a4,0x10
    15c8:	03d6f6b3          	remu	a3,a3,t4
    15cc:	030305b3          	mul	a1,t1,a6
    15d0:	01069693          	slli	a3,a3,0x10
    15d4:	00d76733          	or	a4,a4,a3
    15d8:	00b77e63          	bgeu	a4,a1,15f4 <__udivdi3+0x3bc>
    15dc:	00ee0733          	add	a4,t3,a4
    15e0:	fff80693          	addi	a3,a6,-1
    15e4:	0dc76263          	bltu	a4,t3,16a8 <__udivdi3+0x470>
    15e8:	0cb77063          	bgeu	a4,a1,16a8 <__udivdi3+0x470>
    15ec:	ffe80813          	addi	a6,a6,-2
    15f0:	01c70733          	add	a4,a4,t3
    15f4:	01079793          	slli	a5,a5,0x10
    15f8:	01081693          	slli	a3,a6,0x10
    15fc:	01061313          	slli	t1,a2,0x10
    1600:	0107e7b3          	or	a5,a5,a6
    1604:	0106d693          	srli	a3,a3,0x10
    1608:	01035313          	srli	t1,t1,0x10
    160c:	0107d813          	srli	a6,a5,0x10
    1610:	01065613          	srli	a2,a2,0x10
    1614:	02680e33          	mul	t3,a6,t1
    1618:	40b70733          	sub	a4,a4,a1
    161c:	02668333          	mul	t1,a3,t1
    1620:	02c686b3          	mul	a3,a3,a2
    1624:	01035593          	srli	a1,t1,0x10
    1628:	01c686b3          	add	a3,a3,t3
    162c:	00d586b3          	add	a3,a1,a3
    1630:	02c80833          	mul	a6,a6,a2
    1634:	01c6f663          	bgeu	a3,t3,1640 <__udivdi3+0x408>
    1638:	00010637          	lui	a2,0x10
    163c:	00c80833          	add	a6,a6,a2
    1640:	0106d613          	srli	a2,a3,0x10
    1644:	01060633          	add	a2,a2,a6
    1648:	02c76663          	bltu	a4,a2,1674 <__udivdi3+0x43c>
    164c:	00c70863          	beq	a4,a2,165c <__udivdi3+0x424>
    1650:	00078513          	mv	a0,a5
    1654:	00000593          	li	a1,0
    1658:	00008067          	ret
    165c:	01031313          	slli	t1,t1,0x10
    1660:	01035313          	srli	t1,t1,0x10
    1664:	01069693          	slli	a3,a3,0x10
    1668:	01151533          	sll	a0,a0,a7
    166c:	006686b3          	add	a3,a3,t1
    1670:	fed570e3          	bgeu	a0,a3,1650 <__udivdi3+0x418>
    1674:	fff78513          	addi	a0,a5,-1
    1678:	00000593          	li	a1,0
    167c:	00008067          	ret
    1680:	010007b7          	lui	a5,0x1000
    1684:	04f67a63          	bgeu	a2,a5,16d8 <__udivdi3+0x4a0>
    1688:	01065693          	srli	a3,a2,0x10
    168c:	01000713          	li	a4,16
    1690:	d11ff06f          	j	13a0 <__udivdi3+0x168>
    1694:	00000593          	li	a1,0
    1698:	00100513          	li	a0,1
    169c:	00008067          	ret
    16a0:	00070513          	mv	a0,a4
    16a4:	e75ff06f          	j	1518 <__udivdi3+0x2e0>
    16a8:	00068813          	mv	a6,a3
    16ac:	f49ff06f          	j	15f4 <__udivdi3+0x3bc>
    16b0:	00050e13          	mv	t3,a0
    16b4:	e29ff06f          	j	14dc <__udivdi3+0x2a4>
    16b8:	00080793          	mv	a5,a6
    16bc:	efdff06f          	j	15b8 <__udivdi3+0x380>
    16c0:	ffe50513          	addi	a0,a0,-2
    16c4:	010787b3          	add	a5,a5,a6
    16c8:	d3dff06f          	j	1404 <__udivdi3+0x1cc>
    16cc:	ffe50513          	addi	a0,a0,-2
    16d0:	010787b3          	add	a5,a5,a6
    16d4:	c05ff06f          	j	12d8 <__udivdi3+0xa0>
    16d8:	01865693          	srli	a3,a2,0x18
    16dc:	01800713          	li	a4,24
    16e0:	cc1ff06f          	j	13a0 <__udivdi3+0x168>
