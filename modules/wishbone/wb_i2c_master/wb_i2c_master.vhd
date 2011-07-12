library ieee;
use ieee.std_logic_1164.all;

use work.wishbone_pkg.all;

entity wb_i2c_master is
  port (
    clk_sys_i : in std_logic;
    rst_n_i   : in std_logic;

    wb_adr_i : in  std_logic_vector(2 downto 0);
    wb_dat_i : in  std_logic_vector(31 downto 0);
    wb_dat_o : out std_logic_vector(31 downto 0);
    wb_sel_i : in  std_logic_vector(3 downto 0);
    wb_stb_i : in  std_logic;
    wb_cyc_i : in  std_logic;
    wb_we_i  : in  std_logic;
    wb_ack_o : out std_logic;
    wb_int_o : out std_logic;

    scl_pad_i    : in  std_logic;       -- i2c clock line input
    scl_pad_o    : out std_logic;       -- i2c clock line output
    scl_padoen_o : out std_logic;  -- i2c clock line output enable, active low
    sda_pad_i    : in  std_logic;       -- i2c data line input
    sda_pad_o    : out std_logic;       -- i2c data line output
    sda_padoen_o : out std_logic   -- i2c data line output enable, active low
    );
end wb_i2c_master;

architecture rtl of wb_i2c_master is
  component i2c_master_top
    generic (
      ARST_LVL : std_logic);
    port (
      wb_clk_i     : in  std_logic;
      wb_rst_i     : in  std_logic := '0';
      arst_i       : in  std_logic := not ARST_LVL;
      wb_adr_i     : in  std_logic_vector(2 downto 0);
      wb_dat_i     : in  std_logic_vector(7 downto 0);
      wb_dat_o     : out std_logic_vector(7 downto 0);
      wb_we_i      : in  std_logic;
      wb_stb_i     : in  std_logic;
      wb_cyc_i     : in  std_logic;
      wb_ack_o     : out std_logic;
      wb_inta_o    : out std_logic;
      scl_pad_i    : in  std_logic;
      scl_pad_o    : out std_logic;
      scl_padoen_o : out std_logic;
      sda_pad_i    : in  std_logic;
      sda_pad_o    : out std_logic;
      sda_padoen_o : out std_logic);
  end component;
begin  -- rtl



end rtl;

