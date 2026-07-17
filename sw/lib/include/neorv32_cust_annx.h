#ifndef NEORV32_CUST_ANNX_H
#define NEORV32_CUST_ANNX_H

#include <neorv32.h>
#include <stdint.h>
#include <neorv32_intrinsics.h>

#define LWA_FUNCT3 0b000
#define LWM_FUNCT3 0b001
#define EXP_FUNCT3 0b010

inline int32_t __attribute__ ((always_inline)) annx_lwa(uint32_t rs1, uint32_t rs2, const int word_offset) {
  return RISCV_INSTR_R_TYPE(RISCV_OPCODE_CUSTOM0, LWA_FUNCT3, word_offset, rs1, rs2);
}

inline int32_t __attribute__ ((always_inline)) annx_lwm(uint32_t rs1, uint32_t rs2, const int word_offset) {
  return RISCV_INSTR_R_TYPE(RISCV_OPCODE_CUSTOM0, LWM_FUNCT3, word_offset, rs1, rs2);
}

inline int32_t __attribute__ ((always_inline)) annx_exp(uint32_t rs1) {
  return RISCV_INSTR_R_TYPE(RISCV_OPCODE_CUSTOM0, EXP_FUNCT3, 0, rs1, 0);
}

#endif // NEORV32_CUST_ANNX_H