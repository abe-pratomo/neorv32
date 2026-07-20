
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
      1c:	80028293          	addi	t0,t0,-2048 # 1800 <_ctype_+0x60>
      20:	30029073          	csrw	mstatus,t0
      24:	00000317          	auipc	t1,0x0
      28:	19430313          	addi	t1,t1,404 # 1b8 <__crt0_panic>
      2c:	30531073          	csrw	mtvec,t1
      30:	30401073          	csrw	mie,zero
      34:	00002397          	auipc	t2,0x2
      38:	97038393          	addi	t2,t2,-1680 # 19a4 <__crt0_copy_data_src_begin>
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
     124:	4bc40413          	addi	s0,s0,1212 # 15dc <__fini_array_end>
  la    x9, __init_array_end
     128:	00001497          	auipc	s1,0x1
     12c:	4b448493          	addi	s1,s1,1204 # 15dc <__fini_array_end>

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
     148:	0c060613          	addi	a2,a2,192 # 204 <main>

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
     184:	45c40413          	addi	s0,s0,1116 # 15dc <__fini_array_end>
  la    x9, __fini_array_end
     188:	00001497          	auipc	s1,0x1
     18c:	45448493          	addi	s1,s1,1108 # 15dc <__fini_array_end>

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

000001c0 <sigmoid_q16>:

// ============================================================
// sigmoid using annx_exp hardware instruction
// ============================================================
int32_t sigmoid_q16(int32_t x)
{
     1c0:	ff010113          	addi	sp,sp,-16
     1c4:	00112623          	sw	ra,12(sp)

  register uint32_t __rd;
  register uint32_t __rs1 = rs1;
  register uint32_t __rs2 = rs2;

  asm volatile (".insn r %3, %4, %5, %0, %1, %2" : "=r"(__rd) : "r"(__rs1), "r"(__rs2), "i"(opcode), "i"(funct3), "i"(funct7));
     1c8:	00000793          	li	a5,0
     1cc:	00f5250b          	.insn	4, 0x00f5250b
    int32_t exp_x = annx_exp((uint32_t)x);
    int64_t num   = (int64_t)exp_x << FRAC_WIDTH;
    int64_t denom = (int64_t)65536 + (int64_t)exp_x;
     1d0:	00010637          	lui	a2,0x10
    int64_t num   = (int64_t)exp_x << FRAC_WIDTH;
     1d4:	41f55793          	srai	a5,a0,0x1f
    int64_t denom = (int64_t)65536 + (int64_t)exp_x;
     1d8:	00c50633          	add	a2,a0,a2
     1dc:	00a636b3          	sltu	a3,a2,a0
    int64_t num   = (int64_t)exp_x << FRAC_WIDTH;
     1e0:	01055593          	srli	a1,a0,0x10
     1e4:	01079713          	slli	a4,a5,0x10
    return (int32_t)(num / denom);
     1e8:	00f686b3          	add	a3,a3,a5
     1ec:	01051513          	slli	a0,a0,0x10
     1f0:	00e5e5b3          	or	a1,a1,a4
     1f4:	245000ef          	jal	c38 <__divdi3>
}
     1f8:	00c12083          	lw	ra,12(sp)
     1fc:	01010113          	addi	sp,sp,16
     200:	00008067          	ret

00000204 <main>:

int main() {
     204:	fc010113          	addi	sp,sp,-64
/**********************************************************************//**
 * Get current processor clock frequency.
 * @return Clock frequency in Hz.
 **************************************************************************/
inline uint32_t __attribute__ ((always_inline)) neorv32_sysinfo_get_clk(void) {
  return NEORV32_SYSINFO->CLK;
     208:	fffe07b7          	lui	a5,0xfffe0
    // Get the actual CPU clock frequency
    uint32_t NEORV32_CLK = neorv32_sysinfo_get_clk();

    // Initialize UART at 19200 baud
    if (!neorv32_uart0_available()) return -1;
     20c:	fff50537          	lui	a0,0xfff50
int main() {
     210:	03212823          	sw	s2,48(sp)
     214:	02112e23          	sw	ra,60(sp)
     218:	0007a903          	lw	s2,0(a5) # fffe0000 <__crt0_stack_top+0x7ffc0000>
     21c:	02812c23          	sw	s0,56(sp)
     220:	02912a23          	sw	s1,52(sp)
     224:	03312623          	sw	s3,44(sp)
     228:	03412423          	sw	s4,40(sp)
     22c:	03512223          	sw	s5,36(sp)
     230:	03612023          	sw	s6,32(sp)
     234:	01712e23          	sw	s7,28(sp)
    if (!neorv32_uart0_available()) return -1;
     238:	410000ef          	jal	648 <neorv32_uart_available>
     23c:	fff00793          	li	a5,-1
     240:	30050a63          	beqz	a0,554 <main+0x350>
    neorv32_uart0_setup(BAUD_RATE, 0);
     244:	000055b7          	lui	a1,0x5
     248:	00000613          	li	a2,0
     24c:	b0058593          	addi	a1,a1,-1280 # 4b00 <__neorv32_heap_size+0x2b00>
     250:	fff50537          	lui	a0,0xfff50
     254:	430000ef          	jal	684 <neorv32_uart_setup>

    // Print banner
    neorv32_uart0_printf("============= NEORV32 ANN ANNX Example =============\n");
     258:	000015b7          	lui	a1,0x1
     25c:	5e858593          	addi	a1,a1,1512 # 15e8 <__fini_array_end+0xc>
     260:	fff50537          	lui	a0,0xfff50
     264:	70c000ef          	jal	970 <neorv32_uart_printf>
    neorv32_uart0_printf("=== ANN for Indonesian Food Preference Detection ===\n");
     268:	000015b7          	lui	a1,0x1
     26c:	62058593          	addi	a1,a1,1568 # 1620 <__fini_array_end+0x44>
     270:	fff50537          	lui	a0,0xfff50
     274:	6fc000ef          	jal	970 <neorv32_uart_printf>
    neorv32_uart0_printf("====================================================\n\n");
     278:	000014b7          	lui	s1,0x1
     27c:	65848593          	addi	a1,s1,1624 # 1658 <__fini_array_end+0x7c>
     280:	fff50537          	lui	a0,0xfff50
     284:	6ec000ef          	jal	970 <neorv32_uart_printf>

    // Print taste values
    neorv32_uart0_printf("Input Taste Values:\n");
     288:	000015b7          	lui	a1,0x1
     28c:	69058593          	addi	a1,a1,1680 # 1690 <__fini_array_end+0xb4>
     290:	fff50537          	lui	a0,0xfff50
     294:	6dc000ef          	jal	970 <neorv32_uart_printf>
    neorv32_uart0_printf("Sourness  : %d.%04d\n"
     298:	93c18793          	addi	a5,gp,-1732 # 8000013c <inputs>
     29c:	0007a603          	lw	a2,0(a5)
     2a0:	0087a803          	lw	a6,8(a5)
     2a4:	00c7a303          	lw	t1,12(a5)
     2a8:	0047a703          	lw	a4,4(a5)
     2ac:	01081893          	slli	a7,a6,0x10
     2b0:	01061693          	slli	a3,a2,0x10
     2b4:	01071793          	slli	a5,a4,0x10
     2b8:	01031513          	slli	a0,t1,0x10
     2bc:	000025b7          	lui	a1,0x2
     2c0:	71058593          	addi	a1,a1,1808 # 2710 <__neorv32_heap_size+0x710>
     2c4:	01055513          	srli	a0,a0,0x10
     2c8:	0108d893          	srli	a7,a7,0x10
     2cc:	0107d793          	srli	a5,a5,0x10
     2d0:	0106d693          	srli	a3,a3,0x10
     2d4:	02b888b3          	mul	a7,a7,a1
     2d8:	41035313          	srai	t1,t1,0x10
     2dc:	00612023          	sw	t1,0(sp)
     2e0:	41085813          	srai	a6,a6,0x10
     2e4:	41075713          	srai	a4,a4,0x10
     2e8:	41065613          	srai	a2,a2,0x10
     2ec:	02b787b3          	mul	a5,a5,a1
     2f0:	0108d893          	srli	a7,a7,0x10
     2f4:	02b686b3          	mul	a3,a3,a1
     2f8:	0107d793          	srli	a5,a5,0x10
     2fc:	02b505b3          	mul	a1,a0,a1
     300:	0106d693          	srli	a3,a3,0x10
     304:	fff50537          	lui	a0,0xfff50
     308:	4105d593          	srai	a1,a1,0x10
     30c:	00b12223          	sw	a1,4(sp)
     310:	000015b7          	lui	a1,0x1
     314:	6a858593          	addi	a1,a1,1704 # 16a8 <__fini_array_end+0xcc>
     318:	658000ef          	jal	970 <neorv32_uart_printf>
 * @return Read data (uint32_t).
 **************************************************************************/
inline uint32_t __attribute__ ((always_inline)) neorv32_cpu_csr_read(const int csr_id) {

  uint32_t csr_data;
  asm volatile ("csrr %[dst], %[id]" : [dst] "=r" (csr_data) : [id] "i" (csr_id));
     31c:	c00029f3          	rdcycle	s3
    // LWA: rd = MEM[rs1 + imm7<<2] + rs2
    //   used to accumulate: sum = LWA(&h1_weights[i][j], prev_sum, j)
    //   but since LWA only adds one memory value to rs2, we use it as:
    //   sum = annx_lwa(&h1_weights[i][0], partial_sum, j)
    // --------------------------------------------------------
    for (int i = 0; i < h1_neuron; i++) {
     320:	8d818413          	addi	s0,gp,-1832 # 800000d8 <h1_weights>
     324:	8c018b13          	addi	s6,gp,-1856 # 800000c0 <h1_outputs>
     328:	06440b93          	addi	s7,s0,100
     32c:	93c18a13          	addi	s4,gp,-1732 # 8000013c <inputs>
     330:	8c018a93          	addi	s5,gp,-1856 # 800000c0 <h1_outputs>
     334:	000a2603          	lw	a2,0(s4)
     338:	00c4160b          	.insn	4, 0x00c4160b
     33c:	004a2783          	lw	a5,4(s4)
     340:	02f4178b          	.insn	4, 0x02f4178b
     344:	008a2683          	lw	a3,8(s4)
     348:	04d4168b          	.insn	4, 0x04d4168b
     34c:	00ca2703          	lw	a4,12(s4)
     350:	06e4170b          	.insn	4, 0x06e4170b
     354:	010a2503          	lw	a0,16(s4)
     358:	08a4150b          	.insn	4, 0x08a4150b
        int32_t p1 = annx_lwm(wbase, inputs[1], 1);
        int32_t p2 = annx_lwm(wbase, inputs[2], 2);
        int32_t p3 = annx_lwm(wbase, inputs[3], 3);
        int32_t p4 = annx_lwm(wbase, inputs[4], 4);

        int32_t sum = p0 + p1 + p2 + p3 + p4;
     35c:	00c787b3          	add	a5,a5,a2
     360:	00d787b3          	add	a5,a5,a3
     364:	00e787b3          	add	a5,a5,a4
        h1_outputs[i] = sigmoid_q16(sum);
     368:	00a78533          	add	a0,a5,a0
     36c:	e55ff0ef          	jal	1c0 <sigmoid_q16>
     370:	00ab2023          	sw	a0,0(s6)
    for (int i = 0; i < h1_neuron; i++) {
     374:	01440413          	addi	s0,s0,20
     378:	004b0b13          	addi	s6,s6,4
     37c:	fb741ce3          	bne	s0,s7,334 <main+0x130>
     380:	80000437          	lui	s0,0x80000
     384:	04840413          	addi	s0,s0,72 # 80000048 <h2_weights>
     388:	83018b13          	addi	s6,gp,-2000 # 80000030 <h2_outputs>
     38c:	07840b93          	addi	s7,s0,120
     390:	83018a13          	addi	s4,gp,-2000 # 80000030 <h2_outputs>
     394:	000aa583          	lw	a1,0(s5)
     398:	00b4158b          	.insn	4, 0x00b4158b
     39c:	004aa783          	lw	a5,4(s5)
     3a0:	02f4178b          	.insn	4, 0x02f4178b
     3a4:	008aa603          	lw	a2,8(s5)
     3a8:	04c4160b          	.insn	4, 0x04c4160b
     3ac:	00caa683          	lw	a3,12(s5)
     3b0:	06d4168b          	.insn	4, 0x06d4168b
     3b4:	010aa703          	lw	a4,16(s5)
     3b8:	08e4170b          	.insn	4, 0x08e4170b
     3bc:	014aa503          	lw	a0,20(s5)
     3c0:	0aa4150b          	.insn	4, 0x0aa4150b
        int32_t p2 = annx_lwm(wbase, h1_outputs[2], 2);
        int32_t p3 = annx_lwm(wbase, h1_outputs[3], 3);
        int32_t p4 = annx_lwm(wbase, h1_outputs[4], 4);
        int32_t p5 = annx_lwm(wbase, h1_outputs[5], 5);

        int32_t sum = p0 + p1 + p2 + p3 + p4 + p5;
     3c4:	00b787b3          	add	a5,a5,a1
     3c8:	00c787b3          	add	a5,a5,a2
     3cc:	00d787b3          	add	a5,a5,a3
     3d0:	00e787b3          	add	a5,a5,a4
        h2_outputs[i] = sigmoid_q16(sum);
     3d4:	00a78533          	add	a0,a5,a0
     3d8:	de9ff0ef          	jal	1c0 <sigmoid_q16>
     3dc:	00ab2023          	sw	a0,0(s6)
    for (int i = 0; i < h2_neuron; i++) {
     3e0:	01840413          	addi	s0,s0,24
     3e4:	004b0b13          	addi	s6,s6,4
     3e8:	fb7416e3          	bne	s0,s7,394 <main+0x190>
     3ec:	80000437          	lui	s0,0x80000
     3f0:	00040413          	mv	s0,s0
     3f4:	95018b13          	addi	s6,gp,-1712 # 80000150 <outputs>
     3f8:	03040b93          	addi	s7,s0,48 # 80000030 <h2_outputs>
     3fc:	95018a93          	addi	s5,gp,-1712 # 80000150 <outputs>
     400:	000a2583          	lw	a1,0(s4)
     404:	00b4158b          	.insn	4, 0x00b4158b
     408:	004a2783          	lw	a5,4(s4)
     40c:	02f4178b          	.insn	4, 0x02f4178b
     410:	008a2603          	lw	a2,8(s4)
     414:	04c4160b          	.insn	4, 0x04c4160b
     418:	00ca2683          	lw	a3,12(s4)
     41c:	06d4168b          	.insn	4, 0x06d4168b
     420:	010a2703          	lw	a4,16(s4)
     424:	08e4170b          	.insn	4, 0x08e4170b
     428:	014a2503          	lw	a0,20(s4)
     42c:	0aa4150b          	.insn	4, 0x0aa4150b
        int32_t p2 = annx_lwm(wbase, h2_outputs[2], 2);
        int32_t p3 = annx_lwm(wbase, h2_outputs[3], 3);
        int32_t p4 = annx_lwm(wbase, h2_outputs[4], 4);
        int32_t p5 = annx_lwm(wbase, h2_outputs[5], 5);

        int32_t sum = p0 + p1 + p2 + p3 + p4 + p5;
     430:	00b787b3          	add	a5,a5,a1
     434:	00c787b3          	add	a5,a5,a2
     438:	00d787b3          	add	a5,a5,a3
     43c:	00e787b3          	add	a5,a5,a4
        outputs[i] = sigmoid_q16(sum);
     440:	00a78533          	add	a0,a5,a0
     444:	d7dff0ef          	jal	1c0 <sigmoid_q16>
     448:	00ab2023          	sw	a0,0(s6)
    for (int i = 0; i < o_neuron; i++) {
     44c:	01840413          	addi	s0,s0,24
     450:	004b0b13          	addi	s6,s6,4
     454:	fa8b96e3          	bne	s7,s0,400 <main+0x1fc>
     458:	c0002473          	rdcycle	s0
    }

    // End calculation
    uint32_t end_time           = neorv32_cpu_csr_read(CSR_CYCLE);
    uint32_t elapsed_cycles     = end_time - start_time;
    uint32_t elapsed_time_ns    = (uint32_t)(((uint64_t)elapsed_cycles * 1000ULL) / (NEORV32_CLK / 1000000));
     45c:	000f4637          	lui	a2,0xf4
     460:	24060613          	addi	a2,a2,576 # f4240 <__neorv32_ram_size+0xd4240>
     464:	02c95633          	divu	a2,s2,a2
    uint32_t elapsed_cycles     = end_time - start_time;
     468:	41340433          	sub	s0,s0,s3
    uint32_t elapsed_time_ns    = (uint32_t)(((uint64_t)elapsed_cycles * 1000ULL) / (NEORV32_CLK / 1000000));
     46c:	3e800513          	li	a0,1000
     470:	00000693          	li	a3,0

    // Print results
    neorv32_uart0_printf("Output Values:\n");
    for (int i = 0; i < o_neuron; i++) {
        neorv32_uart0_printf("%s Value: %d.%04d\n", i ? "Not Tasty" : "Tasty", Q16_TO_INT(outputs[i]), Q16_TO_FRAC(outputs[i]));
     474:	00002937          	lui	s2,0x2
     478:	71090913          	addi	s2,s2,1808 # 2710 <__neorv32_heap_size+0x710>
     47c:	00001b37          	lui	s6,0x1
     480:	00001a37          	lui	s4,0x1
    uint32_t elapsed_time_ns    = (uint32_t)(((uint64_t)elapsed_cycles * 1000ULL) / (NEORV32_CLK / 1000000));
     484:	02a435b3          	mulhu	a1,s0,a0
     488:	02a40533          	mul	a0,s0,a0
     48c:	4a5000ef          	jal	1130 <__udivdi3>
    neorv32_uart0_printf("Output Values:\n");
     490:	000015b7          	lui	a1,0x1
     494:	6fc58593          	addi	a1,a1,1788 # 16fc <__fini_array_end+0x120>
    uint32_t elapsed_time_ns    = (uint32_t)(((uint64_t)elapsed_cycles * 1000ULL) / (NEORV32_CLK / 1000000));
     498:	00050993          	mv	s3,a0
    neorv32_uart0_printf("Output Values:\n");
     49c:	fff50537          	lui	a0,0xfff50
     4a0:	4d0000ef          	jal	970 <neorv32_uart_printf>
        neorv32_uart0_printf("%s Value: %d.%04d\n", i ? "Not Tasty" : "Tasty", Q16_TO_INT(outputs[i]), Q16_TO_FRAC(outputs[i]));
     4a4:	000aa683          	lw	a3,0(s5)
     4a8:	5e0a0613          	addi	a2,s4,1504 # 15e0 <__fini_array_end+0x4>
     4ac:	70cb0593          	addi	a1,s6,1804 # 170c <__fini_array_end+0x130>
     4b0:	01069713          	slli	a4,a3,0x10
     4b4:	01075713          	srli	a4,a4,0x10
     4b8:	03270733          	mul	a4,a4,s2
     4bc:	4106d693          	srai	a3,a3,0x10
     4c0:	fff50537          	lui	a0,0xfff50
     4c4:	01075713          	srli	a4,a4,0x10
     4c8:	4a8000ef          	jal	970 <neorv32_uart_printf>
     4cc:	004aa683          	lw	a3,4(s5)
     4d0:	70cb0593          	addi	a1,s6,1804
     4d4:	fff50537          	lui	a0,0xfff50
     4d8:	01069713          	slli	a4,a3,0x10
     4dc:	01075713          	srli	a4,a4,0x10
     4e0:	03270733          	mul	a4,a4,s2
     4e4:	00001937          	lui	s2,0x1
     4e8:	5dc90613          	addi	a2,s2,1500 # 15dc <__fini_array_end>
     4ec:	4106d693          	srai	a3,a3,0x10
     4f0:	01075713          	srli	a4,a4,0x10
     4f4:	47c000ef          	jal	970 <neorv32_uart_printf>
    }
    neorv32_uart0_printf("Conclusion: %s\n", (outputs[0] > outputs[1]) ? "Tasty" : "Not Tasty");
     4f8:	000aa703          	lw	a4,0(s5)
     4fc:	004aa783          	lw	a5,4(s5)
     500:	5dc90613          	addi	a2,s2,1500
     504:	00e7d463          	bge	a5,a4,50c <main+0x308>
     508:	5e0a0613          	addi	a2,s4,1504
     50c:	000015b7          	lui	a1,0x1
     510:	72058593          	addi	a1,a1,1824 # 1720 <__fini_array_end+0x144>
     514:	fff50537          	lui	a0,0xfff50
     518:	458000ef          	jal	970 <neorv32_uart_printf>
    neorv32_uart0_printf("Elapsed Time: %u cycles (%u ns)\n", elapsed_cycles, elapsed_time_ns);
     51c:	000015b7          	lui	a1,0x1
     520:	00098693          	mv	a3,s3
     524:	00040613          	mv	a2,s0
     528:	73058593          	addi	a1,a1,1840 # 1730 <__fini_array_end+0x154>
     52c:	fff50537          	lui	a0,0xfff50
     530:	440000ef          	jal	970 <neorv32_uart_printf>

    // Finish execution
    neorv32_uart0_printf("\n===================== THE END ======================\n");
     534:	000015b7          	lui	a1,0x1
     538:	75458593          	addi	a1,a1,1876 # 1754 <__fini_array_end+0x178>
     53c:	fff50537          	lui	a0,0xfff50
     540:	430000ef          	jal	970 <neorv32_uart_printf>
    neorv32_uart0_printf("====================================================\n\n");
     544:	65848593          	addi	a1,s1,1624
     548:	fff50537          	lui	a0,0xfff50
     54c:	424000ef          	jal	970 <neorv32_uart_printf>

    return 0;
     550:	00000793          	li	a5,0
     554:	03c12083          	lw	ra,60(sp)
     558:	03812403          	lw	s0,56(sp)
     55c:	03412483          	lw	s1,52(sp)
     560:	03012903          	lw	s2,48(sp)
     564:	02c12983          	lw	s3,44(sp)
     568:	02812a03          	lw	s4,40(sp)
     56c:	02412a83          	lw	s5,36(sp)
     570:	02012b03          	lw	s6,32(sp)
     574:	01c12b83          	lw	s7,28(sp)
     578:	00078513          	mv	a0,a5
     57c:	04010113          	addi	sp,sp,64
     580:	00008067          	ret

00000584 <neorv32_aux_itoa>:
 *
 * @param[in,out] buffer Pointer to array for the result string [33 chars].
 * @param[in] num Number to convert.
 * @param[in] base Base of number representation (2..16).
 **************************************************************************/
void neorv32_aux_itoa(char *buffer, uint32_t num, uint32_t base) {
     584:	fb010113          	addi	sp,sp,-80
     588:	05212023          	sw	s2,64(sp)
     58c:	00058913          	mv	s2,a1

  const char digits[16] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
     590:	000015b7          	lui	a1,0x1
void neorv32_aux_itoa(char *buffer, uint32_t num, uint32_t base) {
     594:	04812423          	sw	s0,72(sp)
     598:	04912223          	sw	s1,68(sp)
  const char digits[16] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
     59c:	78c58593          	addi	a1,a1,1932 # 178c <__fini_array_end+0x1b0>
void neorv32_aux_itoa(char *buffer, uint32_t num, uint32_t base) {
     5a0:	00060493          	mv	s1,a2
     5a4:	00050413          	mv	s0,a0
  const char digits[16] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
     5a8:	01000613          	li	a2,16
     5ac:	00c10513          	addi	a0,sp,12
void neorv32_aux_itoa(char *buffer, uint32_t num, uint32_t base) {
     5b0:	04112623          	sw	ra,76(sp)
  const char digits[16] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
     5b4:	4d0000ef          	jal	a84 <memcpy>
  char *tmp_ptr = 0;
  unsigned int i = 0;

  // prevent uninitialized stack bytes
  for (i=0; i<sizeof(tmp); i++) {
    tmp[i] = 0;
     5b8:	01c10693          	addi	a3,sp,28
     5bc:	02400613          	li	a2,36
     5c0:	00000593          	li	a1,0
     5c4:	00068513          	mv	a0,a3
     5c8:	3e0000ef          	jal	9a8 <memset>
  }

  if ((base < 2) || (base > 16)) { // invalid base?
     5cc:	ffe48613          	addi	a2,s1,-2
     5d0:	00e00713          	li	a4,14
     5d4:	02c77063          	bgeu	a4,a2,5f4 <neorv32_aux_itoa+0x70>
      buffer++;
    }
  }

  // terminate result string
  *buffer = '\0';
     5d8:	00040023          	sb	zero,0(s0)
}
     5dc:	04c12083          	lw	ra,76(sp)
     5e0:	04812403          	lw	s0,72(sp)
     5e4:	04412483          	lw	s1,68(sp)
     5e8:	04012903          	lw	s2,64(sp)
     5ec:	05010113          	addi	sp,sp,80
     5f0:	00008067          	ret
     5f4:	00050693          	mv	a3,a0
     5f8:	03f10793          	addi	a5,sp,63
    *tmp_ptr = digits[num%base];
     5fc:	02997733          	remu	a4,s2,s1
    tmp_ptr--;
     600:	fff78793          	addi	a5,a5,-1
    *tmp_ptr = digits[num%base];
     604:	04070713          	addi	a4,a4,64
     608:	00270733          	add	a4,a4,sp
     60c:	fcc74703          	lbu	a4,-52(a4)
     610:	00e78023          	sb	a4,0(a5)
    num /= base;
     614:	00090713          	mv	a4,s2
     618:	02995933          	divu	s2,s2,s1
  } while (num != 0);
     61c:	fe9770e3          	bgeu	a4,s1,5fc <neorv32_aux_itoa+0x78>
  for (i=0; i<sizeof(tmp); i++) {
     620:	00000793          	li	a5,0
     624:	02400613          	li	a2,36
    if (tmp[i] != '\0') {
     628:	00f68733          	add	a4,a3,a5
     62c:	00074703          	lbu	a4,0(a4)
     630:	00070663          	beqz	a4,63c <neorv32_aux_itoa+0xb8>
      *buffer = tmp[i];
     634:	00e40023          	sb	a4,0(s0)
      buffer++;
     638:	00140413          	addi	s0,s0,1
  for (i=0; i<sizeof(tmp); i++) {
     63c:	00178793          	addi	a5,a5,1
     640:	fec794e3          	bne	a5,a2,628 <neorv32_aux_itoa+0xa4>
     644:	f95ff06f          	j	5d8 <neorv32_aux_itoa+0x54>

00000648 <neorv32_uart_available>:
 * @param[in,out] Hardware handle to UART register struct, #neorv32_uart_t.
 * @return 0 if UART0/1 was not synthesized, non-zero if UART0/1 is available.
 **************************************************************************/
int neorv32_uart_available(neorv32_uart_t *UARTx) {

  if (UARTx == NEORV32_UART0) {
     648:	fff50737          	lui	a4,0xfff50
int neorv32_uart_available(neorv32_uart_t *UARTx) {
     64c:	00050793          	mv	a5,a0
  if (UARTx == NEORV32_UART0) {
     650:	00e51c63          	bne	a0,a4,668 <neorv32_uart_available+0x20>
    return (int)(NEORV32_SYSINFO->SOC & (1 << SYSINFO_SOC_IO_UART0));
     654:	fffe07b7          	lui	a5,0xfffe0
     658:	0087a503          	lw	a0,8(a5) # fffe0008 <__crt0_stack_top+0x7ffc0008>
     65c:	000207b7          	lui	a5,0x20
  }
  else if (UARTx == NEORV32_UART1) {
    return (int)(NEORV32_SYSINFO->SOC & (1 << SYSINFO_SOC_IO_UART1));
     660:	00f57533          	and	a0,a0,a5
  }
  else {
    return 0;
  }
}
     664:	00008067          	ret
  else if (UARTx == NEORV32_UART1) {
     668:	fff60737          	lui	a4,0xfff60
    return 0;
     66c:	00000513          	li	a0,0
  else if (UARTx == NEORV32_UART1) {
     670:	fee79ae3          	bne	a5,a4,664 <neorv32_uart_available+0x1c>
    return (int)(NEORV32_SYSINFO->SOC & (1 << SYSINFO_SOC_IO_UART1));
     674:	fffe07b7          	lui	a5,0xfffe0
     678:	0087a503          	lw	a0,8(a5) # fffe0008 <__crt0_stack_top+0x7ffc0008>
     67c:	020007b7          	lui	a5,0x2000
     680:	fe1ff06f          	j	660 <neorv32_uart_available+0x18>

00000684 <neorv32_uart_setup>:

  uint32_t prsc_sel = 0;
  uint32_t baud_div = 0;

  // reset
  UARTx->CTRL = 0;
     684:	00052023          	sw	zero,0(a0) # fff50000 <__crt0_stack_top+0x7ff30000>
     688:	fffe07b7          	lui	a5,0xfffe0
     68c:	0007a783          	lw	a5,0(a5) # fffe0000 <__crt0_stack_top+0x7ffc0000>

  // raw clock prescaler
  uint32_t clock = neorv32_sysinfo_get_clk(); // system clock in Hz
#ifndef MAKE_BOOTLOADER // use div instructions / library functions
  baud_div = clock / (2*baudrate);
     690:	00159593          	slli	a1,a1,0x1
  uint32_t prsc_sel = 0;
     694:	00000713          	li	a4,0
  baud_div = clock / (2*baudrate);
     698:	02b7d7b3          	divu	a5,a5,a1
    baud_div++;
  }
#endif

  // find baud prescaler (10-bit wide))
  while (baud_div >= 0x3ffU) {
     69c:	3fe00593          	li	a1,1022
     6a0:	02f5ec63          	bltu	a1,a5,6d8 <neorv32_uart_setup+0x54>
  }

  uint32_t tmp = 0;
  tmp |= (uint32_t)(1              & 1U)     << UART_CTRL_EN;
  tmp |= (uint32_t)(prsc_sel       & 3U)     << UART_CTRL_PRSC_LSB;
  tmp |= (uint32_t)((baud_div - 1) & 0x3ffU) << UART_CTRL_BAUD_LSB;
     6a4:	fff78793          	addi	a5,a5,-1
     6a8:	00679793          	slli	a5,a5,0x6
     6ac:	01079793          	slli	a5,a5,0x10
  tmp |= (uint32_t)(irq_mask       & (0xfu   << UART_CTRL_IRQ_RX_NEMPTY));
     6b0:	00f006b7          	lui	a3,0xf00
  tmp |= (uint32_t)((baud_div - 1) & 0x3ffU) << UART_CTRL_BAUD_LSB;
     6b4:	0107d793          	srli	a5,a5,0x10
  tmp |= (uint32_t)(irq_mask       & (0xfu   << UART_CTRL_IRQ_RX_NEMPTY));
     6b8:	00d67633          	and	a2,a2,a3
  tmp |= (uint32_t)(prsc_sel       & 3U)     << UART_CTRL_PRSC_LSB;
     6bc:	00371713          	slli	a4,a4,0x3
  tmp |= (uint32_t)(irq_mask       & (0xfu   << UART_CTRL_IRQ_RX_NEMPTY));
     6c0:	00c7e7b3          	or	a5,a5,a2
  tmp |= (uint32_t)(prsc_sel       & 3U)     << UART_CTRL_PRSC_LSB;
     6c4:	01877713          	andi	a4,a4,24
  tmp |= (uint32_t)(irq_mask       & (0xfu   << UART_CTRL_IRQ_RX_NEMPTY));
     6c8:	00e7e7b3          	or	a5,a5,a4
     6cc:	0017e793          	ori	a5,a5,1
  if (((uint32_t)UARTx) == NEORV32_UART1_BASE) {
    tmp |= 1U << UART_CTRL_SIM_MODE;
  }
#endif

  UARTx->CTRL = tmp;
     6d0:	00f52023          	sw	a5,0(a0)
}
     6d4:	00008067          	ret
    if ((prsc_sel == 2) || (prsc_sel == 4))
     6d8:	ffe70693          	addi	a3,a4,-2 # fff5fffe <__crt0_stack_top+0x7ff3fffe>
     6dc:	ffd6f693          	andi	a3,a3,-3
     6e0:	00069863          	bnez	a3,6f0 <neorv32_uart_setup+0x6c>
      baud_div >>= 3;
     6e4:	0037d793          	srli	a5,a5,0x3
    prsc_sel++;
     6e8:	00170713          	addi	a4,a4,1
     6ec:	fb5ff06f          	j	6a0 <neorv32_uart_setup+0x1c>
      baud_div >>= 1;
     6f0:	0017d793          	srli	a5,a5,0x1
     6f4:	ff5ff06f          	j	6e8 <neorv32_uart_setup+0x64>

000006f8 <neorv32_uart_putc>:
 * @param[in,out] UARTx Hardware handle to UART register struct, #neorv32_uart_t.
 * @param[in] c Char to be send.
 **************************************************************************/
void neorv32_uart_putc(neorv32_uart_t *UARTx, char c) {

  while ((UARTx->CTRL & (1<<UART_CTRL_TX_NFULL)) == 0); // wait for free space in TX FIFO
     6f8:	00052783          	lw	a5,0(a0)
     6fc:	00c79713          	slli	a4,a5,0xc
     700:	fe075ce3          	bgez	a4,6f8 <neorv32_uart_putc>
void neorv32_uart_tx_put(neorv32_uart_t *UARTx, char c) {

#ifdef UART_SEMIHOSTING
  neorv32_semihosting_putc(c);
#else
  UARTx->DATA = (uint32_t)c << UART_DATA_RTX_LSB;
     704:	00b52223          	sw	a1,4(a0)
}
     708:	00008067          	ret

0000070c <neorv32_uart_puts>:
 * @warning "/n" line breaks are automatically converted to "/r/n".
 *
 * @param[in,out] UARTx Hardware handle to UART register struct, #neorv32_uart_t.
 * @param[in] s Pointer to string.
 **************************************************************************/
void neorv32_uart_puts(neorv32_uart_t *UARTx, const char *s) {
     70c:	fe010113          	addi	sp,sp,-32
     710:	00812c23          	sw	s0,24(sp)
     714:	00912a23          	sw	s1,20(sp)
     718:	01312623          	sw	s3,12(sp)
     71c:	00112e23          	sw	ra,28(sp)
     720:	01212823          	sw	s2,16(sp)
     724:	00050493          	mv	s1,a0
     728:	00058413          	mv	s0,a1
#ifdef UART_SEMIHOSTING
  neorv32_semihosting_puts(s);
#else
  char c = 0;
  while ((c = *s++)) {
    if (c == '\n') {
     72c:	00a00993          	li	s3,10
  while ((c = *s++)) {
     730:	00044903          	lbu	s2,0(s0)
     734:	00140413          	addi	s0,s0,1
     738:	02091063          	bnez	s2,758 <neorv32_uart_puts+0x4c>
      neorv32_uart_putc(UARTx, '\r');
    }
    neorv32_uart_putc(UARTx, c);
  }
#endif
}
     73c:	01c12083          	lw	ra,28(sp)
     740:	01812403          	lw	s0,24(sp)
     744:	01412483          	lw	s1,20(sp)
     748:	01012903          	lw	s2,16(sp)
     74c:	00c12983          	lw	s3,12(sp)
     750:	02010113          	addi	sp,sp,32
     754:	00008067          	ret
    if (c == '\n') {
     758:	01391863          	bne	s2,s3,768 <neorv32_uart_puts+0x5c>
      neorv32_uart_putc(UARTx, '\r');
     75c:	00d00593          	li	a1,13
     760:	00048513          	mv	a0,s1
     764:	f95ff0ef          	jal	6f8 <neorv32_uart_putc>
    neorv32_uart_putc(UARTx, c);
     768:	00090593          	mv	a1,s2
     76c:	00048513          	mv	a0,s1
     770:	f89ff0ef          	jal	6f8 <neorv32_uart_putc>
     774:	fbdff06f          	j	730 <neorv32_uart_puts+0x24>

00000778 <neorv32_uart_vprintf>:
 *
 * @param[in,out] UARTx Hardware handle to UART register struct, #neorv32_uart_t.
 * @param[in] format Pointer to format string.
 * @param[in] args A value identifying a variable arguments list.
 **************************************************************************/
void neorv32_uart_vprintf(neorv32_uart_t *UARTx, const char *format, va_list args) {
     778:	fa010113          	addi	sp,sp,-96
     77c:	04812c23          	sw	s0,88(sp)
     780:	04912a23          	sw	s1,84(sp)
     784:	05212823          	sw	s2,80(sp)
     788:	00050493          	mv	s1,a0
     78c:	00058913          	mv	s2,a1
     790:	00060413          	mv	s0,a2
  int32_t n = 0;
  unsigned int i = 0;

  // prevent uninitialized stack bytes
  for (i=0; i<sizeof(string_buf); i++) {
    string_buf[i] = 0;
     794:	00000593          	li	a1,0
     798:	02400613          	li	a2,36
     79c:	00c10513          	addi	a0,sp,12
void neorv32_uart_vprintf(neorv32_uart_t *UARTx, const char *format, va_list args) {
     7a0:	05312623          	sw	s3,76(sp)
     7a4:	05512223          	sw	s5,68(sp)
     7a8:	05612023          	sw	s6,64(sp)
     7ac:	03712e23          	sw	s7,60(sp)
     7b0:	03812c23          	sw	s8,56(sp)
     7b4:	03912a23          	sw	s9,52(sp)
     7b8:	04112e23          	sw	ra,92(sp)
     7bc:	05412423          	sw	s4,72(sp)
     7c0:	03a12823          	sw	s10,48(sp)
  }

  while ((c = *format++)) {
    if (c == '%') {
     7c4:	02500a93          	li	s5,37
    string_buf[i] = 0;
     7c8:	1e0000ef          	jal	9a8 <memset>
          neorv32_uart_putc(UARTx, c);
          break;
      }
    }
    else {
      if (c == '\n') {
     7cc:	00a00b13          	li	s6,10
      c = tolower(*format++);
     7d0:	00001bb7          	lui	s7,0x1
     7d4:	00100c13          	li	s8,1
      switch (c) {
     7d8:	07000993          	li	s3,112
     7dc:	07500c93          	li	s9,117
  while ((c = *format++)) {
     7e0:	00094d03          	lbu	s10,0(s2)
     7e4:	020d1e63          	bnez	s10,820 <neorv32_uart_vprintf+0xa8>
        neorv32_uart_putc(UARTx, '\r');
      }
      neorv32_uart_putc(UARTx, c);
    }
  }
}
     7e8:	05c12083          	lw	ra,92(sp)
     7ec:	05812403          	lw	s0,88(sp)
     7f0:	05412483          	lw	s1,84(sp)
     7f4:	05012903          	lw	s2,80(sp)
     7f8:	04c12983          	lw	s3,76(sp)
     7fc:	04812a03          	lw	s4,72(sp)
     800:	04412a83          	lw	s5,68(sp)
     804:	04012b03          	lw	s6,64(sp)
     808:	03c12b83          	lw	s7,60(sp)
     80c:	03812c03          	lw	s8,56(sp)
     810:	03412c83          	lw	s9,52(sp)
     814:	03012d03          	lw	s10,48(sp)
     818:	06010113          	addi	sp,sp,96
     81c:	00008067          	ret
    if (c == '%') {
     820:	135d1a63          	bne	s10,s5,954 <neorv32_uart_vprintf+0x1dc>
      c = tolower(*format++);
     824:	00290a13          	addi	s4,s2,2
     828:	00194903          	lbu	s2,1(s2)
     82c:	7a1b8793          	addi	a5,s7,1953 # 17a1 <_ctype_+0x1>
     830:	00f907b3          	add	a5,s2,a5
     834:	0007c783          	lbu	a5,0(a5)
     838:	0037f793          	andi	a5,a5,3
     83c:	01879463          	bne	a5,s8,844 <neorv32_uart_vprintf+0xcc>
     840:	02090913          	addi	s2,s2,32
      switch (c) {
     844:	0ff97593          	zext.b	a1,s2
     848:	0d358863          	beq	a1,s3,918 <neorv32_uart_vprintf+0x1a0>
     84c:	06b9cc63          	blt	s3,a1,8c4 <neorv32_uart_vprintf+0x14c>
     850:	06300793          	li	a5,99
     854:	08f58c63          	beq	a1,a5,8ec <neorv32_uart_vprintf+0x174>
     858:	02b7c463          	blt	a5,a1,880 <neorv32_uart_vprintf+0x108>
     85c:	02500793          	li	a5,37
     860:	00f58a63          	beq	a1,a5,874 <neorv32_uart_vprintf+0xfc>
          neorv32_uart_putc(UARTx, '%');
     864:	02500593          	li	a1,37
     868:	00048513          	mv	a0,s1
     86c:	e8dff0ef          	jal	6f8 <neorv32_uart_putc>
          neorv32_uart_putc(UARTx, c);
     870:	0ff97593          	zext.b	a1,s2
      neorv32_uart_putc(UARTx, c);
     874:	00048513          	mv	a0,s1
     878:	e81ff0ef          	jal	6f8 <neorv32_uart_putc>
     87c:	0840006f          	j	900 <neorv32_uart_vprintf+0x188>
      switch (c) {
     880:	06400793          	li	a5,100
     884:	00f58663          	beq	a1,a5,890 <neorv32_uart_vprintf+0x118>
     888:	06900793          	li	a5,105
     88c:	fcf59ce3          	bne	a1,a5,864 <neorv32_uart_vprintf+0xec>
          n = (int32_t)va_arg(args, int32_t);
     890:	00440913          	addi	s2,s0,4
     894:	00042403          	lw	s0,0(s0)
          if (n < 0) {
     898:	00045a63          	bgez	s0,8ac <neorv32_uart_vprintf+0x134>
            neorv32_uart_putc(UARTx, '-');
     89c:	02d00593          	li	a1,45
     8a0:	00048513          	mv	a0,s1
            n = -n;
     8a4:	40800433          	neg	s0,s0
            neorv32_uart_putc(UARTx, '-');
     8a8:	e51ff0ef          	jal	6f8 <neorv32_uart_putc>
          neorv32_aux_itoa(string_buf, (uint32_t)n, 10);
     8ac:	00a00613          	li	a2,10
     8b0:	00040593          	mv	a1,s0
          neorv32_aux_itoa(string_buf, va_arg(args, uint32_t), 10);
     8b4:	00c10513          	addi	a0,sp,12
     8b8:	ccdff0ef          	jal	584 <neorv32_aux_itoa>
          neorv32_uart_puts(UARTx, string_buf);
     8bc:	00c10593          	addi	a1,sp,12
     8c0:	0200006f          	j	8e0 <neorv32_uart_vprintf+0x168>
      switch (c) {
     8c4:	05958263          	beq	a1,s9,908 <neorv32_uart_vprintf+0x190>
     8c8:	07800793          	li	a5,120
     8cc:	04f58663          	beq	a1,a5,918 <neorv32_uart_vprintf+0x1a0>
     8d0:	07300793          	li	a5,115
     8d4:	f8f598e3          	bne	a1,a5,864 <neorv32_uart_vprintf+0xec>
          neorv32_uart_puts(UARTx, va_arg(args, char*));
     8d8:	00042583          	lw	a1,0(s0)
     8dc:	00440913          	addi	s2,s0,4
          neorv32_uart_puts(UARTx, string_buf);
     8e0:	00048513          	mv	a0,s1
     8e4:	e29ff0ef          	jal	70c <neorv32_uart_puts>
          break;
     8e8:	0140006f          	j	8fc <neorv32_uart_vprintf+0x184>
          neorv32_uart_putc(UARTx, (char)va_arg(args, int));
     8ec:	00044583          	lbu	a1,0(s0)
     8f0:	00048513          	mv	a0,s1
     8f4:	00440913          	addi	s2,s0,4
     8f8:	e01ff0ef          	jal	6f8 <neorv32_uart_putc>
     8fc:	00090413          	mv	s0,s2
          neorv32_uart_puts(UARTx, va_arg(args, char*));
     900:	000a0913          	mv	s2,s4
     904:	eddff06f          	j	7e0 <neorv32_uart_vprintf+0x68>
          neorv32_aux_itoa(string_buf, va_arg(args, uint32_t), 10);
     908:	00042583          	lw	a1,0(s0)
     90c:	00440913          	addi	s2,s0,4
     910:	00a00613          	li	a2,10
     914:	fa1ff06f          	j	8b4 <neorv32_uart_vprintf+0x13c>
          neorv32_aux_itoa(string_buf, va_arg(args, uint32_t), 16);
     918:	00042583          	lw	a1,0(s0)
     91c:	01000613          	li	a2,16
     920:	00c10513          	addi	a0,sp,12
     924:	c61ff0ef          	jal	584 <neorv32_aux_itoa>
          i = 8 - strlen(string_buf);
     928:	00c10513          	addi	a0,sp,12
          neorv32_aux_itoa(string_buf, va_arg(args, uint32_t), 16);
     92c:	00440913          	addi	s2,s0,4
          i = 8 - strlen(string_buf);
     930:	27c000ef          	jal	bac <strlen>
     934:	00800413          	li	s0,8
     938:	40a40433          	sub	s0,s0,a0
          while (i--) { // add leading zeros
     93c:	f80400e3          	beqz	s0,8bc <neorv32_uart_vprintf+0x144>
            neorv32_uart_putc(UARTx, '0');
     940:	03000593          	li	a1,48
     944:	00048513          	mv	a0,s1
     948:	db1ff0ef          	jal	6f8 <neorv32_uart_putc>
     94c:	fff40413          	addi	s0,s0,-1
     950:	fedff06f          	j	93c <neorv32_uart_vprintf+0x1c4>
      if (c == '\n') {
     954:	016d1863          	bne	s10,s6,964 <neorv32_uart_vprintf+0x1ec>
        neorv32_uart_putc(UARTx, '\r');
     958:	00d00593          	li	a1,13
     95c:	00048513          	mv	a0,s1
     960:	d99ff0ef          	jal	6f8 <neorv32_uart_putc>
  while ((c = *format++)) {
     964:	00190a13          	addi	s4,s2,1
      neorv32_uart_putc(UARTx, c);
     968:	000d0593          	mv	a1,s10
     96c:	f09ff06f          	j	874 <neorv32_uart_vprintf+0xfc>

00000970 <neorv32_uart_printf>:
 * @note This function is blocking.
 *
 * @param[in,out] UARTx Hardware handle to UART register struct, #neorv32_uart_t.
 * @param[in] format Pointer to format string. See neorv32_uart_vprintf.
 **************************************************************************/
void neorv32_uart_printf(neorv32_uart_t *UARTx, const char *format, ...) {
     970:	fc010113          	addi	sp,sp,-64
     974:	02c12423          	sw	a2,40(sp)

  va_list args;
  va_start(args, format);
     978:	02810613          	addi	a2,sp,40
void neorv32_uart_printf(neorv32_uart_t *UARTx, const char *format, ...) {
     97c:	00112e23          	sw	ra,28(sp)
     980:	02d12623          	sw	a3,44(sp)
     984:	02e12823          	sw	a4,48(sp)
     988:	02f12a23          	sw	a5,52(sp)
     98c:	03012c23          	sw	a6,56(sp)
     990:	03112e23          	sw	a7,60(sp)
  va_start(args, format);
     994:	00c12623          	sw	a2,12(sp)
  neorv32_uart_vprintf(UARTx, format, args);
     998:	de1ff0ef          	jal	778 <neorv32_uart_vprintf>
  va_end(args);
}
     99c:	01c12083          	lw	ra,28(sp)
     9a0:	04010113          	addi	sp,sp,64
     9a4:	00008067          	ret

000009a8 <memset>:
     9a8:	00f00313          	li	t1,15
     9ac:	00050713          	mv	a4,a0
     9b0:	02c37e63          	bgeu	t1,a2,9ec <memset+0x44>
     9b4:	00f77793          	andi	a5,a4,15
     9b8:	0a079063          	bnez	a5,a58 <memset+0xb0>
     9bc:	08059263          	bnez	a1,a40 <memset+0x98>
     9c0:	ff067693          	andi	a3,a2,-16
     9c4:	00f67613          	andi	a2,a2,15
     9c8:	00e686b3          	add	a3,a3,a4
     9cc:	00b72023          	sw	a1,0(a4)
     9d0:	00b72223          	sw	a1,4(a4)
     9d4:	00b72423          	sw	a1,8(a4)
     9d8:	00b72623          	sw	a1,12(a4)
     9dc:	01070713          	addi	a4,a4,16
     9e0:	fed766e3          	bltu	a4,a3,9cc <memset+0x24>
     9e4:	00061463          	bnez	a2,9ec <memset+0x44>
     9e8:	00008067          	ret
     9ec:	40c306b3          	sub	a3,t1,a2
     9f0:	00269693          	slli	a3,a3,0x2
     9f4:	00000297          	auipc	t0,0x0
     9f8:	005686b3          	add	a3,a3,t0
     9fc:	00c68067          	jr	12(a3) # f0000c <__neorv32_ram_size+0xee000c>
     a00:	00b70723          	sb	a1,14(a4)
     a04:	00b706a3          	sb	a1,13(a4)
     a08:	00b70623          	sb	a1,12(a4)
     a0c:	00b705a3          	sb	a1,11(a4)
     a10:	00b70523          	sb	a1,10(a4)
     a14:	00b704a3          	sb	a1,9(a4)
     a18:	00b70423          	sb	a1,8(a4)
     a1c:	00b703a3          	sb	a1,7(a4)
     a20:	00b70323          	sb	a1,6(a4)
     a24:	00b702a3          	sb	a1,5(a4)
     a28:	00b70223          	sb	a1,4(a4)
     a2c:	00b701a3          	sb	a1,3(a4)
     a30:	00b70123          	sb	a1,2(a4)
     a34:	00b700a3          	sb	a1,1(a4)
     a38:	00b70023          	sb	a1,0(a4)
     a3c:	00008067          	ret
     a40:	0ff5f593          	zext.b	a1,a1
     a44:	00859693          	slli	a3,a1,0x8
     a48:	00d5e5b3          	or	a1,a1,a3
     a4c:	01059693          	slli	a3,a1,0x10
     a50:	00d5e5b3          	or	a1,a1,a3
     a54:	f6dff06f          	j	9c0 <memset+0x18>
     a58:	00279693          	slli	a3,a5,0x2
     a5c:	00000297          	auipc	t0,0x0
     a60:	005686b3          	add	a3,a3,t0
     a64:	00008293          	mv	t0,ra
     a68:	fa0680e7          	jalr	-96(a3)
     a6c:	00028093          	mv	ra,t0
     a70:	ff078793          	addi	a5,a5,-16
     a74:	40f70733          	sub	a4,a4,a5
     a78:	00f60633          	add	a2,a2,a5
     a7c:	f6c378e3          	bgeu	t1,a2,9ec <memset+0x44>
     a80:	f3dff06f          	j	9bc <memset+0x14>

00000a84 <memcpy>:
     a84:	00a5c7b3          	xor	a5,a1,a0
     a88:	0037f793          	andi	a5,a5,3
     a8c:	00c508b3          	add	a7,a0,a2
     a90:	06079663          	bnez	a5,afc <memcpy+0x78>
     a94:	00300793          	li	a5,3
     a98:	06c7f263          	bgeu	a5,a2,afc <memcpy+0x78>
     a9c:	00357793          	andi	a5,a0,3
     aa0:	00050713          	mv	a4,a0
     aa4:	0c079a63          	bnez	a5,b78 <memcpy+0xf4>
     aa8:	ffc8f613          	andi	a2,a7,-4
     aac:	40e606b3          	sub	a3,a2,a4
     ab0:	02000793          	li	a5,32
     ab4:	06d7c463          	blt	a5,a3,b1c <memcpy+0x98>
     ab8:	00058693          	mv	a3,a1
     abc:	00070793          	mv	a5,a4
     ac0:	02c77a63          	bgeu	a4,a2,af4 <memcpy+0x70>
     ac4:	0006a803          	lw	a6,0(a3)
     ac8:	00478793          	addi	a5,a5,4
     acc:	00468693          	addi	a3,a3,4
     ad0:	ff07ae23          	sw	a6,-4(a5)
     ad4:	fec7e8e3          	bltu	a5,a2,ac4 <memcpy+0x40>
     ad8:	fff60613          	addi	a2,a2,-1
     adc:	40e60633          	sub	a2,a2,a4
     ae0:	ffc67613          	andi	a2,a2,-4
     ae4:	00458593          	addi	a1,a1,4
     ae8:	00470713          	addi	a4,a4,4
     aec:	00c585b3          	add	a1,a1,a2
     af0:	00c70733          	add	a4,a4,a2
     af4:	01176863          	bltu	a4,a7,b04 <memcpy+0x80>
     af8:	00008067          	ret
     afc:	00050713          	mv	a4,a0
     b00:	ff157ce3          	bgeu	a0,a7,af8 <memcpy+0x74>
     b04:	0005c783          	lbu	a5,0(a1)
     b08:	00170713          	addi	a4,a4,1
     b0c:	00158593          	addi	a1,a1,1
     b10:	fef70fa3          	sb	a5,-1(a4)
     b14:	fee898e3          	bne	a7,a4,b04 <memcpy+0x80>
     b18:	00008067          	ret
     b1c:	0205a683          	lw	a3,32(a1)
     b20:	0005a383          	lw	t2,0(a1)
     b24:	0045a283          	lw	t0,4(a1)
     b28:	0085af83          	lw	t6,8(a1)
     b2c:	00c5af03          	lw	t5,12(a1)
     b30:	0105ae83          	lw	t4,16(a1)
     b34:	0145ae03          	lw	t3,20(a1)
     b38:	0185a303          	lw	t1,24(a1)
     b3c:	01c5a803          	lw	a6,28(a1)
     b40:	02470713          	addi	a4,a4,36
     b44:	fed72e23          	sw	a3,-4(a4)
     b48:	fc772e23          	sw	t2,-36(a4)
     b4c:	40e606b3          	sub	a3,a2,a4
     b50:	fe572023          	sw	t0,-32(a4)
     b54:	fff72223          	sw	t6,-28(a4)
     b58:	ffe72423          	sw	t5,-24(a4)
     b5c:	ffd72623          	sw	t4,-20(a4)
     b60:	ffc72823          	sw	t3,-16(a4)
     b64:	fe672a23          	sw	t1,-12(a4)
     b68:	ff072c23          	sw	a6,-8(a4)
     b6c:	02458593          	addi	a1,a1,36
     b70:	fad7c6e3          	blt	a5,a3,b1c <memcpy+0x98>
     b74:	f45ff06f          	j	ab8 <memcpy+0x34>
     b78:	0005c683          	lbu	a3,0(a1)
     b7c:	00170713          	addi	a4,a4,1
     b80:	00377793          	andi	a5,a4,3
     b84:	fed70fa3          	sb	a3,-1(a4)
     b88:	00158593          	addi	a1,a1,1
     b8c:	f0078ee3          	beqz	a5,aa8 <memcpy+0x24>
     b90:	0005c683          	lbu	a3,0(a1)
     b94:	00170713          	addi	a4,a4,1
     b98:	00377793          	andi	a5,a4,3
     b9c:	fed70fa3          	sb	a3,-1(a4)
     ba0:	00158593          	addi	a1,a1,1
     ba4:	fc079ae3          	bnez	a5,b78 <memcpy+0xf4>
     ba8:	f01ff06f          	j	aa8 <memcpy+0x24>

00000bac <strlen>:
     bac:	00357793          	andi	a5,a0,3
     bb0:	00050713          	mv	a4,a0
     bb4:	04079c63          	bnez	a5,c0c <strlen+0x60>
     bb8:	7f7f86b7          	lui	a3,0x7f7f8
     bbc:	f7f68693          	addi	a3,a3,-129 # 7f7f7f7f <__neorv32_ram_size+0x7f7d7f7f>
     bc0:	fff00593          	li	a1,-1
     bc4:	00072603          	lw	a2,0(a4)
     bc8:	00470713          	addi	a4,a4,4
     bcc:	00d677b3          	and	a5,a2,a3
     bd0:	00d787b3          	add	a5,a5,a3
     bd4:	00c7e7b3          	or	a5,a5,a2
     bd8:	00d7e7b3          	or	a5,a5,a3
     bdc:	feb784e3          	beq	a5,a1,bc4 <strlen+0x18>
     be0:	ffc74683          	lbu	a3,-4(a4)
     be4:	40a707b3          	sub	a5,a4,a0
     be8:	04068463          	beqz	a3,c30 <strlen+0x84>
     bec:	ffd74683          	lbu	a3,-3(a4)
     bf0:	02068c63          	beqz	a3,c28 <strlen+0x7c>
     bf4:	ffe74503          	lbu	a0,-2(a4)
     bf8:	00a03533          	snez	a0,a0
     bfc:	00f50533          	add	a0,a0,a5
     c00:	ffe50513          	addi	a0,a0,-2
     c04:	00008067          	ret
     c08:	fa0688e3          	beqz	a3,bb8 <strlen+0xc>
     c0c:	00074783          	lbu	a5,0(a4)
     c10:	00170713          	addi	a4,a4,1
     c14:	00377693          	andi	a3,a4,3
     c18:	fe0798e3          	bnez	a5,c08 <strlen+0x5c>
     c1c:	40a70733          	sub	a4,a4,a0
     c20:	fff70513          	addi	a0,a4,-1
     c24:	00008067          	ret
     c28:	ffd78513          	addi	a0,a5,-3
     c2c:	00008067          	ret
     c30:	ffc78513          	addi	a0,a5,-4
     c34:	00008067          	ret

00000c38 <__divdi3>:
     c38:	00000813          	li	a6,0
     c3c:	1205c663          	bltz	a1,d68 <__divdi3+0x130>
     c40:	0006dc63          	bgez	a3,c58 <__divdi3+0x20>
     c44:	00c037b3          	snez	a5,a2
     c48:	40d006b3          	neg	a3,a3
     c4c:	fff84813          	not	a6,a6
     c50:	40f686b3          	sub	a3,a3,a5
     c54:	40c00633          	neg	a2,a2
     c58:	00060893          	mv	a7,a2
     c5c:	00050793          	mv	a5,a0
     c60:	00058313          	mv	t1,a1
     c64:	0e069a63          	bnez	a3,d58 <__divdi3+0x120>
     c68:	16c5f463          	bgeu	a1,a2,dd0 <__divdi3+0x198>
     c6c:	00010737          	lui	a4,0x10
     c70:	22e66463          	bltu	a2,a4,e98 <__divdi3+0x260>
     c74:	01000737          	lui	a4,0x1000
     c78:	01800693          	li	a3,24
     c7c:	00e67463          	bgeu	a2,a4,c84 <__divdi3+0x4c>
     c80:	01000693          	li	a3,16
     c84:	00d65e33          	srl	t3,a2,a3
     c88:	00001717          	auipc	a4,0x1
     c8c:	c1c70713          	addi	a4,a4,-996 # 18a4 <__clz_tab>
     c90:	01c70733          	add	a4,a4,t3
     c94:	00074703          	lbu	a4,0(a4)
     c98:	02000e13          	li	t3,32
     c9c:	00d70733          	add	a4,a4,a3
     ca0:	40ee06b3          	sub	a3,t3,a4
     ca4:	00ee0c63          	beq	t3,a4,cbc <__divdi3+0x84>
     ca8:	00d59333          	sll	t1,a1,a3
     cac:	00e55733          	srl	a4,a0,a4
     cb0:	00676333          	or	t1,a4,t1
     cb4:	00d618b3          	sll	a7,a2,a3
     cb8:	00d517b3          	sll	a5,a0,a3
     cbc:	0108d613          	srli	a2,a7,0x10
     cc0:	02c35533          	divu	a0,t1,a2
     cc4:	01089693          	slli	a3,a7,0x10
     cc8:	0106d693          	srli	a3,a3,0x10
     ccc:	0107d713          	srli	a4,a5,0x10
     cd0:	02c37333          	remu	t1,t1,a2
     cd4:	02a685b3          	mul	a1,a3,a0
     cd8:	01031313          	slli	t1,t1,0x10
     cdc:	00676733          	or	a4,a4,t1
     ce0:	00b77c63          	bgeu	a4,a1,cf8 <__divdi3+0xc0>
     ce4:	00e88733          	add	a4,a7,a4
     ce8:	fff50313          	addi	t1,a0,-1
     cec:	01176463          	bltu	a4,a7,cf4 <__divdi3+0xbc>
     cf0:	42b76463          	bltu	a4,a1,1118 <__divdi3+0x4e0>
     cf4:	00030513          	mv	a0,t1
     cf8:	40b70733          	sub	a4,a4,a1
     cfc:	02c755b3          	divu	a1,a4,a2
     d00:	01079793          	slli	a5,a5,0x10
     d04:	0107d793          	srli	a5,a5,0x10
     d08:	02c77733          	remu	a4,a4,a2
     d0c:	02b686b3          	mul	a3,a3,a1
     d10:	01071713          	slli	a4,a4,0x10
     d14:	00e7e7b3          	or	a5,a5,a4
     d18:	00d7fe63          	bgeu	a5,a3,d34 <__divdi3+0xfc>
     d1c:	00f887b3          	add	a5,a7,a5
     d20:	fff58713          	addi	a4,a1,-1
     d24:	0117e663          	bltu	a5,a7,d30 <__divdi3+0xf8>
     d28:	ffe58593          	addi	a1,a1,-2
     d2c:	00d7e463          	bltu	a5,a3,d34 <__divdi3+0xfc>
     d30:	00070593          	mv	a1,a4
     d34:	01051513          	slli	a0,a0,0x10
     d38:	00b56533          	or	a0,a0,a1
     d3c:	00000593          	li	a1,0
     d40:	00080a63          	beqz	a6,d54 <__divdi3+0x11c>
     d44:	00a037b3          	snez	a5,a0
     d48:	40b005b3          	neg	a1,a1
     d4c:	40f585b3          	sub	a1,a1,a5
     d50:	40a00533          	neg	a0,a0
     d54:	00008067          	ret
     d58:	02d5f463          	bgeu	a1,a3,d80 <__divdi3+0x148>
     d5c:	00000593          	li	a1,0
     d60:	00000513          	li	a0,0
     d64:	fddff06f          	j	d40 <__divdi3+0x108>
     d68:	00a037b3          	snez	a5,a0
     d6c:	40b005b3          	neg	a1,a1
     d70:	40f585b3          	sub	a1,a1,a5
     d74:	40a00533          	neg	a0,a0
     d78:	fff00813          	li	a6,-1
     d7c:	ec5ff06f          	j	c40 <__divdi3+0x8>
     d80:	000107b7          	lui	a5,0x10
     d84:	1ef6e863          	bltu	a3,a5,f74 <__divdi3+0x33c>
     d88:	01000737          	lui	a4,0x1000
     d8c:	01800793          	li	a5,24
     d90:	00e6f463          	bgeu	a3,a4,d98 <__divdi3+0x160>
     d94:	01000793          	li	a5,16
     d98:	00f6d8b3          	srl	a7,a3,a5
     d9c:	00001717          	auipc	a4,0x1
     da0:	b0870713          	addi	a4,a4,-1272 # 18a4 <__clz_tab>
     da4:	01170733          	add	a4,a4,a7
     da8:	00074703          	lbu	a4,0(a4)
     dac:	02000313          	li	t1,32
     db0:	00f70733          	add	a4,a4,a5
     db4:	40e308b3          	sub	a7,t1,a4
     db8:	1ee31663          	bne	t1,a4,fa4 <__divdi3+0x36c>
     dbc:	32b6e263          	bltu	a3,a1,10e0 <__divdi3+0x4a8>
     dc0:	00c53533          	sltu	a0,a0,a2
     dc4:	00153513          	seqz	a0,a0
     dc8:	00000593          	li	a1,0
     dcc:	f75ff06f          	j	d40 <__divdi3+0x108>
     dd0:	0c060c63          	beqz	a2,ea8 <__divdi3+0x270>
     dd4:	00010737          	lui	a4,0x10
     dd8:	2ee67a63          	bgeu	a2,a4,10cc <__divdi3+0x494>
     ddc:	10063693          	sltiu	a3,a2,256
     de0:	0016b693          	seqz	a3,a3
     de4:	00369693          	slli	a3,a3,0x3
     de8:	00d65333          	srl	t1,a2,a3
     dec:	00001717          	auipc	a4,0x1
     df0:	ab870713          	addi	a4,a4,-1352 # 18a4 <__clz_tab>
     df4:	00670733          	add	a4,a4,t1
     df8:	00074703          	lbu	a4,0(a4)
     dfc:	02000313          	li	t1,32
     e00:	00d70733          	add	a4,a4,a3
     e04:	40e30f33          	sub	t5,t1,a4
     e08:	0ce31463          	bne	t1,a4,ed0 <__divdi3+0x298>
     e0c:	40c58733          	sub	a4,a1,a2
     e10:	01065313          	srli	t1,a2,0x10
     e14:	01061613          	slli	a2,a2,0x10
     e18:	01065613          	srli	a2,a2,0x10
     e1c:	00100593          	li	a1,1
     e20:	02675533          	divu	a0,a4,t1
     e24:	0107d693          	srli	a3,a5,0x10
     e28:	02677733          	remu	a4,a4,t1
     e2c:	02c50e33          	mul	t3,a0,a2
     e30:	01071713          	slli	a4,a4,0x10
     e34:	00e6e733          	or	a4,a3,a4
     e38:	01c77c63          	bgeu	a4,t3,e50 <__divdi3+0x218>
     e3c:	00e88733          	add	a4,a7,a4
     e40:	fff50693          	addi	a3,a0,-1
     e44:	01176463          	bltu	a4,a7,e4c <__divdi3+0x214>
     e48:	2dc76263          	bltu	a4,t3,110c <__divdi3+0x4d4>
     e4c:	00068513          	mv	a0,a3
     e50:	41c70733          	sub	a4,a4,t3
     e54:	026756b3          	divu	a3,a4,t1
     e58:	01079793          	slli	a5,a5,0x10
     e5c:	0107d793          	srli	a5,a5,0x10
     e60:	02677733          	remu	a4,a4,t1
     e64:	02c68633          	mul	a2,a3,a2
     e68:	01071713          	slli	a4,a4,0x10
     e6c:	00e7e7b3          	or	a5,a5,a4
     e70:	00c7fe63          	bgeu	a5,a2,e8c <__divdi3+0x254>
     e74:	00f887b3          	add	a5,a7,a5
     e78:	fff68713          	addi	a4,a3,-1
     e7c:	0117e663          	bltu	a5,a7,e88 <__divdi3+0x250>
     e80:	ffe68693          	addi	a3,a3,-2
     e84:	00c7e463          	bltu	a5,a2,e8c <__divdi3+0x254>
     e88:	00070693          	mv	a3,a4
     e8c:	01051513          	slli	a0,a0,0x10
     e90:	00d56533          	or	a0,a0,a3
     e94:	eadff06f          	j	d40 <__divdi3+0x108>
     e98:	10063693          	sltiu	a3,a2,256
     e9c:	0016b693          	seqz	a3,a3
     ea0:	00369693          	slli	a3,a3,0x3
     ea4:	de1ff06f          	j	c84 <__divdi3+0x4c>
     ea8:	00000313          	li	t1,0
     eac:	00001717          	auipc	a4,0x1
     eb0:	9f870713          	addi	a4,a4,-1544 # 18a4 <__clz_tab>
     eb4:	00670733          	add	a4,a4,t1
     eb8:	00074703          	lbu	a4,0(a4)
     ebc:	00000693          	li	a3,0
     ec0:	02000313          	li	t1,32
     ec4:	00d70733          	add	a4,a4,a3
     ec8:	40e30f33          	sub	t5,t1,a4
     ecc:	f4e300e3          	beq	t1,a4,e0c <__divdi3+0x1d4>
     ed0:	01e618b3          	sll	a7,a2,t5
     ed4:	00e5de33          	srl	t3,a1,a4
     ed8:	0108d313          	srli	t1,a7,0x10
     edc:	026e5eb3          	divu	t4,t3,t1
     ee0:	01089613          	slli	a2,a7,0x10
     ee4:	01e595b3          	sll	a1,a1,t5
     ee8:	01065613          	srli	a2,a2,0x10
     eec:	00e55733          	srl	a4,a0,a4
     ef0:	00b76733          	or	a4,a4,a1
     ef4:	01075693          	srli	a3,a4,0x10
     ef8:	01e517b3          	sll	a5,a0,t5
     efc:	026e7e33          	remu	t3,t3,t1
     f00:	03d605b3          	mul	a1,a2,t4
     f04:	010e1e13          	slli	t3,t3,0x10
     f08:	01c6e6b3          	or	a3,a3,t3
     f0c:	00b6fe63          	bgeu	a3,a1,f28 <__divdi3+0x2f0>
     f10:	00d886b3          	add	a3,a7,a3
     f14:	fffe8513          	addi	a0,t4,-1
     f18:	1f16e263          	bltu	a3,a7,10fc <__divdi3+0x4c4>
     f1c:	1eb6f063          	bgeu	a3,a1,10fc <__divdi3+0x4c4>
     f20:	ffee8e93          	addi	t4,t4,-2
     f24:	011686b3          	add	a3,a3,a7
     f28:	40b686b3          	sub	a3,a3,a1
     f2c:	0266d533          	divu	a0,a3,t1
     f30:	01071713          	slli	a4,a4,0x10
     f34:	01075713          	srli	a4,a4,0x10
     f38:	0266f6b3          	remu	a3,a3,t1
     f3c:	02a60e33          	mul	t3,a2,a0
     f40:	01069693          	slli	a3,a3,0x10
     f44:	00d76733          	or	a4,a4,a3
     f48:	01c77e63          	bgeu	a4,t3,f64 <__divdi3+0x32c>
     f4c:	00e88733          	add	a4,a7,a4
     f50:	fff50693          	addi	a3,a0,-1
     f54:	19176c63          	bltu	a4,a7,10ec <__divdi3+0x4b4>
     f58:	19c77a63          	bgeu	a4,t3,10ec <__divdi3+0x4b4>
     f5c:	ffe50513          	addi	a0,a0,-2
     f60:	01170733          	add	a4,a4,a7
     f64:	010e9593          	slli	a1,t4,0x10
     f68:	00a5e5b3          	or	a1,a1,a0
     f6c:	41c70733          	sub	a4,a4,t3
     f70:	eb1ff06f          	j	e20 <__divdi3+0x1e8>
     f74:	1006b793          	sltiu	a5,a3,256
     f78:	0017b793          	seqz	a5,a5
     f7c:	00379793          	slli	a5,a5,0x3
     f80:	00f6d8b3          	srl	a7,a3,a5
     f84:	00001717          	auipc	a4,0x1
     f88:	92070713          	addi	a4,a4,-1760 # 18a4 <__clz_tab>
     f8c:	01170733          	add	a4,a4,a7
     f90:	00074703          	lbu	a4,0(a4)
     f94:	02000313          	li	t1,32
     f98:	00f70733          	add	a4,a4,a5
     f9c:	40e308b3          	sub	a7,t1,a4
     fa0:	e0e30ee3          	beq	t1,a4,dbc <__divdi3+0x184>
     fa4:	00e65eb3          	srl	t4,a2,a4
     fa8:	011696b3          	sll	a3,a3,a7
     fac:	00deeeb3          	or	t4,t4,a3
     fb0:	00e5d333          	srl	t1,a1,a4
     fb4:	010edf13          	srli	t5,t4,0x10
     fb8:	03e357b3          	divu	a5,t1,t5
     fbc:	010e9e13          	slli	t3,t4,0x10
     fc0:	011595b3          	sll	a1,a1,a7
     fc4:	010e5e13          	srli	t3,t3,0x10
     fc8:	00e55733          	srl	a4,a0,a4
     fcc:	00b76733          	or	a4,a4,a1
     fd0:	01075693          	srli	a3,a4,0x10
     fd4:	01161633          	sll	a2,a2,a7
     fd8:	03e37333          	remu	t1,t1,t5
     fdc:	02fe05b3          	mul	a1,t3,a5
     fe0:	01031313          	slli	t1,t1,0x10
     fe4:	0066e6b3          	or	a3,a3,t1
     fe8:	00b6fe63          	bgeu	a3,a1,1004 <__divdi3+0x3cc>
     fec:	00de86b3          	add	a3,t4,a3
     ff0:	fff78313          	addi	t1,a5,-1 # ffff <__neorv32_heap_size+0xdfff>
     ff4:	11d6e863          	bltu	a3,t4,1104 <__divdi3+0x4cc>
     ff8:	10b6f663          	bgeu	a3,a1,1104 <__divdi3+0x4cc>
     ffc:	ffe78793          	addi	a5,a5,-2
    1000:	01d686b3          	add	a3,a3,t4
    1004:	40b686b3          	sub	a3,a3,a1
    1008:	03e6d333          	divu	t1,a3,t5
    100c:	01071713          	slli	a4,a4,0x10
    1010:	01075713          	srli	a4,a4,0x10
    1014:	03e6f6b3          	remu	a3,a3,t5
    1018:	026e05b3          	mul	a1,t3,t1
    101c:	01069693          	slli	a3,a3,0x10
    1020:	00d76733          	or	a4,a4,a3
    1024:	00b77e63          	bgeu	a4,a1,1040 <__divdi3+0x408>
    1028:	00ee8733          	add	a4,t4,a4
    102c:	fff30693          	addi	a3,t1,-1
    1030:	0dd76263          	bltu	a4,t4,10f4 <__divdi3+0x4bc>
    1034:	0cb77063          	bgeu	a4,a1,10f4 <__divdi3+0x4bc>
    1038:	ffe30313          	addi	t1,t1,-2
    103c:	01d70733          	add	a4,a4,t4
    1040:	01079793          	slli	a5,a5,0x10
    1044:	01031693          	slli	a3,t1,0x10
    1048:	01061e13          	slli	t3,a2,0x10
    104c:	0067e7b3          	or	a5,a5,t1
    1050:	0106d693          	srli	a3,a3,0x10
    1054:	010e5e13          	srli	t3,t3,0x10
    1058:	0107d313          	srli	t1,a5,0x10
    105c:	01065613          	srli	a2,a2,0x10
    1060:	03c30eb3          	mul	t4,t1,t3
    1064:	40b70733          	sub	a4,a4,a1
    1068:	03c68e33          	mul	t3,a3,t3
    106c:	02c686b3          	mul	a3,a3,a2
    1070:	010e5593          	srli	a1,t3,0x10
    1074:	01d686b3          	add	a3,a3,t4
    1078:	00d586b3          	add	a3,a1,a3
    107c:	02c30333          	mul	t1,t1,a2
    1080:	01d6f663          	bgeu	a3,t4,108c <__divdi3+0x454>
    1084:	00010637          	lui	a2,0x10
    1088:	00c30333          	add	t1,t1,a2
    108c:	0106d613          	srli	a2,a3,0x10
    1090:	00660633          	add	a2,a2,t1
    1094:	02c76663          	bltu	a4,a2,10c0 <__divdi3+0x488>
    1098:	00c70863          	beq	a4,a2,10a8 <__divdi3+0x470>
    109c:	00078513          	mv	a0,a5
    10a0:	00000593          	li	a1,0
    10a4:	c9dff06f          	j	d40 <__divdi3+0x108>
    10a8:	010e1e13          	slli	t3,t3,0x10
    10ac:	010e5e13          	srli	t3,t3,0x10
    10b0:	01069693          	slli	a3,a3,0x10
    10b4:	01151533          	sll	a0,a0,a7
    10b8:	01c686b3          	add	a3,a3,t3
    10bc:	fed570e3          	bgeu	a0,a3,109c <__divdi3+0x464>
    10c0:	fff78513          	addi	a0,a5,-1
    10c4:	00000593          	li	a1,0
    10c8:	c79ff06f          	j	d40 <__divdi3+0x108>
    10cc:	01000737          	lui	a4,0x1000
    10d0:	04e67a63          	bgeu	a2,a4,1124 <__divdi3+0x4ec>
    10d4:	01065313          	srli	t1,a2,0x10
    10d8:	01000693          	li	a3,16
    10dc:	d11ff06f          	j	dec <__divdi3+0x1b4>
    10e0:	00000593          	li	a1,0
    10e4:	00100513          	li	a0,1
    10e8:	c59ff06f          	j	d40 <__divdi3+0x108>
    10ec:	00068513          	mv	a0,a3
    10f0:	e75ff06f          	j	f64 <__divdi3+0x32c>
    10f4:	00068313          	mv	t1,a3
    10f8:	f49ff06f          	j	1040 <__divdi3+0x408>
    10fc:	00050e93          	mv	t4,a0
    1100:	e29ff06f          	j	f28 <__divdi3+0x2f0>
    1104:	00030793          	mv	a5,t1
    1108:	efdff06f          	j	1004 <__divdi3+0x3cc>
    110c:	ffe50513          	addi	a0,a0,-2
    1110:	01170733          	add	a4,a4,a7
    1114:	d3dff06f          	j	e50 <__divdi3+0x218>
    1118:	ffe50513          	addi	a0,a0,-2
    111c:	01170733          	add	a4,a4,a7
    1120:	bd9ff06f          	j	cf8 <__divdi3+0xc0>
    1124:	01865313          	srli	t1,a2,0x18
    1128:	01800693          	li	a3,24
    112c:	cc1ff06f          	j	dec <__divdi3+0x1b4>

00001130 <__udivdi3>:
    1130:	00060813          	mv	a6,a2
    1134:	00050893          	mv	a7,a0
    1138:	00058713          	mv	a4,a1
    113c:	0e069063          	bnez	a3,121c <__udivdi3+0xec>
    1140:	12c5fe63          	bgeu	a1,a2,127c <__udivdi3+0x14c>
    1144:	000107b7          	lui	a5,0x10
    1148:	1ef66e63          	bltu	a2,a5,1344 <__udivdi3+0x214>
    114c:	010007b7          	lui	a5,0x1000
    1150:	01800693          	li	a3,24
    1154:	00f67463          	bgeu	a2,a5,115c <__udivdi3+0x2c>
    1158:	01000693          	li	a3,16
    115c:	00d65333          	srl	t1,a2,a3
    1160:	00000797          	auipc	a5,0x0
    1164:	74478793          	addi	a5,a5,1860 # 18a4 <__clz_tab>
    1168:	006787b3          	add	a5,a5,t1
    116c:	0007c783          	lbu	a5,0(a5)
    1170:	02000313          	li	t1,32
    1174:	00d787b3          	add	a5,a5,a3
    1178:	40f306b3          	sub	a3,t1,a5
    117c:	00f30c63          	beq	t1,a5,1194 <__udivdi3+0x64>
    1180:	00d59733          	sll	a4,a1,a3
    1184:	00f557b3          	srl	a5,a0,a5
    1188:	00e7e733          	or	a4,a5,a4
    118c:	00d61833          	sll	a6,a2,a3
    1190:	00d518b3          	sll	a7,a0,a3
    1194:	01085613          	srli	a2,a6,0x10
    1198:	02c75533          	divu	a0,a4,a2
    119c:	01081693          	slli	a3,a6,0x10
    11a0:	0106d693          	srli	a3,a3,0x10
    11a4:	0108d793          	srli	a5,a7,0x10
    11a8:	02c77733          	remu	a4,a4,a2
    11ac:	02a685b3          	mul	a1,a3,a0
    11b0:	01071713          	slli	a4,a4,0x10
    11b4:	00e7e7b3          	or	a5,a5,a4
    11b8:	00b7fc63          	bgeu	a5,a1,11d0 <__udivdi3+0xa0>
    11bc:	00f807b3          	add	a5,a6,a5
    11c0:	fff50713          	addi	a4,a0,-1
    11c4:	0107e463          	bltu	a5,a6,11cc <__udivdi3+0x9c>
    11c8:	3eb7ee63          	bltu	a5,a1,15c4 <__udivdi3+0x494>
    11cc:	00070513          	mv	a0,a4
    11d0:	40b787b3          	sub	a5,a5,a1
    11d4:	02c7d733          	divu	a4,a5,a2
    11d8:	01089893          	slli	a7,a7,0x10
    11dc:	0108d893          	srli	a7,a7,0x10
    11e0:	02c7f7b3          	remu	a5,a5,a2
    11e4:	02e686b3          	mul	a3,a3,a4
    11e8:	01079793          	slli	a5,a5,0x10
    11ec:	00f8e8b3          	or	a7,a7,a5
    11f0:	00d8fe63          	bgeu	a7,a3,120c <__udivdi3+0xdc>
    11f4:	011808b3          	add	a7,a6,a7
    11f8:	fff70793          	addi	a5,a4,-1 # ffffff <__neorv32_ram_size+0xfdffff>
    11fc:	0108e663          	bltu	a7,a6,1208 <__udivdi3+0xd8>
    1200:	ffe70713          	addi	a4,a4,-2
    1204:	00d8e463          	bltu	a7,a3,120c <__udivdi3+0xdc>
    1208:	00078713          	mv	a4,a5
    120c:	01051513          	slli	a0,a0,0x10
    1210:	00e56533          	or	a0,a0,a4
    1214:	00000593          	li	a1,0
    1218:	00008067          	ret
    121c:	00d5f863          	bgeu	a1,a3,122c <__udivdi3+0xfc>
    1220:	00000593          	li	a1,0
    1224:	00000513          	li	a0,0
    1228:	00008067          	ret
    122c:	000107b7          	lui	a5,0x10
    1230:	1ef6e863          	bltu	a3,a5,1420 <__udivdi3+0x2f0>
    1234:	01000737          	lui	a4,0x1000
    1238:	01800793          	li	a5,24
    123c:	00e6f463          	bgeu	a3,a4,1244 <__udivdi3+0x114>
    1240:	01000793          	li	a5,16
    1244:	00f6d833          	srl	a6,a3,a5
    1248:	00000717          	auipc	a4,0x0
    124c:	65c70713          	addi	a4,a4,1628 # 18a4 <__clz_tab>
    1250:	01070733          	add	a4,a4,a6
    1254:	00074703          	lbu	a4,0(a4)
    1258:	02000813          	li	a6,32
    125c:	00f70733          	add	a4,a4,a5
    1260:	40e808b3          	sub	a7,a6,a4
    1264:	1ee81663          	bne	a6,a4,1450 <__udivdi3+0x320>
    1268:	32b6e263          	bltu	a3,a1,158c <__udivdi3+0x45c>
    126c:	00c53533          	sltu	a0,a0,a2
    1270:	00153513          	seqz	a0,a0
    1274:	00000593          	li	a1,0
    1278:	00008067          	ret
    127c:	0c060c63          	beqz	a2,1354 <__udivdi3+0x224>
    1280:	000107b7          	lui	a5,0x10
    1284:	2ef67a63          	bgeu	a2,a5,1578 <__udivdi3+0x448>
    1288:	10063713          	sltiu	a4,a2,256
    128c:	00173713          	seqz	a4,a4
    1290:	00371713          	slli	a4,a4,0x3
    1294:	00e656b3          	srl	a3,a2,a4
    1298:	00000797          	auipc	a5,0x0
    129c:	60c78793          	addi	a5,a5,1548 # 18a4 <__clz_tab>
    12a0:	00d787b3          	add	a5,a5,a3
    12a4:	0007c783          	lbu	a5,0(a5)
    12a8:	02000693          	li	a3,32
    12ac:	00e787b3          	add	a5,a5,a4
    12b0:	40f68eb3          	sub	t4,a3,a5
    12b4:	0cf69463          	bne	a3,a5,137c <__udivdi3+0x24c>
    12b8:	40c587b3          	sub	a5,a1,a2
    12bc:	01065693          	srli	a3,a2,0x10
    12c0:	01061613          	slli	a2,a2,0x10
    12c4:	01065613          	srli	a2,a2,0x10
    12c8:	00100593          	li	a1,1
    12cc:	02d7d533          	divu	a0,a5,a3
    12d0:	0108d713          	srli	a4,a7,0x10
    12d4:	02d7f7b3          	remu	a5,a5,a3
    12d8:	02c50333          	mul	t1,a0,a2
    12dc:	01079793          	slli	a5,a5,0x10
    12e0:	00f767b3          	or	a5,a4,a5
    12e4:	0067fc63          	bgeu	a5,t1,12fc <__udivdi3+0x1cc>
    12e8:	00f807b3          	add	a5,a6,a5
    12ec:	fff50713          	addi	a4,a0,-1
    12f0:	0107e463          	bltu	a5,a6,12f8 <__udivdi3+0x1c8>
    12f4:	2c67e263          	bltu	a5,t1,15b8 <__udivdi3+0x488>
    12f8:	00070513          	mv	a0,a4
    12fc:	406787b3          	sub	a5,a5,t1
    1300:	02d7d733          	divu	a4,a5,a3
    1304:	01089893          	slli	a7,a7,0x10
    1308:	0108d893          	srli	a7,a7,0x10
    130c:	02d7f7b3          	remu	a5,a5,a3
    1310:	02c70633          	mul	a2,a4,a2
    1314:	01079793          	slli	a5,a5,0x10
    1318:	00f8e8b3          	or	a7,a7,a5
    131c:	00c8fe63          	bgeu	a7,a2,1338 <__udivdi3+0x208>
    1320:	011808b3          	add	a7,a6,a7
    1324:	fff70793          	addi	a5,a4,-1
    1328:	0108e663          	bltu	a7,a6,1334 <__udivdi3+0x204>
    132c:	ffe70713          	addi	a4,a4,-2
    1330:	00c8e463          	bltu	a7,a2,1338 <__udivdi3+0x208>
    1334:	00078713          	mv	a4,a5
    1338:	01051513          	slli	a0,a0,0x10
    133c:	00e56533          	or	a0,a0,a4
    1340:	00008067          	ret
    1344:	10063693          	sltiu	a3,a2,256
    1348:	0016b693          	seqz	a3,a3
    134c:	00369693          	slli	a3,a3,0x3
    1350:	e0dff06f          	j	115c <__udivdi3+0x2c>
    1354:	00000693          	li	a3,0
    1358:	00000797          	auipc	a5,0x0
    135c:	54c78793          	addi	a5,a5,1356 # 18a4 <__clz_tab>
    1360:	00d787b3          	add	a5,a5,a3
    1364:	0007c783          	lbu	a5,0(a5)
    1368:	00000713          	li	a4,0
    136c:	02000693          	li	a3,32
    1370:	00e787b3          	add	a5,a5,a4
    1374:	40f68eb3          	sub	t4,a3,a5
    1378:	f4f680e3          	beq	a3,a5,12b8 <__udivdi3+0x188>
    137c:	01d61833          	sll	a6,a2,t4
    1380:	00f5d333          	srl	t1,a1,a5
    1384:	01085693          	srli	a3,a6,0x10
    1388:	02d35e33          	divu	t3,t1,a3
    138c:	01081613          	slli	a2,a6,0x10
    1390:	01d595b3          	sll	a1,a1,t4
    1394:	01065613          	srli	a2,a2,0x10
    1398:	00f557b3          	srl	a5,a0,a5
    139c:	00b7e7b3          	or	a5,a5,a1
    13a0:	0107d713          	srli	a4,a5,0x10
    13a4:	01d518b3          	sll	a7,a0,t4
    13a8:	02d37333          	remu	t1,t1,a3
    13ac:	03c605b3          	mul	a1,a2,t3
    13b0:	01031313          	slli	t1,t1,0x10
    13b4:	00676733          	or	a4,a4,t1
    13b8:	00b77e63          	bgeu	a4,a1,13d4 <__udivdi3+0x2a4>
    13bc:	00e80733          	add	a4,a6,a4
    13c0:	fffe0513          	addi	a0,t3,-1
    13c4:	1f076263          	bltu	a4,a6,15a8 <__udivdi3+0x478>
    13c8:	1eb77063          	bgeu	a4,a1,15a8 <__udivdi3+0x478>
    13cc:	ffee0e13          	addi	t3,t3,-2
    13d0:	01070733          	add	a4,a4,a6
    13d4:	40b70733          	sub	a4,a4,a1
    13d8:	02d75533          	divu	a0,a4,a3
    13dc:	01079793          	slli	a5,a5,0x10
    13e0:	0107d793          	srli	a5,a5,0x10
    13e4:	02d77733          	remu	a4,a4,a3
    13e8:	02a60333          	mul	t1,a2,a0
    13ec:	01071713          	slli	a4,a4,0x10
    13f0:	00e7e7b3          	or	a5,a5,a4
    13f4:	0067fe63          	bgeu	a5,t1,1410 <__udivdi3+0x2e0>
    13f8:	00f807b3          	add	a5,a6,a5
    13fc:	fff50713          	addi	a4,a0,-1
    1400:	1907ec63          	bltu	a5,a6,1598 <__udivdi3+0x468>
    1404:	1867fa63          	bgeu	a5,t1,1598 <__udivdi3+0x468>
    1408:	ffe50513          	addi	a0,a0,-2
    140c:	010787b3          	add	a5,a5,a6
    1410:	010e1593          	slli	a1,t3,0x10
    1414:	00a5e5b3          	or	a1,a1,a0
    1418:	406787b3          	sub	a5,a5,t1
    141c:	eb1ff06f          	j	12cc <__udivdi3+0x19c>
    1420:	1006b793          	sltiu	a5,a3,256
    1424:	0017b793          	seqz	a5,a5
    1428:	00379793          	slli	a5,a5,0x3
    142c:	00f6d833          	srl	a6,a3,a5
    1430:	00000717          	auipc	a4,0x0
    1434:	47470713          	addi	a4,a4,1140 # 18a4 <__clz_tab>
    1438:	01070733          	add	a4,a4,a6
    143c:	00074703          	lbu	a4,0(a4)
    1440:	02000813          	li	a6,32
    1444:	00f70733          	add	a4,a4,a5
    1448:	40e808b3          	sub	a7,a6,a4
    144c:	e0e80ee3          	beq	a6,a4,1268 <__udivdi3+0x138>
    1450:	00e65e33          	srl	t3,a2,a4
    1454:	011696b3          	sll	a3,a3,a7
    1458:	00de6e33          	or	t3,t3,a3
    145c:	00e5d833          	srl	a6,a1,a4
    1460:	010e5e93          	srli	t4,t3,0x10
    1464:	03d857b3          	divu	a5,a6,t4
    1468:	010e1313          	slli	t1,t3,0x10
    146c:	011595b3          	sll	a1,a1,a7
    1470:	01035313          	srli	t1,t1,0x10
    1474:	00e55733          	srl	a4,a0,a4
    1478:	00b76733          	or	a4,a4,a1
    147c:	01075693          	srli	a3,a4,0x10
    1480:	01161633          	sll	a2,a2,a7
    1484:	03d87833          	remu	a6,a6,t4
    1488:	02f305b3          	mul	a1,t1,a5
    148c:	01081813          	slli	a6,a6,0x10
    1490:	0106e6b3          	or	a3,a3,a6
    1494:	00b6fe63          	bgeu	a3,a1,14b0 <__udivdi3+0x380>
    1498:	00de06b3          	add	a3,t3,a3
    149c:	fff78813          	addi	a6,a5,-1
    14a0:	11c6e863          	bltu	a3,t3,15b0 <__udivdi3+0x480>
    14a4:	10b6f663          	bgeu	a3,a1,15b0 <__udivdi3+0x480>
    14a8:	ffe78793          	addi	a5,a5,-2
    14ac:	01c686b3          	add	a3,a3,t3
    14b0:	40b686b3          	sub	a3,a3,a1
    14b4:	03d6d833          	divu	a6,a3,t4
    14b8:	01071713          	slli	a4,a4,0x10
    14bc:	01075713          	srli	a4,a4,0x10
    14c0:	03d6f6b3          	remu	a3,a3,t4
    14c4:	030305b3          	mul	a1,t1,a6
    14c8:	01069693          	slli	a3,a3,0x10
    14cc:	00d76733          	or	a4,a4,a3
    14d0:	00b77e63          	bgeu	a4,a1,14ec <__udivdi3+0x3bc>
    14d4:	00ee0733          	add	a4,t3,a4
    14d8:	fff80693          	addi	a3,a6,-1
    14dc:	0dc76263          	bltu	a4,t3,15a0 <__udivdi3+0x470>
    14e0:	0cb77063          	bgeu	a4,a1,15a0 <__udivdi3+0x470>
    14e4:	ffe80813          	addi	a6,a6,-2
    14e8:	01c70733          	add	a4,a4,t3
    14ec:	01079793          	slli	a5,a5,0x10
    14f0:	01081693          	slli	a3,a6,0x10
    14f4:	01061313          	slli	t1,a2,0x10
    14f8:	0107e7b3          	or	a5,a5,a6
    14fc:	0106d693          	srli	a3,a3,0x10
    1500:	01035313          	srli	t1,t1,0x10
    1504:	0107d813          	srli	a6,a5,0x10
    1508:	01065613          	srli	a2,a2,0x10
    150c:	02680e33          	mul	t3,a6,t1
    1510:	40b70733          	sub	a4,a4,a1
    1514:	02668333          	mul	t1,a3,t1
    1518:	02c686b3          	mul	a3,a3,a2
    151c:	01035593          	srli	a1,t1,0x10
    1520:	01c686b3          	add	a3,a3,t3
    1524:	00d586b3          	add	a3,a1,a3
    1528:	02c80833          	mul	a6,a6,a2
    152c:	01c6f663          	bgeu	a3,t3,1538 <__udivdi3+0x408>
    1530:	00010637          	lui	a2,0x10
    1534:	00c80833          	add	a6,a6,a2
    1538:	0106d613          	srli	a2,a3,0x10
    153c:	01060633          	add	a2,a2,a6
    1540:	02c76663          	bltu	a4,a2,156c <__udivdi3+0x43c>
    1544:	00c70863          	beq	a4,a2,1554 <__udivdi3+0x424>
    1548:	00078513          	mv	a0,a5
    154c:	00000593          	li	a1,0
    1550:	00008067          	ret
    1554:	01031313          	slli	t1,t1,0x10
    1558:	01035313          	srli	t1,t1,0x10
    155c:	01069693          	slli	a3,a3,0x10
    1560:	01151533          	sll	a0,a0,a7
    1564:	006686b3          	add	a3,a3,t1
    1568:	fed570e3          	bgeu	a0,a3,1548 <__udivdi3+0x418>
    156c:	fff78513          	addi	a0,a5,-1
    1570:	00000593          	li	a1,0
    1574:	00008067          	ret
    1578:	010007b7          	lui	a5,0x1000
    157c:	04f67a63          	bgeu	a2,a5,15d0 <__udivdi3+0x4a0>
    1580:	01065693          	srli	a3,a2,0x10
    1584:	01000713          	li	a4,16
    1588:	d11ff06f          	j	1298 <__udivdi3+0x168>
    158c:	00000593          	li	a1,0
    1590:	00100513          	li	a0,1
    1594:	00008067          	ret
    1598:	00070513          	mv	a0,a4
    159c:	e75ff06f          	j	1410 <__udivdi3+0x2e0>
    15a0:	00068813          	mv	a6,a3
    15a4:	f49ff06f          	j	14ec <__udivdi3+0x3bc>
    15a8:	00050e13          	mv	t3,a0
    15ac:	e29ff06f          	j	13d4 <__udivdi3+0x2a4>
    15b0:	00080793          	mv	a5,a6
    15b4:	efdff06f          	j	14b0 <__udivdi3+0x380>
    15b8:	ffe50513          	addi	a0,a0,-2
    15bc:	010787b3          	add	a5,a5,a6
    15c0:	d3dff06f          	j	12fc <__udivdi3+0x1cc>
    15c4:	ffe50513          	addi	a0,a0,-2
    15c8:	010787b3          	add	a5,a5,a6
    15cc:	c05ff06f          	j	11d0 <__udivdi3+0xa0>
    15d0:	01865693          	srli	a3,a2,0x18
    15d4:	01800713          	li	a4,24
    15d8:	cc1ff06f          	j	1298 <__udivdi3+0x168>
