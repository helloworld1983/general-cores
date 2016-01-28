-------------------------------------------------------------------------------
-- Title      : Dynamic pulse width extender
-- Project    : General Cores library
-------------------------------------------------------------------------------
-- File       : gc_dyn_extend_pulse.vhd
-- Author     : Tomasz Wlostowski
-- Company    : CERN
-- Created    : 2009-09-01
-- Last update: 2016-01-28
-- Platform   : FPGA-generic
-- Standard   : VHDL '93
-------------------------------------------------------------------------------
-- Description:
-- Synchronous pulse extender. Generates a pulse of dynamically programmable
-- width upon detection of a rising edge in the input.
-------------------------------------------------------------------------------
--
-- Copyright (c) 2009-2011 CERN
--
-- This source file is free software; you can redistribute it
-- and/or modify it under the terms of the GNU Lesser General
-- Public License as published by the Free Software Foundation;
-- either version 2.1 of the License, or (at your option) any
-- later version.
--
-- This source is distributed in the hope that it will be
-- useful, but WITHOUT ANY WARRANTY; without even the implied
-- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
-- PURPOSE.  See the GNU Lesser General Public License for more
-- details.
--
-- You should have received a copy of the GNU Lesser General
-- Public License along with this source; if not, download it
-- from http://www.gnu.org/licenses/lgpl-2.1.html
--
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2009-09-01  0.9      twlostow        Created
-- 2011-04-18  1.0      twlostow        Added comments & header
-- 2016-01-28  1.1      vfinotti        Added dynamic length configuration
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;

library work;
use work.gencores_pkg.all;
use work.genram_pkg.all;

entity gc_dyn_extend_pulse is

  generic (
    -- Number of bits of len_i
    g_len_width : natural := 32
    );
  port (
    clk_i      : in  std_logic;
    rst_n_i    : in  std_logic;
    -- input pulse (synchronou to clk_i)
    pulse_i    : in  std_logic;
    -- extended output pulse length
    len_i      : in  unsigned(g_len_width-1 downto 0);
    -- extended output pulse
    extended_o : out std_logic := '0');
end gc_dyn_extend_pulse;

architecture rtl of gc_dyn_extend_pulse is

  signal cntr         : unsigned(g_len_width-1 downto 0);
  signal extended_int : std_logic;

begin  -- rtl

  extend : process (clk_i, rst_n_i)
  begin  -- process extend
    if rst_n_i = '0' then                   -- asynchronous reset (active low)
      extended_int <= '0';
      cntr         <= (others => '0');
    elsif clk_i'event and clk_i = '1' then  -- rising clock edge
      if(pulse_i = '1') then
        extended_int <= '1';
        cntr         <= len_i - 2;
      elsif cntr /= to_unsigned(0, cntr'length) then
        cntr <= cntr - 1;
      else
        extended_int <= '0';
      end if;
    end if;
  end process extend;

  extended_o <= pulse_i or extended_int;

end rtl;
