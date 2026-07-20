-- ================================================================================ --
-- NEORV32 CPU - ALU Custom (RISC-V Instructions) Functions Unit (CFU)              --
-- -------------------------------------------------------------------------------- --
-- See the CPU's data sheet for more information. Also take a look at the "software --
-- counterpart" of this CFU example in sw/example/demo_cfu.                         --
-- -------------------------------------------------------------------------------- --
-- The NEORV32 RISC-V Processor - https://github.com/stnolting/neorv32              --
-- Copyright (c) NEORV32 contributors.                                              --
-- Copyright (c) 2020 - 2026 Stephan Nolting. All rights reserved.                  --
-- Licensed under the BSD-3-Clause license, see LICENSE for details.                --
-- SPDX-License-Identifier: BSD-3-Clause                                            --
-- ================================================================================ --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;
use neorv32.neorv32_package.all;

entity neorv32_cpu_alu_cfu is
  port (
    -- global control --
    clk_i    : in  std_ulogic; -- global clock, rising edge
    rstn_i   : in  std_ulogic; -- global reset, low-active, async
    -- request --
    start_i  : in  std_ulogic; -- start trigger, single-shot
    inst_i   : in  std_ulogic_vector(31 downto 0); -- full instruction word
    rs1_i    : in  std_ulogic_vector(31 downto 0); -- register source operand 1
    rs2_i    : in  std_ulogic_vector(31 downto 0); -- register source operand 2
    -- user-defined request (LSU memory read data and wait signal) --
    lsu_rdata_i : in  std_ulogic_vector(31 downto 0); -- LSU memory read data
    lsu_wait_i  : in  std_ulogic;                     -- LSU wait signal
    -- response --
    result_o : out std_ulogic_vector(31 downto 0); -- operation result
    valid_o  : out std_ulogic                      -- operation done; result valid
  );
end neorv32_cpu_alu_cfu;

architecture neorv32_cpu_alu_cfu_rtl of neorv32_cpu_alu_cfu is

  -- CFU opcode --
  constant opcode_custom0_c : std_ulogic_vector(6 downto 0) := "0001011";

  -- **********************************************************
  -- ANNX - Artificial Neural Network Accelerator Extension
  -- **********************************************************

  -- Adds three custom RISC-V instructions to the NEORV32 CPU for accelerating artificial neural network (ANN) workloads:
  -- 1. LWA (Load and Add)                  : rd = M[rs1 + (imm << 2)] + rs2
  -- 2. LWM (Load and Multiply)             : rd = (M[rs1 + (imm << 2)] * rs2) >>> 16
  -- 3. EXP (Exponential PWL Approximation) : rd = exp_pwl(rs1)
  
  -- Q16.16 constants --
  constant EXP_MIN_INPUT : signed(31 downto 0) := to_signed(-726817, 32);
  constant EXP_MAX_INPUT : signed(31 downto 0) := to_signed( 681391, 32);

  -- lookup table types --
  type boundary_table_t  is array(0 to 30) of signed(31 downto 0);
  type slope_table_t     is array(0 to 31) of signed(31 downto 0);
  type intercept_table_t is array(0 to 31) of signed(63 downto 0);

  -- boundary values for segment selection --
  constant BOUNDARY : boundary_table_t := (
      0  => to_signed(-682810, 32),
      1  => to_signed(-638804, 32),
      2  => to_signed(-594797, 32),
      3  => to_signed(-550791, 32),
      4  => to_signed(-506784, 32),
      5  => to_signed(-462778, 32),
      6  => to_signed(-418771, 32),
      7  => to_signed(-374765, 32),
      8  => to_signed(-330758, 32),
      9  => to_signed(-286752, 32),
      10 => to_signed(-242745, 32),
      11 => to_signed(-198739, 32),
      12 => to_signed(-154732, 32),
      13 => to_signed(-110726, 32),
      14 => to_signed( -66719, 32),
      15 => to_signed( -22713, 32),
      16 => to_signed(  21294, 32),
      17 => to_signed(  65300, 32),
      18 => to_signed( 109307, 32),
      19 => to_signed( 153313, 32),
      20 => to_signed( 197320, 32),
      21 => to_signed( 241326, 32),
      22 => to_signed( 285333, 32),
      23 => to_signed( 329339, 32),
      24 => to_signed( 373346, 32),
      25 => to_signed( 417352, 32),
      26 => to_signed( 461359, 32),
      27 => to_signed( 505365, 32),
      28 => to_signed( 549372, 32),
      29 => to_signed( 593378, 32),
      30 => to_signed( 637385, 32)
  );

  -- slopes for each segment --
  constant SLOPE : slope_table_t := (
      0  => to_signed(1,          32),
      1  => to_signed(3,          32),
      2  => to_signed(5,          32),
      3  => to_signed(11,         32),
      4  => to_signed(21,         32),
      5  => to_signed(41,         32),
      6  => to_signed(80,         32),
      7  => to_signed(156,        32),
      8  => to_signed(305,        32),
      9  => to_signed(596,        32),
      10 => to_signed(1167,       32),
      11 => to_signed(2283,       32),
      12 => to_signed(4469,       32),
      13 => to_signed(8746,       32),
      14 => to_signed(17117,      32),
      15 => to_signed(33500,      32),
      16 => to_signed(65564,      32),
      17 => to_signed(128317,     32),
      18 => to_signed(251135,     32),
      19 => to_signed(491508,     32),
      20 => to_signed(961951,     32),
      21 => to_signed(1882676,    32),
      22 => to_signed(3684668,    32),
      23 => to_signed(7211420,    32),
      24 => to_signed(14113789,   32),
      25 => to_signed(27622694,   32),
      26 => to_signed(54061598,   32),
      27 => to_signed(105806239,  32),
      28 => to_signed(207078075,  32),
      29 => to_signed(405281257,  32),
      30 => to_signed(793193895,  32),
      31 => to_signed(1552405946, 32)
  );


  -- intercepts for each segment (64-bit) --
  constant INTERCEPT : intercept_table_t := (
      0  => to_signed(17,             64),
      1  => to_signed(31,             64),
      2  => to_signed(56,             64),
      3  => to_signed(103,            64),
      4  => to_signed(188,            64),
      5  => to_signed(341,            64),
      6  => to_signed(615,            64),
      7  => to_signed(1099,           64),
      8  => to_signed(1946,           64),
      9  => to_signed(3409,           64),
      10 => to_signed(5888,           64),
      11 => to_signed(9991,           64),
      12 => to_signed(16553,          64),
      13 => to_signed(26524,          64),
      14 => to_signed(40417,          64),
      15 => to_signed(56608,          64),
      16 => to_signed(66765,          64),
      17 => to_signed(44505,          64),
      18 => to_signed(-81530,         64),
      19 => to_signed(-489607,        64),
      20 => to_signed(-1604168,       64),
      21 => to_signed(-4403777,       64),
      22 => to_signed(-11093028,      64),
      23 => to_signed(-26553003,      64),
      24 => to_signed(-61445264,      64),
      25 => to_signed(-138805384,     64),
      26 => to_signed(-307963746,     64),
      27 => to_signed(-673776302,     64),
      28 => to_signed(-1457727373,    64),
      29 => x"FFFFFFFF45BA7166",
      30 => x"FFFFFFFE73B1600F",
      31 => x"FFFFFFFCBA3B051A"
  );

  constant INT32_MAX : signed(63 downto 0) := to_signed(2147483647, 64);


  -- instruction identifiers (funct3 bit-field) --
  constant lwa_c : std_ulogic_vector(2 downto 0) := "000";
  constant lwm_c : std_ulogic_vector(2 downto 0) := "001";
  constant exp_c : std_ulogic_vector(2 downto 0) := "010";

  -- instruction decoder --
  signal opcode : std_ulogic_vector(6 downto 0); -- instruction opcode
  signal funct3 : std_ulogic_vector(2 downto 0); -- instruction type field

  -- signals for LSU-related operations (LWA and LWM) --
  signal lsu_opa    : std_ulogic_vector(31 downto 0); -- first operand
  signal lsu_opb    : std_ulogic_vector(31 downto 0); -- second operand
  signal lsu_add    : signed(31 downto 0);            -- addition intermediate signal
  signal lsu_mul    : signed(63 downto 0);            -- multiplication intermediate signal

  signal lsu_valid  : std_ulogic; -- LSU memory read data valid signal

  -- pipeline registers for EXP --
  signal exp_x            : signed(31 downto 0);  -- registered input
  signal exp_m            : signed(31 downto 0);  -- selected slope
  signal exp_b            : signed(63 downto 0);  -- selected intercept
  signal exp_clamp_min    : std_ulogic;           -- clamp to 0
  signal exp_clamp_max    : std_ulogic;           -- clamp to INT32_MAX
  signal exp_pipe1_valid  : std_ulogic;           -- stage 1 valid

  signal exp_res          : std_ulogic_vector(31 downto 0);  -- stage 2 result
  signal exp_valid        : std_ulogic;                      -- stage 2 valid

begin

  -- ANNX Instruction Decode -------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  opcode <= inst_i(6 downto 0);   -- instruction opcode
  funct3 <= inst_i(14 downto 12); -- type function select


  -- LSU Operand & Operation Assign ------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  lsu_opa <= lsu_rdata_i when ((opcode = opcode_custom0_c) and ((funct3 = lwa_c) or (funct3 = lwm_c))) else  -- select LSU memory read data for LWA/LWM
             (others => '0');
  lsu_opb <= rs2_i when ((opcode = opcode_custom0_c) and ((funct3 = lwa_c) or (funct3 = lwm_c))) else  -- select rs2 for LWA/LWM
             (others => '0');
  lsu_add <= signed(lsu_opa) + signed(lsu_opb);
  lsu_mul <= signed(lsu_opa) * signed(lsu_opb);


  -- LSU Valid Check ---------------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
      lsu_valid   <= '0';
    elsif rising_edge(clk_i) then
      if ((opcode = opcode_custom0_c) and ((funct3 = lwa_c) or (funct3 = lwm_c))) then
        lsu_valid   <= not lsu_wait_i; -- assert one cycle after lsu_wait_i is low for LWA/LWM instructions
      else
        lsu_valid   <= '0';
      end if;
    end if;
  end process;


  -- EXP Operand Assign ------------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  exp_x <= signed(rs1_i) when (opcode = opcode_custom0_c) and (funct3 = exp_c) else
           (others => '0');


  -- EXP Pipeline -----------------------------------------------------------------------------
  -- ------------------------------------------------------------------------------------------
  process(rstn_i, clk_i)
    variable m        : signed(31 downto 0);
    variable b        : signed(63 downto 0);
    variable found    : boolean;
    variable mult     : signed(63 downto 0);
    variable result64 : signed(63 downto 0);
  begin
    if rstn_i = '0' then
      exp_m           <= (others => '0');
      exp_b           <= (others => '0');
      exp_pipe1_valid <= '0';
      exp_clamp_min   <= '0';
      exp_clamp_max   <= '0';
      exp_res         <= (others => '0');
      exp_valid       <= '0';
    elsif rising_edge(clk_i) then

      -- --------------------------------------------------------
      -- Stage 1: find segment, detect clamp
      -- --------------------------------------------------------
      exp_pipe1_valid <= '0';
      if (opcode = opcode_custom0_c) and (funct3 = exp_c) and (start_i = '1') then
        exp_pipe1_valid <= '1';

        -- clamp detection
        if exp_x <= EXP_MIN_INPUT then
          exp_clamp_min <= '1';
          exp_clamp_max <= '0';
          exp_m         <= (others => '0');
          exp_b         <= (others => '0');
        elsif exp_x >= EXP_MAX_INPUT then
          exp_clamp_min <= '0';
          exp_clamp_max <= '1';
          exp_m         <= (others => '0');
          exp_b         <= (others => '0');
        else
          exp_clamp_min <= '0';
          exp_clamp_max <= '0';
          -- segment search
          m     := SLOPE(31);
          b     := INTERCEPT(31);
          found := false;
          for i in 0 to 30 loop
            if (not found) and (exp_x < BOUNDARY(i)) then
              m     := SLOPE(i);
              b     := INTERCEPT(i);
              found := true;
            end if;
          end loop;
          exp_m <= m;
          exp_b <= b;
        end if;
      end if;

      -- --------------------------------------------------------
      -- Stage 2: multiply, shift, add intercept, clamp result
      -- --------------------------------------------------------
      exp_valid <= exp_pipe1_valid;
      if exp_pipe1_valid = '1' then
        if exp_clamp_min = '1' then
          exp_res <= (others => '0');
        elsif exp_clamp_max = '1' then
          exp_res <= x"7FFFFFFF";
        else
          mult      := exp_m * exp_x;
          result64  := shift_right(mult, 16) + exp_b;
          if result64 <= 0 then
            exp_res <= (others => '0');
          elsif result64 >= INT32_MAX then
            exp_res <= x"7FFFFFFF";
          else
            exp_res <= std_ulogic_vector(result64(31 downto 0));
          end if;
        end if;
      end if;
    end if;
  end process;


  -- Result Output and Valid Signal ------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  result_o <= lsu_add when ((opcode = opcode_custom0_c) and (funct3 = lwa_c)) else -- LWA
              lsu_mul when ((opcode = opcode_custom0_c) and (funct3 = lwm_c)) else -- LWM
              exp_res when ((opcode = opcode_custom0_c) and (funct3 = exp_c)) else -- EXP
              (others => '0');
  valid_o  <= exp_valid xor lsu_valid; -- ensures only valid when either EXP or LWA/LWM is valid, but not both


end neorv32_cpu_alu_cfu_rtl;
