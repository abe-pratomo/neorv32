
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
      1c:	80028293          	addi	t0,t0,-2048 # 1800 <__crt0_copy_data_src_begin+0x1f0>
      20:	30029073          	csrw	mstatus,t0
      24:	00000317          	auipc	t1,0x0
      28:	19430313          	addi	t1,t1,404 # 1b8 <__crt0_panic>
      2c:	30531073          	csrw	mtvec,t1
      30:	30401073          	csrw	mie,zero
      34:	00001397          	auipc	t2,0x1
      38:	5dc38393          	addi	t2,t2,1500 # 1610 <__crt0_copy_data_src_begin>
      3c:	80000417          	auipc	s0,0x80000
      40:	fc440413          	addi	s0,s0,-60 # 80000000 <__crt0_bss_end>
      44:	80000497          	auipc	s1,0x80000
      48:	fbc48493          	addi	s1,s1,-68 # 80000000 <__crt0_bss_end>
      4c:	80000517          	auipc	a0,0x80000
      50:	fb450513          	addi	a0,a0,-76 # 80000000 <__crt0_bss_end>
      54:	80000597          	auipc	a1,0x80000
      58:	fac58593          	addi	a1,a1,-84 # 80000000 <__crt0_bss_end>
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
     124:	f1040413          	addi	s0,s0,-240 # 1030 <__fini_array_end>
  la    x9, __init_array_end
     128:	00001497          	auipc	s1,0x1
     12c:	f0848493          	addi	s1,s1,-248 # 1030 <__fini_array_end>

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
     148:	07c60613          	addi	a2,a2,124 # 1c0 <main>

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
     184:	eb040413          	addi	s0,s0,-336 # 1030 <__fini_array_end>
  la    x9, __fini_array_end
     188:	00001497          	auipc	s1,0x1
     18c:	ea848493          	addi	s1,s1,-344 # 1030 <__fini_array_end>

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

000001c0 <main>:
#define Q16_TO_FRAC(x) ((int32_t)((((x) & 0xFFFF) * 10000) >> 16))

int main(void) {

    // UART init
    neorv32_uart0_setup(BAUD_RATE, 0);
     1c0:	000055b7          	lui	a1,0x5
int main(void) {
     1c4:	fb010113          	addi	sp,sp,-80
    neorv32_uart0_setup(BAUD_RATE, 0);
     1c8:	00000613          	li	a2,0
     1cc:	b0058593          	addi	a1,a1,-1280 # 4b00 <__neorv32_heap_size+0x2b00>
     1d0:	fff50537          	lui	a0,0xfff50
int main(void) {
     1d4:	04112623          	sw	ra,76(sp)
     1d8:	03812423          	sw	s8,40(sp)
     1dc:	04812423          	sw	s0,72(sp)
     1e0:	04912223          	sw	s1,68(sp)
     1e4:	05212023          	sw	s2,64(sp)
     1e8:	03312e23          	sw	s3,60(sp)
     1ec:	03412c23          	sw	s4,56(sp)
     1f0:	03512a23          	sw	s5,52(sp)
     1f4:	03612823          	sw	s6,48(sp)
     1f8:	03712623          	sw	s7,44(sp)
     1fc:	03912223          	sw	s9,36(sp)
     200:	03a12023          	sw	s10,32(sp)
    neorv32_uart0_setup(BAUD_RATE, 0);
     204:	079000ef          	jal	a7c <neorv32_uart_setup>
    neorv32_uart0_printf("ANNX Functionality Check\n");
     208:	000015b7          	lui	a1,0x1
     20c:	03058593          	addi	a1,a1,48 # 1030 <__fini_array_end>
     210:	fff50537          	lui	a0,0xfff50
     214:	355000ef          	jal	d68 <neorv32_uart_printf>
    neorv32_uart0_printf("========================\n\n");
     218:	000015b7          	lui	a1,0x1
     21c:	04c58593          	addi	a1,a1,76 # 104c <__fini_array_end+0x1c>
     220:	fff50537          	lui	a0,0xfff50
     224:	345000ef          	jal	d68 <neorv32_uart_printf>

    // -------------------------------------------------------------------------
    // Test data in local arrays (Q16.16 fixed-point)
    // -------------------------------------------------------------------------
    int32_t mem_a[] = {
     228:	000015b7          	lui	a1,0x1
     22c:	02000613          	li	a2,32
     230:	4ec58593          	addi	a1,a1,1260 # 14ec <__fini_array_end+0x4bc>
     234:	00010513          	mv	a0,sp
     238:	445000ef          	jal	e7c <memcpy>
    int32_t result;

    // -------------------------------------------------------------------------
    // LWA test: result = mem_a[i] + mem_b[i]
    // -------------------------------------------------------------------------
    neorv32_uart0_printf("=== LWA Test: mem_a[i] + mem_b[i] ===\n");
     23c:	000015b7          	lui	a1,0x1
     240:	06858593          	addi	a1,a1,104 # 1068 <__fini_array_end+0x38>
     244:	fff50537          	lui	a0,0xfff50
     248:	321000ef          	jal	d68 <neorv32_uart_printf>

  register uint32_t __rd;
  register uint32_t __rs1 = rs1;
  register uint32_t __rs2 = rs2;

  asm volatile (".insn r %3, %4, %5, %0, %1, %2" : "=r"(__rd) : "r"(__rs1), "r"(__rs2), "i"(opcode), "i"(funct3), "i"(funct7));
     24c:	00070c37          	lui	s8,0x70
     250:	0181080b          	.insn	4, 0x0181080b

    result = annx_lwa((uint32_t)mem_a, mem_b[0], 0);
    neorv32_uart0_printf("[0]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
     254:	00012603          	lw	a2,0(sp)
     258:	01081893          	slli	a7,a6,0x10
     25c:	00002437          	lui	s0,0x2
     260:	01061693          	slli	a3,a2,0x10
     264:	71040413          	addi	s0,s0,1808 # 2710 <__neorv32_heap_size+0x710>
     268:	0108d893          	srli	a7,a7,0x10
     26c:	0106d693          	srli	a3,a3,0x10
     270:	028888b3          	mul	a7,a7,s0
     274:	000015b7          	lui	a1,0x1
     278:	41085813          	srai	a6,a6,0x10
     27c:	00000793          	li	a5,0
     280:	00700713          	li	a4,7
     284:	41065613          	srai	a2,a2,0x10
     288:	09058593          	addi	a1,a1,144 # 1090 <__fini_array_end+0x60>
     28c:	fff50537          	lui	a0,0xfff50
     290:	00170bb7          	lui	s7,0x170
     294:	028686b3          	mul	a3,a3,s0
     298:	0108d893          	srli	a7,a7,0x10
     29c:	0106d693          	srli	a3,a3,0x10
     2a0:	2c9000ef          	jal	d68 <neorv32_uart_printf>
     2a4:	0371080b          	.insn	4, 0x0371080b
        Q16_TO_INT(mem_a[0]), Q16_TO_FRAC(mem_a[0]),
        Q16_TO_INT(mem_b[0]), Q16_TO_FRAC(mem_b[0]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwa((uint32_t)mem_a, mem_b[1], 1);
    neorv32_uart0_printf("[1]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
     2a8:	00412603          	lw	a2,4(sp)
     2ac:	01081893          	slli	a7,a6,0x10
     2b0:	0108d893          	srli	a7,a7,0x10
     2b4:	01061693          	slli	a3,a2,0x10
     2b8:	0106d693          	srli	a3,a3,0x10
     2bc:	028888b3          	mul	a7,a7,s0
     2c0:	000015b7          	lui	a1,0x1
     2c4:	41085813          	srai	a6,a6,0x10
     2c8:	00000793          	li	a5,0
     2cc:	01700713          	li	a4,23
     2d0:	41065613          	srai	a2,a2,0x10
     2d4:	0b858593          	addi	a1,a1,184 # 10b8 <__fini_array_end+0x88>
     2d8:	fff50537          	lui	a0,0xfff50
     2dc:	ffc40b37          	lui	s6,0xffc40
     2e0:	028686b3          	mul	a3,a3,s0
     2e4:	0108d893          	srli	a7,a7,0x10
     2e8:	0106d693          	srli	a3,a3,0x10
     2ec:	27d000ef          	jal	d68 <neorv32_uart_printf>
     2f0:	0561080b          	.insn	4, 0x0561080b
        Q16_TO_INT(mem_a[1]), Q16_TO_FRAC(mem_a[1]),
        Q16_TO_INT(mem_b[1]), Q16_TO_FRAC(mem_b[1]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwa((uint32_t)mem_a, mem_b[2], 2);
    neorv32_uart0_printf("[2]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
     2f4:	00812603          	lw	a2,8(sp)
     2f8:	01081893          	slli	a7,a6,0x10
     2fc:	0108d893          	srli	a7,a7,0x10
     300:	01061693          	slli	a3,a2,0x10
     304:	0106d693          	srli	a3,a3,0x10
     308:	028888b3          	mul	a7,a7,s0
     30c:	000015b7          	lui	a1,0x1
     310:	41085813          	srai	a6,a6,0x10
     314:	00000793          	li	a5,0
     318:	fc400713          	li	a4,-60
     31c:	41065613          	srai	a2,a2,0x10
     320:	0e058593          	addi	a1,a1,224 # 10e0 <__fini_array_end+0xb0>
     324:	fff50537          	lui	a0,0xfff50
     328:	00630ab7          	lui	s5,0x630
     32c:	028686b3          	mul	a3,a3,s0
     330:	0108d893          	srli	a7,a7,0x10
     334:	0106d693          	srli	a3,a3,0x10
     338:	231000ef          	jal	d68 <neorv32_uart_printf>
     33c:	0751080b          	.insn	4, 0x0751080b
        Q16_TO_INT(mem_a[2]), Q16_TO_FRAC(mem_a[2]),
        Q16_TO_INT(mem_b[2]), Q16_TO_FRAC(mem_b[2]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwa((uint32_t)mem_a, mem_b[3], 3);
    neorv32_uart0_printf("[3]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
     340:	00c12603          	lw	a2,12(sp)
     344:	01081893          	slli	a7,a6,0x10
     348:	0108d893          	srli	a7,a7,0x10
     34c:	01061693          	slli	a3,a2,0x10
     350:	0106d693          	srli	a3,a3,0x10
     354:	028888b3          	mul	a7,a7,s0
     358:	000015b7          	lui	a1,0x1
     35c:	41085813          	srai	a6,a6,0x10
     360:	00000793          	li	a5,0
     364:	06300713          	li	a4,99
     368:	41065613          	srai	a2,a2,0x10
     36c:	10858593          	addi	a1,a1,264 # 1108 <__fini_array_end+0xd8>
     370:	fff50537          	lui	a0,0xfff50
     374:	ff6a0a37          	lui	s4,0xff6a0
     378:	028686b3          	mul	a3,a3,s0
     37c:	0108d893          	srli	a7,a7,0x10
     380:	0106d693          	srli	a3,a3,0x10
     384:	1e5000ef          	jal	d68 <neorv32_uart_printf>
     388:	0941080b          	.insn	4, 0x0941080b
        Q16_TO_INT(mem_a[3]), Q16_TO_FRAC(mem_a[3]),
        Q16_TO_INT(mem_b[3]), Q16_TO_FRAC(mem_b[3]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwa((uint32_t)mem_a, mem_b[4], 4);
    neorv32_uart0_printf("[4]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
     38c:	01012603          	lw	a2,16(sp)
     390:	01081893          	slli	a7,a6,0x10
     394:	0108d893          	srli	a7,a7,0x10
     398:	01061693          	slli	a3,a2,0x10
     39c:	0106d693          	srli	a3,a3,0x10
     3a0:	028888b3          	mul	a7,a7,s0
     3a4:	000015b7          	lui	a1,0x1
     3a8:	41085813          	srai	a6,a6,0x10
     3ac:	00000793          	li	a5,0
     3b0:	f6a00713          	li	a4,-150
     3b4:	41065613          	srai	a2,a2,0x10
     3b8:	13058593          	addi	a1,a1,304 # 1130 <__fini_array_end+0x100>
     3bc:	fff50537          	lui	a0,0xfff50
     3c0:	002209b7          	lui	s3,0x220
     3c4:	028686b3          	mul	a3,a3,s0
     3c8:	0108d893          	srli	a7,a7,0x10
     3cc:	0106d693          	srli	a3,a3,0x10
     3d0:	199000ef          	jal	d68 <neorv32_uart_printf>
     3d4:	0b31080b          	.insn	4, 0x0b31080b
        Q16_TO_INT(mem_a[4]), Q16_TO_FRAC(mem_a[4]),
        Q16_TO_INT(mem_b[4]), Q16_TO_FRAC(mem_b[4]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwa((uint32_t)mem_a, mem_b[5], 5);
    neorv32_uart0_printf("[5]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
     3d8:	01412603          	lw	a2,20(sp)
     3dc:	01081893          	slli	a7,a6,0x10
     3e0:	0108d893          	srli	a7,a7,0x10
     3e4:	01061693          	slli	a3,a2,0x10
     3e8:	0106d693          	srli	a3,a3,0x10
     3ec:	028888b3          	mul	a7,a7,s0
     3f0:	000015b7          	lui	a1,0x1
     3f4:	41085813          	srai	a6,a6,0x10
     3f8:	00000793          	li	a5,0
     3fc:	02200713          	li	a4,34
     400:	41065613          	srai	a2,a2,0x10
     404:	15858593          	addi	a1,a1,344 # 1158 <__fini_array_end+0x128>
     408:	fff50537          	lui	a0,0xfff50
     40c:	ffa80937          	lui	s2,0xffa80
     410:	028686b3          	mul	a3,a3,s0
     414:	0108d893          	srli	a7,a7,0x10
     418:	0106d693          	srli	a3,a3,0x10
     41c:	14d000ef          	jal	d68 <neorv32_uart_printf>
     420:	0d21080b          	.insn	4, 0x0d21080b
        Q16_TO_INT(mem_a[5]), Q16_TO_FRAC(mem_a[5]),
        Q16_TO_INT(mem_b[5]), Q16_TO_FRAC(mem_b[5]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwa((uint32_t)mem_a, mem_b[6], 6);
    neorv32_uart0_printf("[6]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
     424:	01812603          	lw	a2,24(sp)
     428:	01081893          	slli	a7,a6,0x10
     42c:	0108d893          	srli	a7,a7,0x10
     430:	01061693          	slli	a3,a2,0x10
     434:	0106d693          	srli	a3,a3,0x10
     438:	028888b3          	mul	a7,a7,s0
     43c:	000015b7          	lui	a1,0x1
     440:	41085813          	srai	a6,a6,0x10
     444:	00000793          	li	a5,0
     448:	fa800713          	li	a4,-88
     44c:	41065613          	srai	a2,a2,0x10
     450:	18058593          	addi	a1,a1,384 # 1180 <__fini_array_end+0x150>
     454:	fff50537          	lui	a0,0xfff50
     458:	00af0d37          	lui	s10,0xaf0
     45c:	028686b3          	mul	a3,a3,s0
     460:	0108d893          	srli	a7,a7,0x10
     464:	0106d693          	srli	a3,a3,0x10
     468:	101000ef          	jal	d68 <neorv32_uart_printf>
     46c:	0fa1080b          	.insn	4, 0x0fa1080b
        Q16_TO_INT(mem_a[6]), Q16_TO_FRAC(mem_a[6]),
        Q16_TO_INT(mem_b[6]), Q16_TO_FRAC(mem_b[6]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwa((uint32_t)mem_a, mem_b[7], 7);
    neorv32_uart0_printf("[7]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
     470:	01c12603          	lw	a2,28(sp)
     474:	01081893          	slli	a7,a6,0x10
     478:	0108d893          	srli	a7,a7,0x10
     47c:	01061693          	slli	a3,a2,0x10
     480:	0106d693          	srli	a3,a3,0x10
     484:	028888b3          	mul	a7,a7,s0
     488:	000015b7          	lui	a1,0x1
     48c:	41085813          	srai	a6,a6,0x10
     490:	00000793          	li	a5,0
     494:	0af00713          	li	a4,175
     498:	41065613          	srai	a2,a2,0x10
     49c:	1a858593          	addi	a1,a1,424 # 11a8 <__fini_array_end+0x178>
     4a0:	fff50537          	lui	a0,0xfff50
        Q16_TO_INT(mem_a[7]), Q16_TO_FRAC(mem_a[7]),
        Q16_TO_INT(mem_b[7]), Q16_TO_FRAC(mem_b[7]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    neorv32_uart0_printf("\n");
     4a4:	00001cb7          	lui	s9,0x1
    neorv32_uart0_printf("[7]  %d.%04d  +  %d.%04d  =  %d.%04d\n",
     4a8:	028686b3          	mul	a3,a3,s0
     4ac:	0108d893          	srli	a7,a7,0x10
     4b0:	0106d693          	srli	a3,a3,0x10
     4b4:	0b5000ef          	jal	d68 <neorv32_uart_printf>
    neorv32_uart0_printf("\n");
     4b8:	1d0c8593          	addi	a1,s9,464 # 11d0 <__fini_array_end+0x1a0>
     4bc:	fff50537          	lui	a0,0xfff50
     4c0:	0a9000ef          	jal	d68 <neorv32_uart_printf>

    // -------------------------------------------------------------------------
    // LWM test: result = (mem_a[i] * mem_b[i]) >> 16
    // -------------------------------------------------------------------------
    neorv32_uart0_printf("=== LWM Test: (mem_a[i] * mem_b[i]) >> 16 ===\n");
     4c4:	000015b7          	lui	a1,0x1
     4c8:	1d458593          	addi	a1,a1,468 # 11d4 <__fini_array_end+0x1a4>
     4cc:	fff50537          	lui	a0,0xfff50
     4d0:	099000ef          	jal	d68 <neorv32_uart_printf>
     4d4:	0181180b          	.insn	4, 0x0181180b

    result = annx_lwm((uint32_t)mem_a, mem_b[0], 0);
    neorv32_uart0_printf("[0]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
     4d8:	00012603          	lw	a2,0(sp)
     4dc:	01081893          	slli	a7,a6,0x10
     4e0:	0108d893          	srli	a7,a7,0x10
     4e4:	01061693          	slli	a3,a2,0x10
     4e8:	0106d693          	srli	a3,a3,0x10
     4ec:	028888b3          	mul	a7,a7,s0
     4f0:	000015b7          	lui	a1,0x1
     4f4:	41085813          	srai	a6,a6,0x10
     4f8:	00000793          	li	a5,0
     4fc:	00700713          	li	a4,7
     500:	41065613          	srai	a2,a2,0x10
     504:	20458593          	addi	a1,a1,516 # 1204 <__fini_array_end+0x1d4>
     508:	fff50537          	lui	a0,0xfff50
     50c:	028686b3          	mul	a3,a3,s0
     510:	0108d893          	srli	a7,a7,0x10
     514:	0106d693          	srli	a3,a3,0x10
     518:	051000ef          	jal	d68 <neorv32_uart_printf>
     51c:	0371180b          	.insn	4, 0x0371180b
        Q16_TO_INT(mem_a[0]), Q16_TO_FRAC(mem_a[0]),
        Q16_TO_INT(mem_b[0]), Q16_TO_FRAC(mem_b[0]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwm((uint32_t)mem_a, mem_b[1], 1);
    neorv32_uart0_printf("[1]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
     520:	00412603          	lw	a2,4(sp)
     524:	01081893          	slli	a7,a6,0x10
     528:	0108d893          	srli	a7,a7,0x10
     52c:	01061693          	slli	a3,a2,0x10
     530:	0106d693          	srli	a3,a3,0x10
     534:	028888b3          	mul	a7,a7,s0
     538:	000015b7          	lui	a1,0x1
     53c:	41085813          	srai	a6,a6,0x10
     540:	00000793          	li	a5,0
     544:	01700713          	li	a4,23
     548:	41065613          	srai	a2,a2,0x10
     54c:	22c58593          	addi	a1,a1,556 # 122c <__fini_array_end+0x1fc>
     550:	fff50537          	lui	a0,0xfff50
     554:	028686b3          	mul	a3,a3,s0
     558:	0108d893          	srli	a7,a7,0x10
     55c:	0106d693          	srli	a3,a3,0x10
     560:	009000ef          	jal	d68 <neorv32_uart_printf>
     564:	0561180b          	.insn	4, 0x0561180b
        Q16_TO_INT(mem_a[1]), Q16_TO_FRAC(mem_a[1]),
        Q16_TO_INT(mem_b[1]), Q16_TO_FRAC(mem_b[1]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwm((uint32_t)mem_a, mem_b[2], 2);
    neorv32_uart0_printf("[2]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
     568:	00812603          	lw	a2,8(sp)
     56c:	01081893          	slli	a7,a6,0x10
     570:	0108d893          	srli	a7,a7,0x10
     574:	01061693          	slli	a3,a2,0x10
     578:	0106d693          	srli	a3,a3,0x10
     57c:	028888b3          	mul	a7,a7,s0
     580:	000015b7          	lui	a1,0x1
     584:	41085813          	srai	a6,a6,0x10
     588:	00000793          	li	a5,0
     58c:	fc400713          	li	a4,-60
     590:	41065613          	srai	a2,a2,0x10
     594:	25458593          	addi	a1,a1,596 # 1254 <__fini_array_end+0x224>
     598:	fff50537          	lui	a0,0xfff50
     59c:	028686b3          	mul	a3,a3,s0
     5a0:	0108d893          	srli	a7,a7,0x10
     5a4:	0106d693          	srli	a3,a3,0x10
     5a8:	7c0000ef          	jal	d68 <neorv32_uart_printf>
     5ac:	0751180b          	.insn	4, 0x0751180b
        Q16_TO_INT(mem_a[2]), Q16_TO_FRAC(mem_a[2]),
        Q16_TO_INT(mem_b[2]), Q16_TO_FRAC(mem_b[2]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwm((uint32_t)mem_a, mem_b[3], 3);
    neorv32_uart0_printf("[3]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
     5b0:	00c12603          	lw	a2,12(sp)
     5b4:	01081893          	slli	a7,a6,0x10
     5b8:	0108d893          	srli	a7,a7,0x10
     5bc:	01061693          	slli	a3,a2,0x10
     5c0:	0106d693          	srli	a3,a3,0x10
     5c4:	028888b3          	mul	a7,a7,s0
     5c8:	000015b7          	lui	a1,0x1
     5cc:	41085813          	srai	a6,a6,0x10
     5d0:	00000793          	li	a5,0
     5d4:	06300713          	li	a4,99
     5d8:	41065613          	srai	a2,a2,0x10
     5dc:	27c58593          	addi	a1,a1,636 # 127c <__fini_array_end+0x24c>
     5e0:	fff50537          	lui	a0,0xfff50
     5e4:	028686b3          	mul	a3,a3,s0
     5e8:	0108d893          	srli	a7,a7,0x10
     5ec:	0106d693          	srli	a3,a3,0x10
     5f0:	778000ef          	jal	d68 <neorv32_uart_printf>
     5f4:	0941180b          	.insn	4, 0x0941180b
        Q16_TO_INT(mem_a[3]), Q16_TO_FRAC(mem_a[3]),
        Q16_TO_INT(mem_b[3]), Q16_TO_FRAC(mem_b[3]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwm((uint32_t)mem_a, mem_b[4], 4);
    neorv32_uart0_printf("[4]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
     5f8:	01012603          	lw	a2,16(sp)
     5fc:	01081893          	slli	a7,a6,0x10
     600:	0108d893          	srli	a7,a7,0x10
     604:	01061693          	slli	a3,a2,0x10
     608:	0106d693          	srli	a3,a3,0x10
     60c:	028888b3          	mul	a7,a7,s0
     610:	000015b7          	lui	a1,0x1
     614:	41085813          	srai	a6,a6,0x10
     618:	00000793          	li	a5,0
     61c:	f6a00713          	li	a4,-150
     620:	41065613          	srai	a2,a2,0x10
     624:	2a458593          	addi	a1,a1,676 # 12a4 <__fini_array_end+0x274>
     628:	fff50537          	lui	a0,0xfff50
     62c:	028686b3          	mul	a3,a3,s0
     630:	0108d893          	srli	a7,a7,0x10
     634:	0106d693          	srli	a3,a3,0x10
     638:	730000ef          	jal	d68 <neorv32_uart_printf>
     63c:	0b31180b          	.insn	4, 0x0b31180b
        Q16_TO_INT(mem_a[4]), Q16_TO_FRAC(mem_a[4]),
        Q16_TO_INT(mem_b[4]), Q16_TO_FRAC(mem_b[4]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwm((uint32_t)mem_a, mem_b[5], 5);
    neorv32_uart0_printf("[5]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
     640:	01412603          	lw	a2,20(sp)
     644:	01081893          	slli	a7,a6,0x10
     648:	0108d893          	srli	a7,a7,0x10
     64c:	01061693          	slli	a3,a2,0x10
     650:	0106d693          	srli	a3,a3,0x10
     654:	028888b3          	mul	a7,a7,s0
     658:	000015b7          	lui	a1,0x1
     65c:	41085813          	srai	a6,a6,0x10
     660:	00000793          	li	a5,0
     664:	02200713          	li	a4,34
     668:	41065613          	srai	a2,a2,0x10
     66c:	2cc58593          	addi	a1,a1,716 # 12cc <__fini_array_end+0x29c>
     670:	fff50537          	lui	a0,0xfff50
     674:	028686b3          	mul	a3,a3,s0
     678:	0108d893          	srli	a7,a7,0x10
     67c:	0106d693          	srli	a3,a3,0x10
     680:	6e8000ef          	jal	d68 <neorv32_uart_printf>
     684:	0d21180b          	.insn	4, 0x0d21180b
        Q16_TO_INT(mem_a[5]), Q16_TO_FRAC(mem_a[5]),
        Q16_TO_INT(mem_b[5]), Q16_TO_FRAC(mem_b[5]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwm((uint32_t)mem_a, mem_b[6], 6);
    neorv32_uart0_printf("[6]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
     688:	01812603          	lw	a2,24(sp)
     68c:	01081893          	slli	a7,a6,0x10
     690:	0108d893          	srli	a7,a7,0x10
     694:	01061693          	slli	a3,a2,0x10
     698:	0106d693          	srli	a3,a3,0x10
     69c:	028888b3          	mul	a7,a7,s0
     6a0:	000015b7          	lui	a1,0x1
     6a4:	41085813          	srai	a6,a6,0x10
     6a8:	00000793          	li	a5,0
     6ac:	fa800713          	li	a4,-88
     6b0:	41065613          	srai	a2,a2,0x10
     6b4:	2f458593          	addi	a1,a1,756 # 12f4 <__fini_array_end+0x2c4>
     6b8:	fff50537          	lui	a0,0xfff50
     6bc:	028686b3          	mul	a3,a3,s0
     6c0:	0108d893          	srli	a7,a7,0x10
     6c4:	0106d693          	srli	a3,a3,0x10
     6c8:	6a0000ef          	jal	d68 <neorv32_uart_printf>
     6cc:	0fa1180b          	.insn	4, 0x0fa1180b
        Q16_TO_INT(mem_a[6]), Q16_TO_FRAC(mem_a[6]),
        Q16_TO_INT(mem_b[6]), Q16_TO_FRAC(mem_b[6]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    result = annx_lwm((uint32_t)mem_a, mem_b[7], 7);
    neorv32_uart0_printf("[7]  %d.%04d  x  %d.%04d  =  %d.%04d\n",
     6d0:	01c12603          	lw	a2,28(sp)
     6d4:	01081893          	slli	a7,a6,0x10
     6d8:	0108d893          	srli	a7,a7,0x10
     6dc:	01061693          	slli	a3,a2,0x10
     6e0:	0106d693          	srli	a3,a3,0x10
     6e4:	028888b3          	mul	a7,a7,s0
     6e8:	000015b7          	lui	a1,0x1
     6ec:	41085813          	srai	a6,a6,0x10
     6f0:	00000793          	li	a5,0
     6f4:	0af00713          	li	a4,175
     6f8:	41065613          	srai	a2,a2,0x10
     6fc:	31c58593          	addi	a1,a1,796 # 131c <__fini_array_end+0x2ec>
     700:	fff50537          	lui	a0,0xfff50
     704:	00000493          	li	s1,0
     708:	028686b3          	mul	a3,a3,s0
     70c:	0108d893          	srli	a7,a7,0x10
     710:	0106d693          	srli	a3,a3,0x10
     714:	654000ef          	jal	d68 <neorv32_uart_printf>
        Q16_TO_INT(mem_a[7]), Q16_TO_FRAC(mem_a[7]),
        Q16_TO_INT(mem_b[7]), Q16_TO_FRAC(mem_b[7]),
        Q16_TO_INT(result),   Q16_TO_FRAC(result));

    neorv32_uart0_printf("\n");
     718:	1d0c8593          	addi	a1,s9,464
     71c:	fff50537          	lui	a0,0xfff50
     720:	648000ef          	jal	d68 <neorv32_uart_printf>

    // -------------------------------------------------------------------------
    // EXP test: result = exp_pwl(x)
    // -------------------------------------------------------------------------
    neorv32_uart0_printf("=== EXP Test: exp_pwl(x) ===\n");
     724:	000015b7          	lui	a1,0x1
     728:	34458593          	addi	a1,a1,836 # 1344 <__fini_array_end+0x314>
     72c:	fff50537          	lui	a0,0xfff50
     730:	638000ef          	jal	d68 <neorv32_uart_printf>
     734:	fff60637          	lui	a2,0xfff60
     738:	0096260b          	.insn	4, 0x0096260b

    result = annx_exp(TO_Q16(-10));
    neorv32_uart0_printf("exp(-10.0000)  =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));
     73c:	01061693          	slli	a3,a2,0x10
     740:	0106d693          	srli	a3,a3,0x10
     744:	028686b3          	mul	a3,a3,s0
     748:	000015b7          	lui	a1,0x1
     74c:	41065613          	srai	a2,a2,0x10
     750:	36458593          	addi	a1,a1,868 # 1364 <__fini_array_end+0x334>
     754:	fff50537          	lui	a0,0xfff50
     758:	0106d693          	srli	a3,a3,0x10
     75c:	60c000ef          	jal	d68 <neorv32_uart_printf>
     760:	fff80637          	lui	a2,0xfff80
     764:	0096260b          	.insn	4, 0x0096260b

    result = annx_exp(TO_Q16(-8));
    neorv32_uart0_printf("exp(-8.0000)   =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));
     768:	01061693          	slli	a3,a2,0x10
     76c:	0106d693          	srli	a3,a3,0x10
     770:	028686b3          	mul	a3,a3,s0
     774:	000015b7          	lui	a1,0x1
     778:	41065613          	srai	a2,a2,0x10
     77c:	38058593          	addi	a1,a1,896 # 1380 <__fini_array_end+0x350>
     780:	fff50537          	lui	a0,0xfff50
     784:	0106d693          	srli	a3,a3,0x10
     788:	5e0000ef          	jal	d68 <neorv32_uart_printf>
     78c:	fffa0637          	lui	a2,0xfffa0
     790:	0096260b          	.insn	4, 0x0096260b

    result = annx_exp(TO_Q16(-6));
    neorv32_uart0_printf("exp(-6.0000)   =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));
     794:	01061693          	slli	a3,a2,0x10
     798:	0106d693          	srli	a3,a3,0x10
     79c:	028686b3          	mul	a3,a3,s0
     7a0:	000015b7          	lui	a1,0x1
     7a4:	41065613          	srai	a2,a2,0x10
     7a8:	39c58593          	addi	a1,a1,924 # 139c <__fini_array_end+0x36c>
     7ac:	fff50537          	lui	a0,0xfff50
     7b0:	0106d693          	srli	a3,a3,0x10
     7b4:	5b4000ef          	jal	d68 <neorv32_uart_printf>
     7b8:	fffc0637          	lui	a2,0xfffc0
     7bc:	0096260b          	.insn	4, 0x0096260b

    result = annx_exp(TO_Q16(-4));
    neorv32_uart0_printf("exp(-4.0000)   =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));
     7c0:	01061693          	slli	a3,a2,0x10
     7c4:	0106d693          	srli	a3,a3,0x10
     7c8:	028686b3          	mul	a3,a3,s0
     7cc:	000015b7          	lui	a1,0x1
     7d0:	41065613          	srai	a2,a2,0x10
     7d4:	3b858593          	addi	a1,a1,952 # 13b8 <__fini_array_end+0x388>
     7d8:	fff50537          	lui	a0,0xfff50
     7dc:	0106d693          	srli	a3,a3,0x10
     7e0:	588000ef          	jal	d68 <neorv32_uart_printf>
     7e4:	fffe0637          	lui	a2,0xfffe0
     7e8:	0096260b          	.insn	4, 0x0096260b

    result = annx_exp(TO_Q16(-2));
    neorv32_uart0_printf("exp(-2.0000)   =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));
     7ec:	01061693          	slli	a3,a2,0x10
     7f0:	0106d693          	srli	a3,a3,0x10
     7f4:	028686b3          	mul	a3,a3,s0
     7f8:	000015b7          	lui	a1,0x1
     7fc:	41065613          	srai	a2,a2,0x10
     800:	3d458593          	addi	a1,a1,980 # 13d4 <__fini_array_end+0x3a4>
     804:	fff50537          	lui	a0,0xfff50
     808:	0106d693          	srli	a3,a3,0x10
     80c:	55c000ef          	jal	d68 <neorv32_uart_printf>
     810:	ffff0637          	lui	a2,0xffff0
     814:	0096260b          	.insn	4, 0x0096260b

    result = annx_exp(TO_Q16(-1));
    neorv32_uart0_printf("exp(-1.0000)   =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));
     818:	01061693          	slli	a3,a2,0x10
     81c:	0106d693          	srli	a3,a3,0x10
     820:	028686b3          	mul	a3,a3,s0
     824:	000015b7          	lui	a1,0x1
     828:	41065613          	srai	a2,a2,0x10
     82c:	3f058593          	addi	a1,a1,1008 # 13f0 <__fini_array_end+0x3c0>
     830:	fff50537          	lui	a0,0xfff50
     834:	0106d693          	srli	a3,a3,0x10
     838:	530000ef          	jal	d68 <neorv32_uart_printf>
     83c:	0094a60b          	.insn	4, 0x0094a60b

    result = annx_exp(TO_Q16(0));
    neorv32_uart0_printf("exp(0.0000)    =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));
     840:	01061693          	slli	a3,a2,0x10
     844:	0106d693          	srli	a3,a3,0x10
     848:	028686b3          	mul	a3,a3,s0
     84c:	000015b7          	lui	a1,0x1
     850:	41065613          	srai	a2,a2,0x10
     854:	40c58593          	addi	a1,a1,1036 # 140c <__fini_array_end+0x3dc>
     858:	fff50537          	lui	a0,0xfff50
     85c:	0106d693          	srli	a3,a3,0x10
     860:	508000ef          	jal	d68 <neorv32_uart_printf>
     864:	00010637          	lui	a2,0x10
     868:	0096260b          	.insn	4, 0x0096260b

    result = annx_exp(TO_Q16(1));
    neorv32_uart0_printf("exp(1.0000)    =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));
     86c:	01061693          	slli	a3,a2,0x10
     870:	0106d693          	srli	a3,a3,0x10
     874:	028686b3          	mul	a3,a3,s0
     878:	000015b7          	lui	a1,0x1
     87c:	41065613          	srai	a2,a2,0x10
     880:	42858593          	addi	a1,a1,1064 # 1428 <__fini_array_end+0x3f8>
     884:	fff50537          	lui	a0,0xfff50
     888:	0106d693          	srli	a3,a3,0x10
     88c:	4dc000ef          	jal	d68 <neorv32_uart_printf>
     890:	00020637          	lui	a2,0x20
     894:	0096260b          	.insn	4, 0x0096260b

    result = annx_exp(TO_Q16(2));
    neorv32_uart0_printf("exp(2.0000)    =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));
     898:	01061693          	slli	a3,a2,0x10
     89c:	0106d693          	srli	a3,a3,0x10
     8a0:	028686b3          	mul	a3,a3,s0
     8a4:	000015b7          	lui	a1,0x1
     8a8:	41065613          	srai	a2,a2,0x10
     8ac:	44458593          	addi	a1,a1,1092 # 1444 <__fini_array_end+0x414>
     8b0:	fff50537          	lui	a0,0xfff50
     8b4:	0106d693          	srli	a3,a3,0x10
     8b8:	4b0000ef          	jal	d68 <neorv32_uart_printf>
     8bc:	00040637          	lui	a2,0x40
     8c0:	0096260b          	.insn	4, 0x0096260b

    result = annx_exp(TO_Q16(4));
    neorv32_uart0_printf("exp(4.0000)    =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));
     8c4:	01061693          	slli	a3,a2,0x10
     8c8:	0106d693          	srli	a3,a3,0x10
     8cc:	028686b3          	mul	a3,a3,s0
     8d0:	000015b7          	lui	a1,0x1
     8d4:	41065613          	srai	a2,a2,0x10
     8d8:	46058593          	addi	a1,a1,1120 # 1460 <__fini_array_end+0x430>
     8dc:	fff50537          	lui	a0,0xfff50
     8e0:	0106d693          	srli	a3,a3,0x10
     8e4:	484000ef          	jal	d68 <neorv32_uart_printf>
     8e8:	00060637          	lui	a2,0x60
     8ec:	0096260b          	.insn	4, 0x0096260b

    result = annx_exp(TO_Q16(6));
    neorv32_uart0_printf("exp(6.0000)    =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));
     8f0:	01061693          	slli	a3,a2,0x10
     8f4:	0106d693          	srli	a3,a3,0x10
     8f8:	028686b3          	mul	a3,a3,s0
     8fc:	000015b7          	lui	a1,0x1
     900:	41065613          	srai	a2,a2,0x10
     904:	47c58593          	addi	a1,a1,1148 # 147c <__fini_array_end+0x44c>
     908:	fff50537          	lui	a0,0xfff50
     90c:	0106d693          	srli	a3,a3,0x10
     910:	458000ef          	jal	d68 <neorv32_uart_printf>
     914:	00080637          	lui	a2,0x80
     918:	0096260b          	.insn	4, 0x0096260b

    result = annx_exp(TO_Q16(8));
    neorv32_uart0_printf("exp(8.0000)    =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));
     91c:	01061693          	slli	a3,a2,0x10
     920:	0106d693          	srli	a3,a3,0x10
     924:	028686b3          	mul	a3,a3,s0
     928:	000015b7          	lui	a1,0x1
     92c:	41065613          	srai	a2,a2,0x10
     930:	49858593          	addi	a1,a1,1176 # 1498 <__fini_array_end+0x468>
     934:	fff50537          	lui	a0,0xfff50
     938:	0106d693          	srli	a3,a3,0x10
     93c:	42c000ef          	jal	d68 <neorv32_uart_printf>
     940:	000a0637          	lui	a2,0xa0
     944:	0096260b          	.insn	4, 0x0096260b

    result = annx_exp(TO_Q16(10));
    neorv32_uart0_printf("exp(10.0000)   =  %d.%04d\n", Q16_TO_INT(result), Q16_TO_FRAC(result));
     948:	01061693          	slli	a3,a2,0x10
     94c:	0106d693          	srli	a3,a3,0x10
     950:	028686b3          	mul	a3,a3,s0
     954:	000015b7          	lui	a1,0x1
     958:	41065613          	srai	a2,a2,0x10
     95c:	4b458593          	addi	a1,a1,1204 # 14b4 <__fini_array_end+0x484>
     960:	fff50537          	lui	a0,0xfff50
     964:	0106d693          	srli	a3,a3,0x10
     968:	400000ef          	jal	d68 <neorv32_uart_printf>

    neorv32_uart0_printf("\nDone.\n");
     96c:	000015b7          	lui	a1,0x1
     970:	fff50537          	lui	a0,0xfff50
     974:	4d058593          	addi	a1,a1,1232 # 14d0 <__fini_array_end+0x4a0>
     978:	3f0000ef          	jal	d68 <neorv32_uart_printf>

    return 0;
     97c:	04c12083          	lw	ra,76(sp)
     980:	04812403          	lw	s0,72(sp)
     984:	04412483          	lw	s1,68(sp)
     988:	04012903          	lw	s2,64(sp)
     98c:	03c12983          	lw	s3,60(sp)
     990:	03812a03          	lw	s4,56(sp)
     994:	03412a83          	lw	s5,52(sp)
     998:	03012b03          	lw	s6,48(sp)
     99c:	02c12b83          	lw	s7,44(sp)
     9a0:	02812c03          	lw	s8,40(sp)
     9a4:	02412c83          	lw	s9,36(sp)
     9a8:	02012d03          	lw	s10,32(sp)
     9ac:	00000513          	li	a0,0
     9b0:	05010113          	addi	sp,sp,80
     9b4:	00008067          	ret

000009b8 <neorv32_aux_itoa>:
 *
 * @param[in,out] buffer Pointer to array for the result string [33 chars].
 * @param[in] num Number to convert.
 * @param[in] base Base of number representation (2..16).
 **************************************************************************/
void neorv32_aux_itoa(char *buffer, uint32_t num, uint32_t base) {
     9b8:	fb010113          	addi	sp,sp,-80
     9bc:	05212023          	sw	s2,64(sp)
     9c0:	00058913          	mv	s2,a1

  const char digits[16] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
     9c4:	000015b7          	lui	a1,0x1
void neorv32_aux_itoa(char *buffer, uint32_t num, uint32_t base) {
     9c8:	04812423          	sw	s0,72(sp)
     9cc:	04912223          	sw	s1,68(sp)
  const char digits[16] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
     9d0:	4d858593          	addi	a1,a1,1240 # 14d8 <__fini_array_end+0x4a8>
void neorv32_aux_itoa(char *buffer, uint32_t num, uint32_t base) {
     9d4:	00060493          	mv	s1,a2
     9d8:	00050413          	mv	s0,a0
  const char digits[16] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
     9dc:	01000613          	li	a2,16
     9e0:	00c10513          	addi	a0,sp,12
void neorv32_aux_itoa(char *buffer, uint32_t num, uint32_t base) {
     9e4:	04112623          	sw	ra,76(sp)
  const char digits[16] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
     9e8:	494000ef          	jal	e7c <memcpy>
  char *tmp_ptr = 0;
  unsigned int i = 0;

  // prevent uninitialized stack bytes
  for (i=0; i<sizeof(tmp); i++) {
    tmp[i] = 0;
     9ec:	01c10693          	addi	a3,sp,28
     9f0:	02400613          	li	a2,36
     9f4:	00000593          	li	a1,0
     9f8:	00068513          	mv	a0,a3
     9fc:	3a4000ef          	jal	da0 <memset>
  }

  if ((base < 2) || (base > 16)) { // invalid base?
     a00:	ffe48613          	addi	a2,s1,-2
     a04:	00e00713          	li	a4,14
     a08:	02c77063          	bgeu	a4,a2,a28 <neorv32_aux_itoa+0x70>
      buffer++;
    }
  }

  // terminate result string
  *buffer = '\0';
     a0c:	00040023          	sb	zero,0(s0)
}
     a10:	04c12083          	lw	ra,76(sp)
     a14:	04812403          	lw	s0,72(sp)
     a18:	04412483          	lw	s1,68(sp)
     a1c:	04012903          	lw	s2,64(sp)
     a20:	05010113          	addi	sp,sp,80
     a24:	00008067          	ret
     a28:	00050693          	mv	a3,a0
     a2c:	03f10793          	addi	a5,sp,63
    *tmp_ptr = digits[num%base];
     a30:	02997733          	remu	a4,s2,s1
    tmp_ptr--;
     a34:	fff78793          	addi	a5,a5,-1
    *tmp_ptr = digits[num%base];
     a38:	04070713          	addi	a4,a4,64
     a3c:	00270733          	add	a4,a4,sp
     a40:	fcc74703          	lbu	a4,-52(a4)
     a44:	00e78023          	sb	a4,0(a5)
    num /= base;
     a48:	00090713          	mv	a4,s2
     a4c:	02995933          	divu	s2,s2,s1
  } while (num != 0);
     a50:	fe9770e3          	bgeu	a4,s1,a30 <neorv32_aux_itoa+0x78>
  for (i=0; i<sizeof(tmp); i++) {
     a54:	00000793          	li	a5,0
     a58:	02400613          	li	a2,36
    if (tmp[i] != '\0') {
     a5c:	00f68733          	add	a4,a3,a5
     a60:	00074703          	lbu	a4,0(a4)
     a64:	00070663          	beqz	a4,a70 <neorv32_aux_itoa+0xb8>
      *buffer = tmp[i];
     a68:	00e40023          	sb	a4,0(s0)
      buffer++;
     a6c:	00140413          	addi	s0,s0,1
  for (i=0; i<sizeof(tmp); i++) {
     a70:	00178793          	addi	a5,a5,1
     a74:	fec794e3          	bne	a5,a2,a5c <neorv32_aux_itoa+0xa4>
     a78:	f95ff06f          	j	a0c <neorv32_aux_itoa+0x54>

00000a7c <neorv32_uart_setup>:

  uint32_t prsc_sel = 0;
  uint32_t baud_div = 0;

  // reset
  UARTx->CTRL = 0;
     a7c:	00052023          	sw	zero,0(a0) # fff50000 <__crt0_stack_top+0x7ff30000>
/**********************************************************************//**
 * Get current processor clock frequency.
 * @return Clock frequency in Hz.
 **************************************************************************/
inline uint32_t __attribute__ ((always_inline)) neorv32_sysinfo_get_clk(void) {
  return NEORV32_SYSINFO->CLK;
     a80:	fffe07b7          	lui	a5,0xfffe0
     a84:	0007a783          	lw	a5,0(a5) # fffe0000 <__crt0_stack_top+0x7ffc0000>

  // raw clock prescaler
  uint32_t clock = neorv32_sysinfo_get_clk(); // system clock in Hz
#ifndef MAKE_BOOTLOADER // use div instructions / library functions
  baud_div = clock / (2*baudrate);
     a88:	00159593          	slli	a1,a1,0x1
  uint32_t prsc_sel = 0;
     a8c:	00000713          	li	a4,0
  baud_div = clock / (2*baudrate);
     a90:	02b7d7b3          	divu	a5,a5,a1
    baud_div++;
  }
#endif

  // find baud prescaler (10-bit wide))
  while (baud_div >= 0x3ffU) {
     a94:	3fe00593          	li	a1,1022
     a98:	02f5ec63          	bltu	a1,a5,ad0 <neorv32_uart_setup+0x54>
  }

  uint32_t tmp = 0;
  tmp |= (uint32_t)(1              & 1U)     << UART_CTRL_EN;
  tmp |= (uint32_t)(prsc_sel       & 3U)     << UART_CTRL_PRSC_LSB;
  tmp |= (uint32_t)((baud_div - 1) & 0x3ffU) << UART_CTRL_BAUD_LSB;
     a9c:	fff78793          	addi	a5,a5,-1
     aa0:	00679793          	slli	a5,a5,0x6
     aa4:	01079793          	slli	a5,a5,0x10
  tmp |= (uint32_t)(irq_mask       & (0xfu   << UART_CTRL_IRQ_RX_NEMPTY));
     aa8:	00f006b7          	lui	a3,0xf00
  tmp |= (uint32_t)((baud_div - 1) & 0x3ffU) << UART_CTRL_BAUD_LSB;
     aac:	0107d793          	srli	a5,a5,0x10
  tmp |= (uint32_t)(irq_mask       & (0xfu   << UART_CTRL_IRQ_RX_NEMPTY));
     ab0:	00d67633          	and	a2,a2,a3
  tmp |= (uint32_t)(prsc_sel       & 3U)     << UART_CTRL_PRSC_LSB;
     ab4:	00371713          	slli	a4,a4,0x3
  tmp |= (uint32_t)(irq_mask       & (0xfu   << UART_CTRL_IRQ_RX_NEMPTY));
     ab8:	00c7e7b3          	or	a5,a5,a2
  tmp |= (uint32_t)(prsc_sel       & 3U)     << UART_CTRL_PRSC_LSB;
     abc:	01877713          	andi	a4,a4,24
  tmp |= (uint32_t)(irq_mask       & (0xfu   << UART_CTRL_IRQ_RX_NEMPTY));
     ac0:	00e7e7b3          	or	a5,a5,a4
     ac4:	0017e793          	ori	a5,a5,1
  if (((uint32_t)UARTx) == NEORV32_UART1_BASE) {
    tmp |= 1U << UART_CTRL_SIM_MODE;
  }
#endif

  UARTx->CTRL = tmp;
     ac8:	00f52023          	sw	a5,0(a0)
}
     acc:	00008067          	ret
    if ((prsc_sel == 2) || (prsc_sel == 4))
     ad0:	ffe70693          	addi	a3,a4,-2
     ad4:	ffd6f693          	andi	a3,a3,-3
     ad8:	00069863          	bnez	a3,ae8 <neorv32_uart_setup+0x6c>
      baud_div >>= 3;
     adc:	0037d793          	srli	a5,a5,0x3
    prsc_sel++;
     ae0:	00170713          	addi	a4,a4,1
     ae4:	fb5ff06f          	j	a98 <neorv32_uart_setup+0x1c>
      baud_div >>= 1;
     ae8:	0017d793          	srli	a5,a5,0x1
     aec:	ff5ff06f          	j	ae0 <neorv32_uart_setup+0x64>

00000af0 <neorv32_uart_putc>:
 * @param[in,out] UARTx Hardware handle to UART register struct, #neorv32_uart_t.
 * @param[in] c Char to be send.
 **************************************************************************/
void neorv32_uart_putc(neorv32_uart_t *UARTx, char c) {

  while ((UARTx->CTRL & (1<<UART_CTRL_TX_NFULL)) == 0); // wait for free space in TX FIFO
     af0:	00052783          	lw	a5,0(a0)
     af4:	00c79713          	slli	a4,a5,0xc
     af8:	fe075ce3          	bgez	a4,af0 <neorv32_uart_putc>
void neorv32_uart_tx_put(neorv32_uart_t *UARTx, char c) {

#ifdef UART_SEMIHOSTING
  neorv32_semihosting_putc(c);
#else
  UARTx->DATA = (uint32_t)c << UART_DATA_RTX_LSB;
     afc:	00b52223          	sw	a1,4(a0)
}
     b00:	00008067          	ret

00000b04 <neorv32_uart_puts>:
 * @warning "/n" line breaks are automatically converted to "/r/n".
 *
 * @param[in,out] UARTx Hardware handle to UART register struct, #neorv32_uart_t.
 * @param[in] s Pointer to string.
 **************************************************************************/
void neorv32_uart_puts(neorv32_uart_t *UARTx, const char *s) {
     b04:	fe010113          	addi	sp,sp,-32
     b08:	00812c23          	sw	s0,24(sp)
     b0c:	00912a23          	sw	s1,20(sp)
     b10:	01312623          	sw	s3,12(sp)
     b14:	00112e23          	sw	ra,28(sp)
     b18:	01212823          	sw	s2,16(sp)
     b1c:	00050493          	mv	s1,a0
     b20:	00058413          	mv	s0,a1
#ifdef UART_SEMIHOSTING
  neorv32_semihosting_puts(s);
#else
  char c = 0;
  while ((c = *s++)) {
    if (c == '\n') {
     b24:	00a00993          	li	s3,10
  while ((c = *s++)) {
     b28:	00044903          	lbu	s2,0(s0)
     b2c:	00140413          	addi	s0,s0,1
     b30:	02091063          	bnez	s2,b50 <neorv32_uart_puts+0x4c>
      neorv32_uart_putc(UARTx, '\r');
    }
    neorv32_uart_putc(UARTx, c);
  }
#endif
}
     b34:	01c12083          	lw	ra,28(sp)
     b38:	01812403          	lw	s0,24(sp)
     b3c:	01412483          	lw	s1,20(sp)
     b40:	01012903          	lw	s2,16(sp)
     b44:	00c12983          	lw	s3,12(sp)
     b48:	02010113          	addi	sp,sp,32
     b4c:	00008067          	ret
    if (c == '\n') {
     b50:	01391863          	bne	s2,s3,b60 <neorv32_uart_puts+0x5c>
      neorv32_uart_putc(UARTx, '\r');
     b54:	00d00593          	li	a1,13
     b58:	00048513          	mv	a0,s1
     b5c:	f95ff0ef          	jal	af0 <neorv32_uart_putc>
    neorv32_uart_putc(UARTx, c);
     b60:	00090593          	mv	a1,s2
     b64:	00048513          	mv	a0,s1
     b68:	f89ff0ef          	jal	af0 <neorv32_uart_putc>
     b6c:	fbdff06f          	j	b28 <neorv32_uart_puts+0x24>

00000b70 <neorv32_uart_vprintf>:
 *
 * @param[in,out] UARTx Hardware handle to UART register struct, #neorv32_uart_t.
 * @param[in] format Pointer to format string.
 * @param[in] args A value identifying a variable arguments list.
 **************************************************************************/
void neorv32_uart_vprintf(neorv32_uart_t *UARTx, const char *format, va_list args) {
     b70:	fa010113          	addi	sp,sp,-96
     b74:	04812c23          	sw	s0,88(sp)
     b78:	04912a23          	sw	s1,84(sp)
     b7c:	05212823          	sw	s2,80(sp)
     b80:	00050493          	mv	s1,a0
     b84:	00058913          	mv	s2,a1
     b88:	00060413          	mv	s0,a2
  int32_t n = 0;
  unsigned int i = 0;

  // prevent uninitialized stack bytes
  for (i=0; i<sizeof(string_buf); i++) {
    string_buf[i] = 0;
     b8c:	00000593          	li	a1,0
     b90:	02400613          	li	a2,36
     b94:	00c10513          	addi	a0,sp,12
void neorv32_uart_vprintf(neorv32_uart_t *UARTx, const char *format, va_list args) {
     b98:	05312623          	sw	s3,76(sp)
     b9c:	05512223          	sw	s5,68(sp)
     ba0:	05612023          	sw	s6,64(sp)
     ba4:	03712e23          	sw	s7,60(sp)
     ba8:	03812c23          	sw	s8,56(sp)
     bac:	03912a23          	sw	s9,52(sp)
     bb0:	04112e23          	sw	ra,92(sp)
     bb4:	05412423          	sw	s4,72(sp)
     bb8:	03a12823          	sw	s10,48(sp)
  }

  while ((c = *format++)) {
    if (c == '%') {
     bbc:	02500a93          	li	s5,37
    string_buf[i] = 0;
     bc0:	1e0000ef          	jal	da0 <memset>
          neorv32_uart_putc(UARTx, c);
          break;
      }
    }
    else {
      if (c == '\n') {
     bc4:	00a00b13          	li	s6,10
      c = tolower(*format++);
     bc8:	00001bb7          	lui	s7,0x1
     bcc:	00100c13          	li	s8,1
      switch (c) {
     bd0:	07000993          	li	s3,112
     bd4:	07500c93          	li	s9,117
  while ((c = *format++)) {
     bd8:	00094d03          	lbu	s10,0(s2) # ffa80000 <__crt0_stack_top+0x7fa60000>
     bdc:	020d1e63          	bnez	s10,c18 <neorv32_uart_vprintf+0xa8>
        neorv32_uart_putc(UARTx, '\r');
      }
      neorv32_uart_putc(UARTx, c);
    }
  }
}
     be0:	05c12083          	lw	ra,92(sp)
     be4:	05812403          	lw	s0,88(sp)
     be8:	05412483          	lw	s1,84(sp)
     bec:	05012903          	lw	s2,80(sp)
     bf0:	04c12983          	lw	s3,76(sp)
     bf4:	04812a03          	lw	s4,72(sp)
     bf8:	04412a83          	lw	s5,68(sp)
     bfc:	04012b03          	lw	s6,64(sp)
     c00:	03c12b83          	lw	s7,60(sp)
     c04:	03812c03          	lw	s8,56(sp)
     c08:	03412c83          	lw	s9,52(sp)
     c0c:	03012d03          	lw	s10,48(sp)
     c10:	06010113          	addi	sp,sp,96
     c14:	00008067          	ret
    if (c == '%') {
     c18:	135d1a63          	bne	s10,s5,d4c <neorv32_uart_vprintf+0x1dc>
      c = tolower(*format++);
     c1c:	00290a13          	addi	s4,s2,2
     c20:	00194903          	lbu	s2,1(s2)
     c24:	50db8793          	addi	a5,s7,1293 # 150d <_ctype_+0x1>
     c28:	00f907b3          	add	a5,s2,a5
     c2c:	0007c783          	lbu	a5,0(a5)
     c30:	0037f793          	andi	a5,a5,3
     c34:	01879463          	bne	a5,s8,c3c <neorv32_uart_vprintf+0xcc>
     c38:	02090913          	addi	s2,s2,32
      switch (c) {
     c3c:	0ff97593          	zext.b	a1,s2
     c40:	0d358863          	beq	a1,s3,d10 <neorv32_uart_vprintf+0x1a0>
     c44:	06b9cc63          	blt	s3,a1,cbc <neorv32_uart_vprintf+0x14c>
     c48:	06300793          	li	a5,99
     c4c:	08f58c63          	beq	a1,a5,ce4 <neorv32_uart_vprintf+0x174>
     c50:	02b7c463          	blt	a5,a1,c78 <neorv32_uart_vprintf+0x108>
     c54:	02500793          	li	a5,37
     c58:	00f58a63          	beq	a1,a5,c6c <neorv32_uart_vprintf+0xfc>
          neorv32_uart_putc(UARTx, '%');
     c5c:	02500593          	li	a1,37
     c60:	00048513          	mv	a0,s1
     c64:	e8dff0ef          	jal	af0 <neorv32_uart_putc>
          neorv32_uart_putc(UARTx, c);
     c68:	0ff97593          	zext.b	a1,s2
      neorv32_uart_putc(UARTx, c);
     c6c:	00048513          	mv	a0,s1
     c70:	e81ff0ef          	jal	af0 <neorv32_uart_putc>
     c74:	0840006f          	j	cf8 <neorv32_uart_vprintf+0x188>
      switch (c) {
     c78:	06400793          	li	a5,100
     c7c:	00f58663          	beq	a1,a5,c88 <neorv32_uart_vprintf+0x118>
     c80:	06900793          	li	a5,105
     c84:	fcf59ce3          	bne	a1,a5,c5c <neorv32_uart_vprintf+0xec>
          n = (int32_t)va_arg(args, int32_t);
     c88:	00440913          	addi	s2,s0,4
     c8c:	00042403          	lw	s0,0(s0)
          if (n < 0) {
     c90:	00045a63          	bgez	s0,ca4 <neorv32_uart_vprintf+0x134>
            neorv32_uart_putc(UARTx, '-');
     c94:	02d00593          	li	a1,45
     c98:	00048513          	mv	a0,s1
            n = -n;
     c9c:	40800433          	neg	s0,s0
            neorv32_uart_putc(UARTx, '-');
     ca0:	e51ff0ef          	jal	af0 <neorv32_uart_putc>
          neorv32_aux_itoa(string_buf, (uint32_t)n, 10);
     ca4:	00a00613          	li	a2,10
     ca8:	00040593          	mv	a1,s0
          neorv32_aux_itoa(string_buf, va_arg(args, uint32_t), 10);
     cac:	00c10513          	addi	a0,sp,12
     cb0:	d09ff0ef          	jal	9b8 <neorv32_aux_itoa>
          neorv32_uart_puts(UARTx, string_buf);
     cb4:	00c10593          	addi	a1,sp,12
     cb8:	0200006f          	j	cd8 <neorv32_uart_vprintf+0x168>
      switch (c) {
     cbc:	05958263          	beq	a1,s9,d00 <neorv32_uart_vprintf+0x190>
     cc0:	07800793          	li	a5,120
     cc4:	04f58663          	beq	a1,a5,d10 <neorv32_uart_vprintf+0x1a0>
     cc8:	07300793          	li	a5,115
     ccc:	f8f598e3          	bne	a1,a5,c5c <neorv32_uart_vprintf+0xec>
          neorv32_uart_puts(UARTx, va_arg(args, char*));
     cd0:	00042583          	lw	a1,0(s0)
     cd4:	00440913          	addi	s2,s0,4
          neorv32_uart_puts(UARTx, string_buf);
     cd8:	00048513          	mv	a0,s1
     cdc:	e29ff0ef          	jal	b04 <neorv32_uart_puts>
          break;
     ce0:	0140006f          	j	cf4 <neorv32_uart_vprintf+0x184>
          neorv32_uart_putc(UARTx, (char)va_arg(args, int));
     ce4:	00044583          	lbu	a1,0(s0)
     ce8:	00048513          	mv	a0,s1
     cec:	00440913          	addi	s2,s0,4
     cf0:	e01ff0ef          	jal	af0 <neorv32_uart_putc>
     cf4:	00090413          	mv	s0,s2
          neorv32_uart_puts(UARTx, va_arg(args, char*));
     cf8:	000a0913          	mv	s2,s4
     cfc:	eddff06f          	j	bd8 <neorv32_uart_vprintf+0x68>
          neorv32_aux_itoa(string_buf, va_arg(args, uint32_t), 10);
     d00:	00042583          	lw	a1,0(s0)
     d04:	00440913          	addi	s2,s0,4
     d08:	00a00613          	li	a2,10
     d0c:	fa1ff06f          	j	cac <neorv32_uart_vprintf+0x13c>
          neorv32_aux_itoa(string_buf, va_arg(args, uint32_t), 16);
     d10:	00042583          	lw	a1,0(s0)
     d14:	01000613          	li	a2,16
     d18:	00c10513          	addi	a0,sp,12
     d1c:	c9dff0ef          	jal	9b8 <neorv32_aux_itoa>
          i = 8 - strlen(string_buf);
     d20:	00c10513          	addi	a0,sp,12
          neorv32_aux_itoa(string_buf, va_arg(args, uint32_t), 16);
     d24:	00440913          	addi	s2,s0,4
          i = 8 - strlen(string_buf);
     d28:	27c000ef          	jal	fa4 <strlen>
     d2c:	00800413          	li	s0,8
     d30:	40a40433          	sub	s0,s0,a0
          while (i--) { // add leading zeros
     d34:	f80400e3          	beqz	s0,cb4 <neorv32_uart_vprintf+0x144>
            neorv32_uart_putc(UARTx, '0');
     d38:	03000593          	li	a1,48
     d3c:	00048513          	mv	a0,s1
     d40:	db1ff0ef          	jal	af0 <neorv32_uart_putc>
     d44:	fff40413          	addi	s0,s0,-1
     d48:	fedff06f          	j	d34 <neorv32_uart_vprintf+0x1c4>
      if (c == '\n') {
     d4c:	016d1863          	bne	s10,s6,d5c <neorv32_uart_vprintf+0x1ec>
        neorv32_uart_putc(UARTx, '\r');
     d50:	00d00593          	li	a1,13
     d54:	00048513          	mv	a0,s1
     d58:	d99ff0ef          	jal	af0 <neorv32_uart_putc>
  while ((c = *format++)) {
     d5c:	00190a13          	addi	s4,s2,1
      neorv32_uart_putc(UARTx, c);
     d60:	000d0593          	mv	a1,s10
     d64:	f09ff06f          	j	c6c <neorv32_uart_vprintf+0xfc>

00000d68 <neorv32_uart_printf>:
 * @note This function is blocking.
 *
 * @param[in,out] UARTx Hardware handle to UART register struct, #neorv32_uart_t.
 * @param[in] format Pointer to format string. See neorv32_uart_vprintf.
 **************************************************************************/
void neorv32_uart_printf(neorv32_uart_t *UARTx, const char *format, ...) {
     d68:	fc010113          	addi	sp,sp,-64
     d6c:	02c12423          	sw	a2,40(sp)

  va_list args;
  va_start(args, format);
     d70:	02810613          	addi	a2,sp,40
void neorv32_uart_printf(neorv32_uart_t *UARTx, const char *format, ...) {
     d74:	00112e23          	sw	ra,28(sp)
     d78:	02d12623          	sw	a3,44(sp)
     d7c:	02e12823          	sw	a4,48(sp)
     d80:	02f12a23          	sw	a5,52(sp)
     d84:	03012c23          	sw	a6,56(sp)
     d88:	03112e23          	sw	a7,60(sp)
  va_start(args, format);
     d8c:	00c12623          	sw	a2,12(sp)
  neorv32_uart_vprintf(UARTx, format, args);
     d90:	de1ff0ef          	jal	b70 <neorv32_uart_vprintf>
  va_end(args);
}
     d94:	01c12083          	lw	ra,28(sp)
     d98:	04010113          	addi	sp,sp,64
     d9c:	00008067          	ret

00000da0 <memset>:
     da0:	00f00313          	li	t1,15
     da4:	00050713          	mv	a4,a0
     da8:	02c37e63          	bgeu	t1,a2,de4 <memset+0x44>
     dac:	00f77793          	andi	a5,a4,15
     db0:	0a079063          	bnez	a5,e50 <memset+0xb0>
     db4:	08059263          	bnez	a1,e38 <memset+0x98>
     db8:	ff067693          	andi	a3,a2,-16
     dbc:	00f67613          	andi	a2,a2,15
     dc0:	00e686b3          	add	a3,a3,a4
     dc4:	00b72023          	sw	a1,0(a4)
     dc8:	00b72223          	sw	a1,4(a4)
     dcc:	00b72423          	sw	a1,8(a4)
     dd0:	00b72623          	sw	a1,12(a4)
     dd4:	01070713          	addi	a4,a4,16
     dd8:	fed766e3          	bltu	a4,a3,dc4 <memset+0x24>
     ddc:	00061463          	bnez	a2,de4 <memset+0x44>
     de0:	00008067          	ret
     de4:	40c306b3          	sub	a3,t1,a2
     de8:	00269693          	slli	a3,a3,0x2
     dec:	00000297          	auipc	t0,0x0
     df0:	005686b3          	add	a3,a3,t0
     df4:	00c68067          	jr	12(a3) # f0000c <__neorv32_ram_size+0xee000c>
     df8:	00b70723          	sb	a1,14(a4)
     dfc:	00b706a3          	sb	a1,13(a4)
     e00:	00b70623          	sb	a1,12(a4)
     e04:	00b705a3          	sb	a1,11(a4)
     e08:	00b70523          	sb	a1,10(a4)
     e0c:	00b704a3          	sb	a1,9(a4)
     e10:	00b70423          	sb	a1,8(a4)
     e14:	00b703a3          	sb	a1,7(a4)
     e18:	00b70323          	sb	a1,6(a4)
     e1c:	00b702a3          	sb	a1,5(a4)
     e20:	00b70223          	sb	a1,4(a4)
     e24:	00b701a3          	sb	a1,3(a4)
     e28:	00b70123          	sb	a1,2(a4)
     e2c:	00b700a3          	sb	a1,1(a4)
     e30:	00b70023          	sb	a1,0(a4)
     e34:	00008067          	ret
     e38:	0ff5f593          	zext.b	a1,a1
     e3c:	00859693          	slli	a3,a1,0x8
     e40:	00d5e5b3          	or	a1,a1,a3
     e44:	01059693          	slli	a3,a1,0x10
     e48:	00d5e5b3          	or	a1,a1,a3
     e4c:	f6dff06f          	j	db8 <memset+0x18>
     e50:	00279693          	slli	a3,a5,0x2
     e54:	00000297          	auipc	t0,0x0
     e58:	005686b3          	add	a3,a3,t0
     e5c:	00008293          	mv	t0,ra
     e60:	fa0680e7          	jalr	-96(a3)
     e64:	00028093          	mv	ra,t0
     e68:	ff078793          	addi	a5,a5,-16
     e6c:	40f70733          	sub	a4,a4,a5
     e70:	00f60633          	add	a2,a2,a5
     e74:	f6c378e3          	bgeu	t1,a2,de4 <memset+0x44>
     e78:	f3dff06f          	j	db4 <memset+0x14>

00000e7c <memcpy>:
     e7c:	00a5c7b3          	xor	a5,a1,a0
     e80:	0037f793          	andi	a5,a5,3
     e84:	00c508b3          	add	a7,a0,a2
     e88:	06079663          	bnez	a5,ef4 <memcpy+0x78>
     e8c:	00300793          	li	a5,3
     e90:	06c7f263          	bgeu	a5,a2,ef4 <memcpy+0x78>
     e94:	00357793          	andi	a5,a0,3
     e98:	00050713          	mv	a4,a0
     e9c:	0c079a63          	bnez	a5,f70 <memcpy+0xf4>
     ea0:	ffc8f613          	andi	a2,a7,-4
     ea4:	40e606b3          	sub	a3,a2,a4
     ea8:	02000793          	li	a5,32
     eac:	06d7c463          	blt	a5,a3,f14 <memcpy+0x98>
     eb0:	00058693          	mv	a3,a1
     eb4:	00070793          	mv	a5,a4
     eb8:	02c77a63          	bgeu	a4,a2,eec <memcpy+0x70>
     ebc:	0006a803          	lw	a6,0(a3)
     ec0:	00478793          	addi	a5,a5,4
     ec4:	00468693          	addi	a3,a3,4
     ec8:	ff07ae23          	sw	a6,-4(a5)
     ecc:	fec7e8e3          	bltu	a5,a2,ebc <memcpy+0x40>
     ed0:	fff60613          	addi	a2,a2,-1 # 9ffff <__neorv32_ram_size+0x7ffff>
     ed4:	40e60633          	sub	a2,a2,a4
     ed8:	ffc67613          	andi	a2,a2,-4
     edc:	00458593          	addi	a1,a1,4
     ee0:	00470713          	addi	a4,a4,4
     ee4:	00c585b3          	add	a1,a1,a2
     ee8:	00c70733          	add	a4,a4,a2
     eec:	01176863          	bltu	a4,a7,efc <memcpy+0x80>
     ef0:	00008067          	ret
     ef4:	00050713          	mv	a4,a0
     ef8:	ff157ce3          	bgeu	a0,a7,ef0 <memcpy+0x74>
     efc:	0005c783          	lbu	a5,0(a1)
     f00:	00170713          	addi	a4,a4,1
     f04:	00158593          	addi	a1,a1,1
     f08:	fef70fa3          	sb	a5,-1(a4)
     f0c:	fee898e3          	bne	a7,a4,efc <memcpy+0x80>
     f10:	00008067          	ret
     f14:	0205a683          	lw	a3,32(a1)
     f18:	0005a383          	lw	t2,0(a1)
     f1c:	0045a283          	lw	t0,4(a1)
     f20:	0085af83          	lw	t6,8(a1)
     f24:	00c5af03          	lw	t5,12(a1)
     f28:	0105ae83          	lw	t4,16(a1)
     f2c:	0145ae03          	lw	t3,20(a1)
     f30:	0185a303          	lw	t1,24(a1)
     f34:	01c5a803          	lw	a6,28(a1)
     f38:	02470713          	addi	a4,a4,36
     f3c:	fed72e23          	sw	a3,-4(a4)
     f40:	fc772e23          	sw	t2,-36(a4)
     f44:	40e606b3          	sub	a3,a2,a4
     f48:	fe572023          	sw	t0,-32(a4)
     f4c:	fff72223          	sw	t6,-28(a4)
     f50:	ffe72423          	sw	t5,-24(a4)
     f54:	ffd72623          	sw	t4,-20(a4)
     f58:	ffc72823          	sw	t3,-16(a4)
     f5c:	fe672a23          	sw	t1,-12(a4)
     f60:	ff072c23          	sw	a6,-8(a4)
     f64:	02458593          	addi	a1,a1,36
     f68:	fad7c6e3          	blt	a5,a3,f14 <memcpy+0x98>
     f6c:	f45ff06f          	j	eb0 <memcpy+0x34>
     f70:	0005c683          	lbu	a3,0(a1)
     f74:	00170713          	addi	a4,a4,1
     f78:	00377793          	andi	a5,a4,3
     f7c:	fed70fa3          	sb	a3,-1(a4)
     f80:	00158593          	addi	a1,a1,1
     f84:	f0078ee3          	beqz	a5,ea0 <memcpy+0x24>
     f88:	0005c683          	lbu	a3,0(a1)
     f8c:	00170713          	addi	a4,a4,1
     f90:	00377793          	andi	a5,a4,3
     f94:	fed70fa3          	sb	a3,-1(a4)
     f98:	00158593          	addi	a1,a1,1
     f9c:	fc079ae3          	bnez	a5,f70 <memcpy+0xf4>
     fa0:	f01ff06f          	j	ea0 <memcpy+0x24>

00000fa4 <strlen>:
     fa4:	00357793          	andi	a5,a0,3
     fa8:	00050713          	mv	a4,a0
     fac:	04079c63          	bnez	a5,1004 <strlen+0x60>
     fb0:	7f7f86b7          	lui	a3,0x7f7f8
     fb4:	f7f68693          	addi	a3,a3,-129 # 7f7f7f7f <__neorv32_ram_size+0x7f7d7f7f>
     fb8:	fff00593          	li	a1,-1
     fbc:	00072603          	lw	a2,0(a4)
     fc0:	00470713          	addi	a4,a4,4
     fc4:	00d677b3          	and	a5,a2,a3
     fc8:	00d787b3          	add	a5,a5,a3
     fcc:	00c7e7b3          	or	a5,a5,a2
     fd0:	00d7e7b3          	or	a5,a5,a3
     fd4:	feb784e3          	beq	a5,a1,fbc <strlen+0x18>
     fd8:	ffc74683          	lbu	a3,-4(a4)
     fdc:	40a707b3          	sub	a5,a4,a0
     fe0:	04068463          	beqz	a3,1028 <strlen+0x84>
     fe4:	ffd74683          	lbu	a3,-3(a4)
     fe8:	02068c63          	beqz	a3,1020 <strlen+0x7c>
     fec:	ffe74503          	lbu	a0,-2(a4)
     ff0:	00a03533          	snez	a0,a0
     ff4:	00f50533          	add	a0,a0,a5
     ff8:	ffe50513          	addi	a0,a0,-2
     ffc:	00008067          	ret
    1000:	fa0688e3          	beqz	a3,fb0 <strlen+0xc>
    1004:	00074783          	lbu	a5,0(a4)
    1008:	00170713          	addi	a4,a4,1
    100c:	00377693          	andi	a3,a4,3
    1010:	fe0798e3          	bnez	a5,1000 <strlen+0x5c>
    1014:	40a70733          	sub	a4,a4,a0
    1018:	fff70513          	addi	a0,a4,-1
    101c:	00008067          	ret
    1020:	ffd78513          	addi	a0,a5,-3
    1024:	00008067          	ret
    1028:	ffc78513          	addi	a0,a5,-4
    102c:	00008067          	ret
