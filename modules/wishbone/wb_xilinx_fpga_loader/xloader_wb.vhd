---------------------------------------------------------------------------------------
-- Title          : Wishbone slave core for Xilinx FPGA loader
---------------------------------------------------------------------------------------
-- File           : xloader_wb.vhd
-- Author         : auto-generated by wbgen2 from xloader_wb.wb
-- Created        : Tue Jan 31 15:31:31 2012
-- Standard       : VHDL'87
---------------------------------------------------------------------------------------
-- THIS FILE WAS GENERATED BY wbgen2 FROM SOURCE FILE xloader_wb.wb
-- DO NOT HAND-EDIT UNLESS IT'S ABSOLUTELY NECESSARY!
---------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wbgen2_pkg.all;

use work.xldr_wbgen2_pkg.all;


entity xloader_wb is
  port (
    rst_n_i                                  : in     std_logic;
    wb_clk_i                                 : in     std_logic;
    wb_addr_i                                : in     std_logic_vector(1 downto 0);
    wb_data_i                                : in     std_logic_vector(31 downto 0);
    wb_data_o                                : out    std_logic_vector(31 downto 0);
    wb_cyc_i                                 : in     std_logic;
    wb_sel_i                                 : in     std_logic_vector(3 downto 0);
    wb_stb_i                                 : in     std_logic;
    wb_we_i                                  : in     std_logic;
    wb_ack_o                                 : out    std_logic;
    regs_i                                   : in     t_xldr_in_registers;
    regs_o                                   : out    t_xldr_out_registers
  );
end xloader_wb;

architecture syn of xloader_wb is

signal xldr_csr_start_dly0                      : std_logic      ;
signal xldr_csr_start_int                       : std_logic      ;
signal xldr_csr_msbf_int                        : std_logic      ;
signal xldr_csr_swrst_dly0                      : std_logic      ;
signal xldr_csr_swrst_int                       : std_logic      ;
signal xldr_csr_clkdiv_int                      : std_logic_vector(5 downto 0);
signal xldr_fifo_in_int                         : std_logic_vector(34 downto 0);
signal xldr_fifo_out_int                        : std_logic_vector(34 downto 0);
signal xldr_fifo_wrreq_int                      : std_logic      ;
signal xldr_fifo_full_int                       : std_logic      ;
signal xldr_fifo_empty_int                      : std_logic      ;
signal xldr_fifo_usedw_int                      : std_logic_vector(7 downto 0);
signal ack_sreg                                 : std_logic_vector(9 downto 0);
signal rddata_reg                               : std_logic_vector(31 downto 0);
signal wrdata_reg                               : std_logic_vector(31 downto 0);
signal bwsel_reg                                : std_logic_vector(3 downto 0);
signal rwaddr_reg                               : std_logic_vector(1 downto 0);
signal ack_in_progress                          : std_logic      ;
signal wr_int                                   : std_logic      ;
signal rd_int                                   : std_logic      ;
signal bus_clock_int                            : std_logic      ;
signal allones                                  : std_logic_vector(31 downto 0);
signal allzeros                                 : std_logic_vector(31 downto 0);

begin
-- Some internal signals assignments. For (foreseen) compatibility with other bus standards.
  wrdata_reg <= wb_data_i;
  bwsel_reg <= wb_sel_i;
  bus_clock_int <= wb_clk_i;
  rd_int <= wb_cyc_i and (wb_stb_i and (not wb_we_i));
  wr_int <= wb_cyc_i and (wb_stb_i and wb_we_i);
  allones <= (others => '1');
  allzeros <= (others => '0');
-- 
-- Main register bank access process.
  process (bus_clock_int, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      ack_sreg <= "0000000000";
      ack_in_progress <= '0';
      rddata_reg <= "00000000000000000000000000000000";
      xldr_csr_start_int <= '0';
      xldr_csr_msbf_int <= '0';
      xldr_csr_swrst_int <= '0';
      xldr_csr_clkdiv_int <= "000000";
      xldr_fifo_wrreq_int <= '0';
    elsif rising_edge(bus_clock_int) then
-- advance the ACK generator shift register
      ack_sreg(8 downto 0) <= ack_sreg(9 downto 1);
      ack_sreg(9) <= '0';
      if (ack_in_progress = '1') then
        if (ack_sreg(0) = '1') then
          xldr_csr_start_int <= '0';
          xldr_csr_swrst_int <= '0';
          xldr_fifo_wrreq_int <= '0';
          ack_in_progress <= '0';
        else
        end if;
      else
        if ((wb_cyc_i = '1') and (wb_stb_i = '1')) then
          case rwaddr_reg(1 downto 0) is
          when "00" => 
            if (wb_we_i = '1') then
              xldr_csr_start_int <= wrdata_reg(0);
              rddata_reg(0) <= 'X';
              rddata_reg(1) <= 'X';
              rddata_reg(2) <= 'X';
              rddata_reg(3) <= 'X';
              rddata_reg(4) <= 'X';
              xldr_csr_msbf_int <= wrdata_reg(4);
              xldr_csr_swrst_int <= wrdata_reg(5);
              rddata_reg(5) <= 'X';
              xldr_csr_clkdiv_int <= wrdata_reg(13 downto 8);
            else
              rddata_reg(0) <= 'X';
              rddata_reg(1) <= regs_i.csr_done_i;
              rddata_reg(2) <= regs_i.csr_error_i;
              rddata_reg(3) <= regs_i.csr_busy_i;
              rddata_reg(4) <= xldr_csr_msbf_int;
              rddata_reg(5) <= 'X';
              rddata_reg(13 downto 8) <= xldr_csr_clkdiv_int;
              rddata_reg(6) <= 'X';
              rddata_reg(7) <= 'X';
              rddata_reg(14) <= 'X';
              rddata_reg(15) <= 'X';
              rddata_reg(16) <= 'X';
              rddata_reg(17) <= 'X';
              rddata_reg(18) <= 'X';
              rddata_reg(19) <= 'X';
              rddata_reg(20) <= 'X';
              rddata_reg(21) <= 'X';
              rddata_reg(22) <= 'X';
              rddata_reg(23) <= 'X';
              rddata_reg(24) <= 'X';
              rddata_reg(25) <= 'X';
              rddata_reg(26) <= 'X';
              rddata_reg(27) <= 'X';
              rddata_reg(28) <= 'X';
              rddata_reg(29) <= 'X';
              rddata_reg(30) <= 'X';
              rddata_reg(31) <= 'X';
            end if;
            ack_sreg(2) <= '1';
            ack_in_progress <= '1';
          when "01" => 
            if (wb_we_i = '1') then
              xldr_fifo_in_int(1 downto 0) <= wrdata_reg(1 downto 0);
              xldr_fifo_in_int(2) <= wrdata_reg(2);
            else
              rddata_reg(0) <= 'X';
              rddata_reg(1) <= 'X';
              rddata_reg(2) <= 'X';
              rddata_reg(3) <= 'X';
              rddata_reg(4) <= 'X';
              rddata_reg(5) <= 'X';
              rddata_reg(6) <= 'X';
              rddata_reg(7) <= 'X';
              rddata_reg(8) <= 'X';
              rddata_reg(9) <= 'X';
              rddata_reg(10) <= 'X';
              rddata_reg(11) <= 'X';
              rddata_reg(12) <= 'X';
              rddata_reg(13) <= 'X';
              rddata_reg(14) <= 'X';
              rddata_reg(15) <= 'X';
              rddata_reg(16) <= 'X';
              rddata_reg(17) <= 'X';
              rddata_reg(18) <= 'X';
              rddata_reg(19) <= 'X';
              rddata_reg(20) <= 'X';
              rddata_reg(21) <= 'X';
              rddata_reg(22) <= 'X';
              rddata_reg(23) <= 'X';
              rddata_reg(24) <= 'X';
              rddata_reg(25) <= 'X';
              rddata_reg(26) <= 'X';
              rddata_reg(27) <= 'X';
              rddata_reg(28) <= 'X';
              rddata_reg(29) <= 'X';
              rddata_reg(30) <= 'X';
              rddata_reg(31) <= 'X';
            end if;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "10" => 
            if (wb_we_i = '1') then
              xldr_fifo_in_int(34 downto 3) <= wrdata_reg(31 downto 0);
              xldr_fifo_wrreq_int <= '1';
            else
              rddata_reg(0) <= 'X';
              rddata_reg(1) <= 'X';
              rddata_reg(2) <= 'X';
              rddata_reg(3) <= 'X';
              rddata_reg(4) <= 'X';
              rddata_reg(5) <= 'X';
              rddata_reg(6) <= 'X';
              rddata_reg(7) <= 'X';
              rddata_reg(8) <= 'X';
              rddata_reg(9) <= 'X';
              rddata_reg(10) <= 'X';
              rddata_reg(11) <= 'X';
              rddata_reg(12) <= 'X';
              rddata_reg(13) <= 'X';
              rddata_reg(14) <= 'X';
              rddata_reg(15) <= 'X';
              rddata_reg(16) <= 'X';
              rddata_reg(17) <= 'X';
              rddata_reg(18) <= 'X';
              rddata_reg(19) <= 'X';
              rddata_reg(20) <= 'X';
              rddata_reg(21) <= 'X';
              rddata_reg(22) <= 'X';
              rddata_reg(23) <= 'X';
              rddata_reg(24) <= 'X';
              rddata_reg(25) <= 'X';
              rddata_reg(26) <= 'X';
              rddata_reg(27) <= 'X';
              rddata_reg(28) <= 'X';
              rddata_reg(29) <= 'X';
              rddata_reg(30) <= 'X';
              rddata_reg(31) <= 'X';
            end if;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "11" => 
            if (wb_we_i = '1') then
            else
              rddata_reg(16) <= xldr_fifo_full_int;
              rddata_reg(17) <= xldr_fifo_empty_int;
              rddata_reg(7 downto 0) <= xldr_fifo_usedw_int;
              rddata_reg(8) <= 'X';
              rddata_reg(9) <= 'X';
              rddata_reg(10) <= 'X';
              rddata_reg(11) <= 'X';
              rddata_reg(12) <= 'X';
              rddata_reg(13) <= 'X';
              rddata_reg(14) <= 'X';
              rddata_reg(15) <= 'X';
              rddata_reg(18) <= 'X';
              rddata_reg(19) <= 'X';
              rddata_reg(20) <= 'X';
              rddata_reg(21) <= 'X';
              rddata_reg(22) <= 'X';
              rddata_reg(23) <= 'X';
              rddata_reg(24) <= 'X';
              rddata_reg(25) <= 'X';
              rddata_reg(26) <= 'X';
              rddata_reg(27) <= 'X';
              rddata_reg(28) <= 'X';
              rddata_reg(29) <= 'X';
              rddata_reg(30) <= 'X';
              rddata_reg(31) <= 'X';
            end if;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when others =>
-- prevent the slave from hanging the bus on invalid address
            ack_in_progress <= '1';
            ack_sreg(0) <= '1';
          end case;
        end if;
      end if;
    end if;
  end process;
  
  
-- Drive the data output bus
  wb_data_o <= rddata_reg;
-- Start configuration
  process (bus_clock_int, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      xldr_csr_start_dly0 <= '0';
      regs_o.csr_start_o <= '0';
    elsif rising_edge(bus_clock_int) then
      xldr_csr_start_dly0 <= xldr_csr_start_int;
      regs_o.csr_start_o <= xldr_csr_start_int and (not xldr_csr_start_dly0);
    end if;
  end process;
  
  
-- Configuration done
-- Configuration error
-- Loader busy
-- Byte order select
  regs_o.csr_msbf_o <= xldr_csr_msbf_int;
-- Software resest
  process (bus_clock_int, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      xldr_csr_swrst_dly0 <= '0';
      regs_o.csr_swrst_o <= '0';
    elsif rising_edge(bus_clock_int) then
      xldr_csr_swrst_dly0 <= xldr_csr_swrst_int;
      regs_o.csr_swrst_o <= xldr_csr_swrst_int and (not xldr_csr_swrst_dly0);
    end if;
  end process;
  
  
-- Serial clock divider
  regs_o.csr_clkdiv_o <= xldr_csr_clkdiv_int;
-- extra code for reg/fifo/mem: Bitstream FIFO
  regs_o.fifo_xsize_o <= xldr_fifo_out_int(1 downto 0);
  regs_o.fifo_xlast_o <= xldr_fifo_out_int(2);
  regs_o.fifo_xdata_o <= xldr_fifo_out_int(34 downto 3);
  xldr_fifo_INST : wbgen2_fifo_sync
    generic map (
      g_size               => 256,
      g_width              => 35,
      g_usedw_size         => 8
    )
    port map (
      rd_req_i             => regs_i.fifo_rd_req_i,
      rd_full_o            => regs_o.fifo_rd_full_o,
      rd_empty_o           => regs_o.fifo_rd_empty_o,
      wr_full_o            => xldr_fifo_full_int,
      wr_empty_o           => xldr_fifo_empty_int,
      wr_usedw_o           => xldr_fifo_usedw_int,
      wr_req_i             => xldr_fifo_wrreq_int,
      clk_i                => bus_clock_int,
      wr_data_i            => xldr_fifo_in_int,
      rd_data_o            => xldr_fifo_out_int
    );
  
-- extra code for reg/fifo/mem: FIFO 'Bitstream FIFO' data input register 0
-- extra code for reg/fifo/mem: FIFO 'Bitstream FIFO' data input register 1
  rwaddr_reg <= wb_addr_i;
-- ACK signal generation. Just pass the LSB of ACK counter.
  wb_ack_o <= ack_sreg(0);
end syn;