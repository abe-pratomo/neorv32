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
  constant EXP_MIN_INPUT : signed(31 downto 0) := x"FFF4E8DF"; -- -726817
  constant EXP_MAX_INPUT : signed(31 downto 0) := x"000A65AF"; --  681391

  -- lookup table types --
  type boundary_table_t  is array(0 to 30) of signed(31 downto 0);
  type slope_table_t     is array(0 to 31) of signed(31 downto 0);
  type intercept_table_t is array(0 to 31) of signed(63 downto 0);

  -- boundary values for segment selection --
  constant BOUNDARY : boundary_table_t := (
      0  => x"FFF594C6",
      1  => x"FFF640AC",
      2  => x"FFF6EC93",
      3  => x"FFF79879",
      4  => x"FFF84460",
      5  => x"FFF8F046",
      6  => x"FFF99C2D",
      7  => x"FFFA4813",
      8  => x"FFFAF3FA",
      9  => x"FFFB9FE0",
      10 => x"FFFC4BC7",
      11 => x"FFFCF7AD",
      12 => x"FFFDA394",
      13 => x"FFFE4F7A",
      14 => x"FFFEFB61",
      15 => x"FFFFA747",
      16 => x"0000532E",
      17 => x"0000FF14",
      18 => x"0001AAFB",
      19 => x"000256E1",
      20 => x"000302C8",
      21 => x"0003AEAE",
      22 => x"00045A95",
      23 => x"0005067B",
      24 => x"0005B262",
      25 => x"00065E48",
      26 => x"00070A2F",
      27 => x"0007B615",
      28 => x"000861FC",
      29 => x"00090DE2",
      30 => x"0009B9C9"
  );

  -- slopes for each segment --
  constant SLOPE : slope_table_t := (
      0  => x"00000001",
      1  => x"00000003",
      2  => x"00000005",
      3  => x"0000000B",
      4  => x"00000015",
      5  => x"00000029",
      6  => x"00000050",
      7  => x"0000009C",
      8  => x"00000131",
      9  => x"00000254",
      10 => x"0000048F",
      11 => x"000008EB",
      12 => x"00001175",
      13 => x"0000222A",
      14 => x"000042DD",
      15 => x"000082DC",
      16 => x"0001001C",
      17 => x"0001F53D",
      18 => x"0003D4FF",
      19 => x"00077FF4",
      20 => x"000EAD9F",
      21 => x"001CBA34",
      22 => x"0038393C",
      23 => x"006E099C",
      24 => x"00D75BFD",
      25 => x"01A57D26",
      26 => x"0338EA1E",
      27 => x"064E799F",
      28 => x"0C57C2BB",
      29 => x"182819E9",
      30 => x"2F472DA7",
      31 => x"5C87D5BA"
  );

  -- intercepts for each segment (64-bit) --
  constant INTERCEPT : intercept_table_t := (
      0  => x"0000000000000011",
      1  => x"000000000000001F",
      2  => x"0000000000000038",
      3  => x"0000000000000067",
      4  => x"00000000000000BC",
      5  => x"0000000000000155",
      6  => x"0000000000000267",
      7  => x"000000000000044B",
      8  => x"000000000000079A",
      9  => x"0000000000000D51",
      10 => x"0000000000001700",
      11 => x"0000000000002707",
      12 => x"00000000000040A9",
      13 => x"000000000000679C",
      14 => x"0000000000009DE1",
      15 => x"000000000000DD20",
      16 => x"00000000000104CD",
      17 => x"000000000000ADD9",
      18 => x"FFFFFFFFFFFEC186",
      19 => x"FFFFFFFFFFF88779",
      20 => x"FFFFFFFFFFE785B8",
      21 => x"FFFFFFFFFFBCCDBF",
      22 => x"FFFFFFFFFF56BBDC",
      23 => x"FFFFFFFFFE6AD555",
      24 => x"FFFFFFFFFC566B70",
      25 => x"FFFFFFFFF7B9FF78",
      26 => x"FFFFFFFFEDA4D89E",
      27 => x"FFFFFFFFD7D6FD52",
      28 => x"FFFFFFFFA91CD873",
      29 => x"FFFFFFFF45BA7166",
      30 => x"FFFFFFFE73B1600F",
      31 => x"FFFFFFFCBA3B051A"
  );

  constant INT32_MAX : signed(63 downto 0) := x"000000007FFFFFFF";

  -- exp_pwl function --
  function exp_pwl(x : signed(31 downto 0)) return signed is
      variable m        : signed(31 downto 0);
      variable b        : signed(63 downto 0);
      variable mult     : signed(63 downto 0);
      variable result64 : signed(63 downto 0);
      variable found    : boolean;
  begin
      if x <= EXP_MIN_INPUT then
          return (others => '0');
      elsif x >= EXP_MAX_INPUT then
          return x"7FFFFFFF";
      else
          -- Default to last segment
          m := SLOPE(31);
          b := INTERCEPT(31);

          -- Search for the correct segment
          found := false;
          for i in 0 to 30 loop
              if (not found) and (x < BOUNDARY(i)) then
                  m     := SLOPE(i);
                  b     := INTERCEPT(i);
                  found := true;
              end if;
          end loop;

          mult     := m * x;
          result64 := shift_right(mult, 16) + b;

          if result64 <= 0 then
              return (others => '0');
          elsif result64 >= INT32_MAX then
              return x"7FFFFFFF";
          else
              return result64(31 downto 0);
          end if;
        end if;
    end function exp_pwl;


  -- instruction identifiers (funct3 bit-field) --
  constant lwa_c : std_ulogic_vector(2 downto 0) := "000";
  constant lwm_c : std_ulogic_vector(2 downto 0) := "001";
  constant exp_c : std_ulogic_vector(2 downto 0) := "010";

  -- instruction decoder --
  signal opcode : std_ulogic_vector(6 downto 0); -- instruction opcode
  signal funct3 : std_ulogic_vector(2 downto 0); -- instruction type field

  -- EXP valid signal --
  signal exp_valid : std_ulogic; -- valid EXP instruction

  -- LSU valid register --
  signal lsu_valid : std_ulogic; -- LSU memory read data valid signal

  -- processing logic --
  type annx_t is record
    opa     : std_ulogic_vector(31 downto 0); -- input operand a
    opb     : std_ulogic_vector(31 downto 0); -- input operand b
    mul     : signed(63 downto 0);            -- intermediate multiplication result
    res     : std_ulogic_vector(31 downto 0); -- operation result
  end record;
  signal annx : annx_t;

begin

  -- ANNX Instruction Decode -------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  opcode <= inst_i(6 downto 0);   -- instruction opcode
  funct3 <= inst_i(14 downto 12); -- type function select


  -- ANNX Operand & Operation Select -----------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  annx.opa <= lsu_rdata_i when ((opcode = opcode_custom0_c) and ((funct3 = lwa_c) or (funct3 = lwm_c))) else  -- select LSU memory read data for LWA/LWM
              rs1_i       when ((opcode = opcode_custom0_c) and (funct3 = exp_c)) else                        -- select rs1 for EXP
              (others => '0');
  annx.opb <= rs2_i when ((opcode = opcode_custom0_c) and ((funct3 = lwa_c) or (funct3 = lwm_c))) else  -- select rs2 for LWA/LWM
              (others => '0');
  annx.mul <= signed(annx.opa) * signed(annx.opb);
  annx.res <= std_ulogic_vector(signed(annx.opa) + signed(annx.opb))  when ((opcode = opcode_custom0_c) and (funct3 = lwa_c)) else
              std_ulogic_vector(annx.mul(47 downto 16))               when ((opcode = opcode_custom0_c) and (funct3 = lwm_c)) else
              std_ulogic_vector(exp_pwl(signed(annx.opa)))            when ((opcode = opcode_custom0_c) and (funct3 = exp_c)) else
              (others => '0');


  -- EXP Valid Check ---------------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  exp_valid  <= start_i when ((opcode = opcode_custom0_c) and (funct3 = exp_c)) else '0'; -- assert valid immediately when start_i is high for EXP instruction


  -- LSU Valid Check (LWA, LWM) ----------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
      lsu_valid   <= '0';
    elsif rising_edge(clk_i) then
      lsu_valid   <= not lsu_wait_i when ((opcode = opcode_custom0_c) and ((funct3 = lwa_c) or (funct3 = lwm_c))) else '0'; -- assert one cycle after lsu_wait_i is low for LWA/LWM instructions
    end if;
  end process;


  -- Result Output and Valid Signal ------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  result_o <= annx.res; -- always output the result of the operation, regardless of instruction type
  valid_o  <= exp_valid xor lsu_valid; -- ensures only valid when either EXP or LWA/LWM is valid, but not both


end neorv32_cpu_alu_cfu_rtl;
