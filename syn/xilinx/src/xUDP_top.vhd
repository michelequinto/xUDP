library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
component xge_mac is
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
    pkt_tx_val          : in std_logic;
    pkt_tx_sop          : in std_logic;
    pkt_tx_mod          : in std_logic_vector(2 downto 0);
    pkt_tx_eop          : in std_logic;
    pkt_tx_data         : in std_logic_vector(63 downto 0);
    pkt_rx_ren          : in std_logic;
    clk_xgmii_tx        : in std_logic;
    clk_xgmii_rx        : in std_logic;
    clk_156m25          : in std_logic;          
    xgmii_txd           : out std_logic_vector(63 downto 0);
    xgmii_txc           : out std_logic_vector(7 downto 0);
    wb_int_o            : out std_logic;
    wb_dat_o            : out std_logic_vector(31 downto 0);
    wb_ack_o            : out std_logic;
    pkt_tx_full         : out std_logic;
    pkt_rx_val          : out std_logic;
    pkt_rx_sop          : out std_logic;
    pkt_rx_mod          : out std_logic_vector(2 downto 0);
    pkt_rx_err          : out std_logic;
    pkt_rx_eop          : out std_logic;
    pkt_rx_data         : out std_logic_vector(63 downto 0);
    pkt_rx_avail        : out std_logic
    );
end component;
--xge_mac

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
--RX SIDE
signal pkt_rx_ren               : std_logic;
signal pkt_rx_val               : std_logic;
signal pkt_rx_sop               : std_logic;
signal pkt_rx_mod               : std_logic_vector(2 downto 0);
signal pkt_rx_err                : std_logic;
signal pkt_rx_eop               : std_logic;
signal pkt_rx_data              : std_logic_vector(63 downto 0);
signal pkt_rx_avail             : std_logic;
--TX SIDE
signal pkt_tx_full              : std_logic;
signal pkt_tx_val               : std_logic;
signal pkt_tx_sop               : std_logic;
signal pkt_tx_mod               : std_logic_vector(2 downto 0);
signal pkt_tx_eop               : std_logic;
signal pkt_tx_data              : std_logic_vector(63 downto 0);
-------------------------------------------------------------------------------

BEGIN
  
reset <= not BRD_RESET_SW;              --reset connected only to push button for
                                        --the time being
  
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

  xge_mac_inst : xge_mac
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
               
               pkt_tx_full 	=> pkt_tx_full,
               pkt_rx_val 	=> pkt_rx_val,
               pkt_rx_sop 	=> pkt_rx_sop,
               pkt_rx_mod 	=> pkt_rx_mod,
               pkt_rx_err 	=> pkt_rx_err,
               pkt_rx_eop 	=> pkt_rx_eop ,
               pkt_rx_data 	=> pkt_rx_data ,
               pkt_rx_avail 	=> pkt_rx_avail,
               pkt_tx_val 	=> pkt_tx_val,
               pkt_tx_sop 	=> pkt_tx_sop,
               pkt_tx_mod 	=> pkt_tx_mod,
               pkt_tx_eop 	=> pkt_tx_eop,
               pkt_tx_data 	=> pkt_tx_data,
               pkt_rx_ren 	=> pkt_rx_ren );

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
-- Drive the xge mac tx side - temporary
-------------------------------------------------------------------------------
pkt_tx_val <= '0';
pkt_tx_sop <= '0';
pkt_tx_mod <= (others => '0');
pkt_tx_eop <= '0';
pkt_tx_data <= (others => '0');

-------------------------------------------------------------------------------
-- Drive MDIO temporary
-------------------------------------------------------------------------------
mdio_i <= '0';
mdio_o <= '1';
mdio_t <= '1';

-------------------------------------------------------------------------------
-- Dump MAC rx side - temporarily
-------------------------------------------------------------------------------
pkt_rx_ren <= '1';

END Structural;
