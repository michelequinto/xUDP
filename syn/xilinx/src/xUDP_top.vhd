-- Filename            : xUDP.vhd
-- Description         : 
-- Author              : Michele Quinto
-- Created On          : Tue Oct 30 20:49:07 2016

-- $LastChangedBy$
-- $LastChangedRevision$
-- $LastChangedDate$
-- $URL$

------------------------------------------------------------------

-- Copyright 2016 Michele Quinto

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>
------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axi_types.all;
use work.ipv4_types.all;
use work.arp_types.all;
use work.xUDP_Common_pkg.all;

library UNISIM;
use UNISIM.Vcomponents.all;

ENTITY xUDP is 
  port(
    BRD_RESET_SW                : in  std_logic;        --board_reset_button
    BRD_CLK_P, BRD_CLK_N        : in  std_logic;        -- 100MHz_board_clk
    
    FPGA_LED	                : out std_logic_vector(3 downto 0);
    FPGA_PROG_B	        	: inout std_logic;
    DIP_GPIO	        	: in std_logic_vector(7 downto 0);
    
    MDIO_PAD	        	: inout std_logic;
    MDC		        	: out std_logic;
    PHY_RSTN	        	: out std_logic;
    PHY_LASI, PHY_INTA	        : in std_logic;
    PHY10G_RCK_P 		: in std_logic;
    PHY10G_RCK_N 		: in std_logic;
    --GTX I/Os for 10G External PHY
    FXTX_P 			: out std_logic_vector(3 downto 0);
    FXTX_N 			: out std_logic_vector(3 downto 0);
    FXRX_P 			: in std_logic_vector(3 downto 0);
    FXRX_N 			: in std_logic_vector(3 downto 0)
    );		
end xUDP;

ARCHITECTURE Structural of xUDP is
-------------------------------------------------------------------------------
-- Components declaration
-------------------------------------------------------------------------------

-- XAUI
component xaui_v10_4_block is
  generic (
    WRAPPER_SIM_GTXRESET_SPEEDUP : integer := 0
    );
  port (
    dclk             : in  std_logic;
    clk156           : in  std_logic;
    refclk           : in  std_logic;
    reset            : in  std_logic;
    reset156         : in  std_logic;
    txoutclk         : out std_logic;
    xgmii_txd        : in  std_logic_vector(63 downto 0);
    xgmii_txc        : in  std_logic_vector(7 downto 0);
    xgmii_rxd        : out std_logic_vector(63 downto 0);
    xgmii_rxc        : out std_logic_vector(7 downto 0);
    xaui_tx_l0_p     : out std_logic;
    xaui_tx_l0_n     : out std_logic;
    xaui_tx_l1_p     : out std_logic;
    xaui_tx_l1_n     : out std_logic;
    xaui_tx_l2_p     : out std_logic;
    xaui_tx_l2_n     : out std_logic;
    xaui_tx_l3_p     : out std_logic;
    xaui_tx_l3_n     : out std_logic;
    xaui_rx_l0_p     : in  std_logic;
    xaui_rx_l0_n     : in  std_logic;
    xaui_rx_l1_p     : in  std_logic;
    xaui_rx_l1_n     : in  std_logic;
    xaui_rx_l2_p     : in  std_logic;
    xaui_rx_l2_n     : in  std_logic;
    xaui_rx_l3_p     : in  std_logic;
    xaui_rx_l3_n     : in  std_logic;
    txlock           : out std_logic;
    signal_detect    : in  std_logic_vector(3 downto 0);
    align_status     : out std_logic;
    sync_status      : out std_logic_vector(3 downto 0);
    drp_addr         : in  std_logic_vector(7 downto 0);
    drp_en           : in  std_logic_vector(3 downto 0);
    drp_i            : in  std_logic_vector(15 downto 0);
    drp_o            : out std_logic_vector(63 downto 0);
    drp_rdy          : out std_logic_vector(3 downto 0);
    drp_we           : in  std_logic_vector(3 downto 0);
    mgt_tx_ready     : out std_logic;
    configuration_vector        : in  std_logic_vector(6 downto 0);
    status_vector               : out std_logic_vector(7 downto 0)
    );      
end component;  
--XAUI

--xge_mac
component xge_mac_axi is
  port(
    xgmii_rxd           : in std_logic_vector(63 downto 0);
    xgmii_rxc           : in std_logic_vector(7 downto 0);
    wb_we_i             : in std_logic;
    wb_stb_i            : in std_logic;
    wb_rst_i            : in std_logic;
    wb_dat_i            : in std_logic_vector(31 downto 0);
    wb_cyc_i            : in std_logic;
    wb_clk_i            : in std_logic;
    wb_adr_i            : in std_logic_vector(7 downto 0);
    reset_xgmii_tx_n    : in std_logic;
    reset_xgmii_rx_n    : in std_logic;
    reset_156m25_n      : in std_logic;
   
    clk_xgmii_tx        : in std_logic;
    clk_xgmii_rx        : in std_logic;
    clk_156m25          : in std_logic;          
    xgmii_txd           : out std_logic_vector(63 downto 0);
    xgmii_txc           : out std_logic_vector(7 downto 0);
    wb_int_o            : out std_logic;
    wb_dat_o            : out std_logic_vector(31 downto 0);
    wb_ack_o            : out std_logic;

    axi_rx              : out axi4_dvlk64_t;
    axi_tx              : in axi4_dvlk64_t;
    axi_tx_tready       : out std_logic;
    axi_rx_tready       : in std_logic
    );
end component;

component IPv4_Complete_nomac
  generic (
    CLOCK_FREQ			: integer := 156250000;					-- freq of data_in_clk -- needed to timout cntr
    ARP_TIMEOUT			: integer := 60;					-- ARP response timeout (s)
    ARP_MAX_PKT_TMO             : integer := 5;						-- # wrong nwk pkts received before set error
    MAX_ARP_ENTRIES 	        : integer := 255					-- max entries in the ARP store
    );
    port (
      -- IP Layer signals
      ip_tx_start			: in std_logic;
      ip_tx				: in ipv4_tx_type;
      ip_tx_result			: out std_logic_vector (1 downto 0);
      ip_tx_tready	                : out std_logic;									
      ip_rx_start			: out std_logic;
      ip_rx				: out ipv4_rx_type;
      ip_rx_tready                      : in std_logic;
      -- clock
      clk                               : in xUDP_CLOCK_T;
      udp_conf                          : in xUDP_CONIGURATION_T;
      control				: in udp_control_type;
      -- status signals
      arp_pkt_count			: out STD_LOGIC_VECTOR(7 downto 0);		-- count of arp pkts received
      ip_pkt_count			: out STD_LOGIC_VECTOR(7 downto 0);		-- number of IP pkts received for us
      mac_tx                            : out axi4_dvlk64_t;
      mac_rx                            : in axi4_dvlk64_t;
      mac_tx_tready                     : in std_logic;
      mac_rx_tready                     : out std_logic
      );
end component;

-------------------------------------------------------------------------------
-- Signal declaration
-------------------------------------------------------------------------------
--resets
signal reset                    : std_logic;          -- board reset

--clocks
signal clk100	 		: std_logic;
signal clk156			: std_logic;
signal txlock                   : std_logic;

--mdio
signal mdio_i			: std_logic;
signal mdio_o			: std_logic;
signal mdio_t			: std_logic;

-------------------------------------------------------------------------------
--XAUI
--configs & status
signal configuration_vector     : std_logic_vector(6 downto 0);
signal status_vector            : std_logic_vector(7 downto 0);
signal mgt_tx_ready             : std_logic;                    -- tx ready

--service clock
signal dclk                     : std_logic;                    -- dclk clock used by the GTP transceiver DRP

--xgmii
signal xgmii_txd                : std_logic_vector(63 downto 0) := (others => '0');
signal xgmii_txc                : std_logic_vector(7 downto 0)  := (others => '0');
signal xgmii_rxd                : std_logic_vector(63 downto 0) := (others => '0');
signal xgmii_rxc                : std_logic_vector(7 downto 0)  := (others => '0');

-------------------------------------------------------------------------------
--XGE_MAC
signal axi_rx                   : axi4_dvlk64_t;
signal axi_tx                   : axi4_dvlk64_t;
signal axi_tx_tready            : std_logic;
signal axi_rx_tready            : std_logic;
-------------------------------------------------------------------------------

BEGIN
  
reset <= not BRD_RESET_SW;              --reset connected only to push button for
                                        --the time being

MDIO_BLOCK : block

  signal brd_clk, mdio_clk, mdio_clk_locked, mdio_reset : std_logic;
  signal phy_reset : std_logic;
  signal phy_init_reset, phy_init_done : std_logic;
  
  signal mdio_t, mdio_i, mdio_o, mdc_o, mgmt_clk_locked, mgmt_clk_locked_i : std_logic;
  signal mdio_in_valid, mdio_out_valid, mdio_busy : std_logic;
  signal mdio_opcode : std_logic_vector(1 downto 0);
  signal mdio_data_in : std_logic_vector(15 downto 0);
  signal mdio_data_out : std_logic_vector(25 downto 0);
  signal mgmt_config : std_logic_vector(31 downto 0);
  signal mdio_cmd_read, mdio_cmd_write, mdio_read_data_valid, mdio_write_data_valid : std_logic;
  signal mdio_cmd_read_i, mdio_cmd_write_i : std_logic;
  signal mdio_cmd_address, mdio_cmd_data : std_logic_vector(15 downto 0);
  signal mdio_cmd_address_i, mdio_cmd_data_i : std_logic_vector(15 downto 0);
  signal mdio_cmd_prtdev_address : std_logic_vector(9 downto 0);
  signal mdio_cmd_prtdev_address_i : std_logic_vector(9 downto 0);
  signal mdio_opcode_c, mdio_opcode_i : std_logic_vector(1 downto 0);
  signal mdio_out_valid_c, mdio_out_valid_i : std_logic;
  signal mdio_data_out_c, mdio_data_out_i: std_logic_vector(25 downto 0);
  
  signal cmd_read_init, cmd_write_init : std_logic;
  signal cmd_prtdev_address_init : std_logic_vector(9 downto 0);
  signal cmd_address_init, cmd_data_init: std_logic_vector(15 downto 0);
  
begin

  phy_init_reset <= (not mdio_clk_locked);
  PHY_RSTN <= not phy_reset;
    
  vsc8486_init_inst : entity work.vsc8486_init PORT MAP(
    reset                       => phy_init_reset,
    clk                         => mdio_clk,
    phy_reset 			=> phy_reset,
    init_done 			=> phy_init_done,
    cmd_read 			=> cmd_read_init,
    cmd_write 			=> cmd_write_init,
    cmd_write_data_valid 	=> mdio_write_data_valid,
    cmd_prtdev_address 		=> cmd_prtdev_address_init,
    cmd_address			=> cmd_address_init,
    cmd_data 			=> cmd_data_init
    );
	
  mdio_cmd_read_i               <= cmd_read_init 		when phy_init_done = '0' else mdio_cmd_read;
  mdio_cmd_write_i              <= cmd_write_init 		when phy_init_done = '0' else mdio_cmd_write;
  mdio_cmd_prtdev_address_i     <= cmd_prtdev_address_init      when phy_init_done = '0' else mdio_cmd_prtdev_address;
  mdio_cmd_address_i 		<= cmd_address_init             when phy_init_done = '0' else mdio_cmd_address;
  mdio_cmd_data_i 		<= cmd_data_init 		when phy_init_done = '0' else mdio_cmd_data;
	
  mdio_ctrl_inst : entity work.mdio_ctrl PORT MAP(
    clk                 => mdio_clk,
    reset               => mdio_reset,
    cmd_read 		=> mdio_cmd_read_i,
    cmd_write 		=> mdio_cmd_write_i,
    prtdev_address 	=> mdio_cmd_prtdev_address_i,
    address 		=> mdio_cmd_address_i,
    data 		=> mdio_cmd_data_i,
    
    read_data_valid 	=> mdio_read_data_valid,
    write_data_valid 	=> mdio_write_data_valid,
    
    mdio_busy 		=> mdio_busy,
    mdio_opcode 	=> mdio_opcode_c,
    mdio_out_valid 	=> mdio_out_valid_c,
    mdio_data_out 	=> mdio_data_out_c
    );
	
  mdio_opcode 		<= mdio_opcode_c 	when mdio_write_data_valid = '1' else mdio_opcode_i;
  mdio_out_valid 	<= mdio_out_valid_c 	when mdio_write_data_valid = '1' else mdio_out_valid_i;
  mdio_data_out 	<= mdio_data_out_c 	when mdio_write_data_valid = '1' else mdio_data_out_i;
  
  mdio_inst : entity work.mdio PORT MAP(
    mgmt_clk 	        => mdio_clk,
    reset 		=> mdio_reset,
    busy 		=> mdio_busy,
    mdc 		=> mdc_o,
    mdio_t 		=> mdio_t,
    mdio_i 		=> mdio_i,
    mdio_o 		=> mdio_o,
    mdio_opcode 	=> mdio_opcode,
    mdio_in_valid 	=> mdio_in_valid,
    mdio_data_in 	=> mdio_data_in,
    mdio_out_valid 	=> mdio_out_valid,
    mdio_data_out 	=> mdio_data_out,
    mgmt_config 	=> mgmt_config
    );

  IOBUF_MDIO : IOBUF
    generic map ( DRIVE => 12,  SLEW => "SLOW")
    port map (
      O => mdio_i,    
      IO => MDIO_PAD,   
      I => mdio_o,     -- Buffer input
      T => mdio_t     -- 3-state enable input, high=input, low=output 
   );
  
  MDC <= mdc_o;

  clk_wiz_v3_3_0_inst : entity work.clk_wiz_v3_3_0 PORT MAP(
    CLK_IN1_P => BRD_CLK_P,
    CLK_IN1_N => BRD_CLK_N,       
    CLK_OUT1 => brd_clk,       
    RESET => reset,
    LOCKED => mdio_clk_locked
    );
  
  BUFR_inst : BUFR
    generic map (
      BUFR_DIVIDE => "4",   -- "BYPASS", "1", "2", "3", "4", "5", "6", "7", "8" 
      SIM_DEVICE => "VIRTEX6")
   port map (
      O => mdio_clk,    -- Clock buffer output
      CE => '1',        -- Clock enable input
      CLR => '0',       -- Clock buffer reset input
      I => brd_clk      -- Clock buffer input
   );

  mdio_reset <= reset or (not mdio_clk_locked);
  
end block;
  
XAUI_MANAGMENT_BLOCK : block
----------------------------------------------------------------------------
-- Signal declarations local to XAUI_MANAGMENT_BLOCK
----------------------------------------------------------------------------
signal txoutclk                 : std_logic;
signal clkfbout_txoutclk        : std_logic;
signal clkfbin_txoutclk         : std_logic;
signal clkout0                  : std_logic;
signal refclk                   : std_logic;
signal xgmii_txd_int            : std_logic_vector(63 downto 0) := (others => '0');
signal xgmii_txc_int            : std_logic_vector(7 downto 0)  := (others => '0');
signal xgmii_rxd_int            : std_logic_vector(63 downto 0) := (others => '0');
signal xgmii_rxc_int            : std_logic_vector(7 downto 0)  := (others => '0');
signal reset_156_r1             : std_logic;
signal reset_156_r2             : std_logic;
signal reset_156                : std_logic;
signal resetn_156               : std_logic;

signal signal_detect            : std_logic_vector(3 downto 0);      
signal align_status             : std_logic;
signal sync_status              : std_logic_vector(3 downto 0);

attribute ASYNC_REG                     : string;
attribute ASYNC_REG of reset_156_r1     : signal is "TRUE";

begin

xaui_inst : xaui_v10_4_block
  generic map (
    WRAPPER_SIM_GTXRESET_SPEEDUP => 1 --Does not affect hardware
    )
  port map (
    reset156         => reset_156,
    reset            => reset,
    dclk             => dclk,
    clk156           => clk156,
    refclk           => refclk,
    txoutclk         => txoutclk,
    xgmii_txd        => xgmii_txd_int,
    xgmii_txc        => xgmii_txc_int,
    xgmii_rxd        => xgmii_rxd_int,
    xgmii_rxc        => xgmii_rxc_int,
    xaui_tx_l0_p     => FXTX_P(0),
    xaui_tx_l0_n     => FXTX_N(0),
    xaui_tx_l1_p     => FXTX_P(1),
    xaui_tx_l1_n     => FXTX_N(1),
    xaui_tx_l2_p     => FXTX_P(2),
    xaui_tx_l2_n     => FXTX_N(2),
    xaui_tx_l3_p     => FXTX_P(3),
    xaui_tx_l3_n     => FXTX_N(3),
    xaui_rx_l0_p     => FXRX_P(0),
    xaui_rx_l0_n     => FXRX_N(0),
    xaui_rx_l1_p     => FXRX_P(1),
    xaui_rx_l1_n     => FXRX_N(1),
    xaui_rx_l2_p     => FXRX_P(2),
    xaui_rx_l2_n     => FXRX_N(2),
    xaui_rx_l3_p     => FXRX_P(3),
    xaui_rx_l3_n     => FXRX_N(3),
    txlock           => txlock,
    signal_detect    => signal_detect,
    align_status     => align_status,
    sync_status      => sync_status,
    drp_addr         => (others => '0'),
    drp_en           => (others => '0'),
    drp_i            => (others => '0'),
    drp_o            => open,
    drp_rdy          => open,
    drp_we           => (others => '0'),
    mgt_tx_ready     => mgt_tx_ready,
    configuration_vector => configuration_vector,
    status_vector        => status_vector);

-------------------------------------------------------------------------------
-- Clock management logic
-------------------------------------------------------------------------------

  
-- Differential Clock Module
phy10g_refclk_ibufds : IBUFDS_GTXE1
  port map ( I     => PHY10G_RCK_P,
             IB    => PHY10G_RCK_N,
             O     => refclk,
             CEB   => '0',
             ODIV2 => open );

mmcm_txoutclk : MMCM_BASE
  generic map (
    BANDWIDTH            => "HIGH",
    CLKFBOUT_MULT_F      => 6.000,
    CLKFBOUT_PHASE       => 0.000,
    CLKIN1_PERIOD        => 6.400,
    CLKOUT0_DIVIDE_F     => 6.000,
    CLKOUT0_DUTY_CYCLE   => 0.5,
    CLKOUT0_PHASE        => 0.000,
    CLKOUT4_CASCADE      => FALSE,
    CLOCK_HOLD           => FALSE,
    DIVCLK_DIVIDE        => 1,
    REF_JITTER1          => 0.010,
    STARTUP_WAIT         => FALSE )
  port map (
     CLKFBOUT    => clkfbout_txoutclk,
     CLKFBOUTB   => open,
     CLKOUT0     => clkout0,
     LOCKED      => open,
     CLKFBIN     => clkfbin_txoutclk,
     CLKIN1      => txoutclk,
     PWRDWN      => '0',
     RST         => reset
  );

-- Feedback clock buffer
txoutclk_fb_buf : BUFG
  port map( O => clkfbin_txoutclk,
            I => clkfbout_txoutclk);

-- Use the feedback clock for main system clock
clk156 <= clkfbin_txoutclk;


p_reset : process (clk156, reset)
begin
  if reset = '1' then
    reset_156_r1 <= '1';
    reset_156_r2 <= '1';
    reset_156    <= '1';
  elsif rising_edge(clk156) then
    reset_156_r1 <= not txlock;
    reset_156_r2 <= reset_156_r1;
    reset_156    <= reset_156_r2;
  end if;
end process;

resetn_156 <= not reset_156; 

-- Synthesise input and output registers
p_xgmii_tx_reg : process (clk156)
begin
  if rising_edge(clk156) then
    xgmii_txd_int <= xgmii_txd;
    xgmii_txc_int <= xgmii_txc;
  end if;
end process p_xgmii_tx_reg;

p_xgmii_rx_reg : process (clk156)
begin
  if rising_edge(clk156) then
    xgmii_rxd <= xgmii_rxd_int;
    xgmii_rxc <= xgmii_rxc_int;
  end if;
end process p_xgmii_rx_reg;

--to be checked in simulation
xaui_init_inst : entity work.xaui_init
  port map (
    rstn => resetn_156,
    clk156 => clk156,
    status_vector => status_vector,
    config_vector => configuration_vector );

-- The SIGNAL_DETECT signals are intended to be driven by an attached 10GBASE-LX4 optical module;
-- they signify that each of the four optical receivers is receiving illumination 
-- and is therefore not just putting out noise. If an optical module is not in use, this four-wire 
-- bus should be tied to 1111.

signal_detect <= (others => '1');

dclk <= clk156; 	-- GTP transceiver DRP bus not used for the time being

FPGA_LED(1) <= mgt_tx_ready and (not status_vector(0));									--! XAUI TX status
FPGA_LED(2) <= sync_status(0) and sync_status(1) and sync_status(2) and sync_status(3) and (not status_vector(1));      --! XAUI RX status
FPGA_LED(3) <= align_status;

end block XAUI_MANAGMENT_BLOCK;


XGE_MANAGMENT_BLOCK : block
-------------------------------------------------------------------------------
-- Signal declarations local to XGE_MANAGMENT_BLOCK
-------------------------------------------------------------------------------  
  signal xge_reset_n_r2 : std_logic := '0';
  signal xge_reset_n_r1 : std_logic := '0';
  signal xge_reset_n    : std_logic := '0';  -- reset for xge_mac

begin

  xge_mac_axi_inst : xge_mac_axi
    port map ( reset_xgmii_tx_n => xge_reset_n,
               reset_xgmii_rx_n => xge_reset_n,
               reset_156m25_n   => xge_reset_n,
               clk_xgmii_tx     => clk156,
               clk_xgmii_rx     => clk156,
               clk_156m25       => clk156,
                          
               xgmii_txd        => xgmii_txd,
               xgmii_txc        => xgmii_txc,
               xgmii_rxd        => xgmii_rxd,
               xgmii_rxc        => xgmii_rxc,
               
               wb_we_i          => '0',
               wb_stb_i         => '0',
               wb_rst_i         => '1',
               wb_cyc_i         => '0',
               wb_clk_i         => '0',
               wb_dat_i         => (others => '0'),
               wb_adr_i         => (others => '0'),
               
               axi_rx           => axi_rx,
               axi_tx           => axi_tx,
               axi_tx_tready    => axi_tx_tready,
               axi_rx_tready    => axi_rx_tready );

  xge_mac_reset : process(clk156, reset)
  begin
    if reset = '1' then
      xge_reset_n_r2 <= '0';
      xge_reset_n_r1 <= '0';
      xge_reset_n    <= '0';
    elsif rising_edge(clk156) then
      xge_reset_n_r2 <= mgt_tx_ready;
      xge_reset_n_r1 <= xge_reset_n_r2;
      xge_reset_n    <= xge_reset_n_r1;
    end if;
  end process;        

end block XGE_MANAGMENT_BLOCK;

IP: block
  signal control        : udp_control_type;
  signal ip_tx          : ipv4_tx_type;
  signal ip_rx_tready   : std_logic;
  signal reset          : std_logic;
  signal ip_tx_start    : std_logic := '0';

  signal udp_conf       : xUDP_CONIGURATION_T;
  signal clk            : xUDP_CLOCK_T;
  
begin  -- block IP
  ip_inst : IPv4_Complete_nomac
    port map (
      -- IP Layer signals
      ip_tx_start		=> ip_tx_start,
      ip_tx			=> ip_tx,
      ip_tx_result		=> open,
      ip_tx_tready	        => open,
      ip_rx_start		=> open,
      ip_rx			=> open,
      ip_rx_tready              => ip_rx_tready,
      clk                       => clk,
      udp_conf                  => udp_conf,
     
      control			=> control,
      -- status signals
      arp_pkt_count		=> open,
      ip_pkt_count		=> open,
      
      mac_rx           => axi_rx,
      mac_tx           => axi_tx,
      mac_tx_tready    => axi_tx_tready,
      mac_rx_tready    => axi_rx_tready );

  reset <= not BRD_RESET_SW;
  control.ip_controls.arp_controls.clear_cache <= '0';
  
  clk.tx_clk <= clk156;
  clk.rx_clk <= clk156;
  clk.tx_reset <= reset;
  clk.rx_reset <= reset;

  udp_conf.ip_address <= x"10000003";
  udp_conf.mac_address <= x"10_1f_74_e6_a4_0d";
  udp_conf.nwk_gateway <= x"10000000";
  udp_conf.nwk_mask <= x"FFFFFF00";

  ip_rx_tready <= '1';
  ip_tx.data.tvalid <= '0';
  
end block IP;
  

-------------------------------------------------------------------------------  
-- Board clock management logic
-------------------------------------------------------------------------------
brdclk_ibufds : IBUFDS
  port map ( I => BRD_CLK_P,
             IB => BRD_CLK_N,
             O => clk100 );

-------------------------------------------------------------------------------
-- Some IO Buffer
-------------------------------------------------------------------------------					
fpga_prog_b_iobuf : IOBUF
   generic map ( DRIVE => 12, SLEW => "SLOW")
   port map ( O => open,    
              IO => FPGA_PROG_B,   
              I => '0',
              T => '1' );

mdio_iobuf : IOBUF
   generic map ( DRIVE => 12, SLEW => "SLOW")
   port map ( O => mdio_i,    
              IO => MDIO_PAD,   
              I => mdio_o,
              T => mdio_t );

-------------------------------------------------------------------------------
-- Heartbeat generated form the PHY clock
-------------------------------------------------------------------------------
heartbeat : process(clk156, reset)
  variable hbCnt : unsigned(23 downto 0);
begin
  if reset = '1' then
    hbCnt := (others => '0');
  elsif rising_edge( clk156 ) then
    hbCnt := hbCnt + 1;
  end if;
  --drive LED0 heartbeat
  FPGA_LED(0) <= hbCnt(23);
end process;



-------------------------------------------------------------------------------
-- Drive MDIO temporary
-------------------------------------------------------------------------------
mdio_i <= '0';
mdio_o <= '1';
mdio_t <= '1';

END Structural;
