-------------------------------------------------------------------------------
-- Title      :Block level wrapper
-- Project    : XAUI
-------------------------------------------------------------------------------
-- File       : xaui_v10_4_block.vhd
-------------------------------------------------------------------------------
-- Description: This file is a wrapper for the XAUI core. It contains the XAUI
-- core, the transceivers and some transceiver logic.
-------------------------------------------------------------------------------
--
-- (c) Copyright 2002 - 2010 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xaui_v10_4_block is
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
      configuration_vector : in  std_logic_vector(6 downto 0);
      status_vector        : out std_logic_vector(7 downto 0)
);
end xaui_v10_4_block;

library ieee;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

architecture wrapper of xaui_v10_4_block is

----------------------------------------------------------------------------
-- Component Declaration for the XAUI core.
----------------------------------------------------------------------------

   component xaui_v10_4
      port (
      reset            : in  std_logic;
      xgmii_txd        : in  std_logic_vector(63 downto 0);
      xgmii_txc        : in  std_logic_vector(7 downto 0);
      xgmii_rxd        : out std_logic_vector(63 downto 0);
      xgmii_rxc        : out std_logic_vector(7 downto 0);
      usrclk           : in  std_logic;
      mgt_txdata       : out std_logic_vector(63 downto 0);
      mgt_txcharisk    : out std_logic_vector(7 downto 0);
      mgt_rxdata       : in  std_logic_vector(63 downto 0);
      mgt_rxcharisk    : in  std_logic_vector(7 downto 0);
      mgt_codevalid    : in  std_logic_vector(7 downto 0);
      mgt_codecomma    : in  std_logic_vector(7 downto 0);
      mgt_enable_align : out std_logic_vector(3 downto 0);
      mgt_enchansync   : out std_logic;
      mgt_syncok       : in  std_logic_vector(3 downto 0);
      mgt_rxlock       : in  std_logic_vector(3 downto 0);
      mgt_loopback     : out std_logic;
      mgt_powerdown    : out std_logic;
      mgt_tx_reset     : in  std_logic_vector(3 downto 0);
      mgt_rx_reset     : in  std_logic_vector(3 downto 0);
      signal_detect    : in  std_logic_vector(3 downto 0);
      align_status     : out std_logic;
      sync_status      : out std_logic_vector(3 downto 0);
      configuration_vector : in  std_logic_vector(6 downto 0);
      status_vector    : out std_logic_vector(7 downto 0));
  end component;

 --------------------------------------------------------------------------
 -- Component declaration for the GTX transceiver container
 --------------------------------------------------------------------------

component xaui_v10_4_gtx_wrapper is
generic
(
    -- Simulation attributes
    WRAPPER_SIM_GTXRESET_SPEEDUP    : integer   := 0 -- Set to 1 to speed up sim reset
);
port
(

    --_________________________________________________________________________
    --_________________________________________________________________________
    --GTX0  (X0Y0)

    ------------------------ Loopback and Powerdown Ports ----------------------
    GTX0_LOOPBACK_IN                        : in   std_logic_vector(2 downto 0);
    GTX0_RXPOWERDOWN_IN                     : in   std_logic_vector(1 downto 0);
    GTX0_TXPOWERDOWN_IN                     : in   std_logic_vector(1 downto 0);
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    GTX0_RXCHARISCOMMA_OUT                  : out  std_logic_vector(1 downto 0);
    GTX0_RXCHARISK_OUT                      : out  std_logic_vector(1 downto 0);
    GTX0_RXDISPERR_OUT                      : out  std_logic_vector(1 downto 0);
    GTX0_RXNOTINTABLE_OUT                   : out  std_logic_vector(1 downto 0);
    ------------------- Receive Ports - Channel Bonding Ports ------------------
    GTX0_RXCHANBONDSEQ_OUT                  : out  std_logic;
    GTX0_RXCHBONDI_IN                       : in   std_logic_vector(3 downto 0);
    GTX0_RXCHBONDLEVEL_IN                   : in   std_logic_vector(2 downto 0);
    GTX0_RXCHBONDMASTER_IN                  : in   std_logic;
    GTX0_RXCHBONDO_OUT                      : out  std_logic_vector(3 downto 0);
    GTX0_RXCHBONDSLAVE_IN                   : in   std_logic;
    GTX0_RXENCHANSYNC_IN                    : in   std_logic;
    ------------------- Receive Ports - Clock Correction Ports -----------------
    GTX0_RXCLKCORCNT_OUT                    : out  std_logic_vector(2 downto 0);
    --------------- Receive Ports - Comma Detection and Alignment --------------
    GTX0_RXBYTEISALIGNED_OUT                : out  std_logic;
    GTX0_RXBYTEREALIGN_OUT                  : out  std_logic;
    GTX0_RXCOMMADET_OUT                     : out  std_logic;
    GTX0_RXENMCOMMAALIGN_IN                 : in   std_logic;
    GTX0_RXENPCOMMAALIGN_IN                 : in   std_logic;
   ----------------------- Receive Ports - PRBS Detection ---------------------
    GTX0_PRBSCNTRESET_IN                    : in   std_logic;
    GTX0_RXENPRBSTST_IN                     : in   std_logic_vector(2 downto 0);
    GTX0_RXPRBSERR_OUT                      : out  std_logic;    
    ------------------- Receive Ports - RX Data Path interface -----------------
    GTX0_RXDATA_OUT                         : out  std_logic_vector(15 downto 0);
    GTX0_RXRESET_IN                         : in   std_logic;
    GTX0_RXUSRCLK2_IN                       : in   std_logic;
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    GTX0_RXCDRRESET_IN                      : in   std_logic;
    GTX0_RXELECIDLE_OUT                     : out  std_logic;
    GTX0_RXEQMIX_IN                         : in   std_logic_vector(2 downto 0);    
    GTX0_RXN_IN                             : in   std_logic;
    GTX0_RXP_IN                             : in   std_logic;
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    GTX0_RXBUFRESET_IN                      : in   std_logic;
    GTX0_RXBUFSTATUS_OUT                    : out  std_logic_vector(2 downto 0);
    GTX0_RXCHANISALIGNED_OUT                : out  std_logic;
    GTX0_RXCHANREALIGN_OUT                  : out  std_logic;
    --------------- Receive Ports - RX Loss-of-sync State Machine --------------
    GTX0_RXLOSSOFSYNC_OUT                   : out  std_logic_vector(1 downto 0);
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    GTX0_GTXRXRESET_IN                      : in   std_logic;
    GTX0_MGTREFCLKRX_IN                     : in   std_logic;
    GTX0_PLLRXRESET_IN                      : in   std_logic;
    GTX0_RXPLLLKDET_OUT                     : out  std_logic;
    GTX0_RXRESETDONE_OUT                    : out  std_logic;
    ------------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
    GTX0_DADDR_IN                           : in   std_logic_vector(7 downto 0);
    GTX0_DCLK_IN                            : in   std_logic;
    GTX0_DEN_IN                             : in   std_logic;
    GTX0_DI_IN                              : in   std_logic_vector(15 downto 0);
    GTX0_DRDY_OUT                           : out  std_logic;
    GTX0_DRPDO_OUT                          : out  std_logic_vector(15 downto 0);
    GTX0_DWE_IN                             : in   std_logic;
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    GTX0_TXCHARISK_IN                       : in   std_logic_vector(1 downto 0);
    ------------------ Transmit Ports - TX Data Path interface -----------------
    GTX0_TXDATA_IN                          : in   std_logic_vector(15 downto 0);
    GTX0_TXOUTCLK_OUT                       : out  std_logic;
    GTX0_TXRESET_IN                         : in   std_logic;
    GTX0_TXUSRCLK2_IN                       : in   std_logic;
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    GTX0_TXDIFFCTRL_IN                      : in   std_logic_vector(3 downto 0);
    GTX0_TXN_OUT                            : out  std_logic;
    GTX0_TXP_OUT                            : out  std_logic;
    GTX0_TXPOSTEMPHASIS_IN                  : in   std_logic_vector(4 downto 0);
    --------------- Transmit Ports - TX Driver and OOB signalling --------------
    GTX0_TXPREEMPHASIS_IN                   : in   std_logic_vector(3 downto 0);
    -------- Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
    GTX0_TXDLYALIGNDISABLE_IN               : in   std_logic;
    GTX0_TXDLYALIGNMONENB_IN                : in   std_logic;
    GTX0_TXDLYALIGNMONITOR_OUT              : out  std_logic_vector(7 downto 0);
    GTX0_TXDLYALIGNRESET_IN                 : in   std_logic;
    GTX0_TXENPMAPHASEALIGN_IN               : in   std_logic;
    GTX0_TXPMASETPHASE_IN                   : in   std_logic;
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    GTX0_GTXTXRESET_IN                      : in   std_logic;
    GTX0_TXRESETDONE_OUT                    : out  std_logic;
    --------------------- Transmit Ports - TX PRBS Generator -------------------
    GTX0_TXENPRBSTST_IN                     : in   std_logic_vector(2 downto 0);
    GTX0_TXPRBSFORCEERR_IN                  : in   std_logic;    
    ----------------- Transmit Ports - TX Ports for PCI Express ----------------
    GTX0_TXELECIDLE_IN                      : in   std_logic;



    --_________________________________________________________________________
    --_________________________________________________________________________
    --GTX1  (X0Y1)

    ------------------------ Loopback and Powerdown Ports ----------------------
    GTX1_LOOPBACK_IN                        : in   std_logic_vector(2 downto 0);
    GTX1_RXPOWERDOWN_IN                     : in   std_logic_vector(1 downto 0);
    GTX1_TXPOWERDOWN_IN                     : in   std_logic_vector(1 downto 0);
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    GTX1_RXCHARISCOMMA_OUT                  : out  std_logic_vector(1 downto 0);
    GTX1_RXCHARISK_OUT                      : out  std_logic_vector(1 downto 0);
    GTX1_RXDISPERR_OUT                      : out  std_logic_vector(1 downto 0);
    GTX1_RXNOTINTABLE_OUT                   : out  std_logic_vector(1 downto 0);
    ------------------- Receive Ports - Channel Bonding Ports ------------------
    GTX1_RXCHANBONDSEQ_OUT                  : out  std_logic;
    GTX1_RXCHBONDI_IN                       : in   std_logic_vector(3 downto 0);
    GTX1_RXCHBONDLEVEL_IN                   : in   std_logic_vector(2 downto 0);
    GTX1_RXCHBONDMASTER_IN                  : in   std_logic;
    GTX1_RXCHBONDO_OUT                      : out  std_logic_vector(3 downto 0);
    GTX1_RXCHBONDSLAVE_IN                   : in   std_logic;
    GTX1_RXENCHANSYNC_IN                    : in   std_logic;
    ------------------- Receive Ports - Clock Correction Ports -----------------
    GTX1_RXCLKCORCNT_OUT                    : out  std_logic_vector(2 downto 0);
    --------------- Receive Ports - Comma Detection and Alignment --------------
    GTX1_RXBYTEISALIGNED_OUT                : out  std_logic;
    GTX1_RXBYTEREALIGN_OUT                  : out  std_logic;
    GTX1_RXCOMMADET_OUT                     : out  std_logic;
    GTX1_RXENMCOMMAALIGN_IN                 : in   std_logic;
    GTX1_RXENPCOMMAALIGN_IN                 : in   std_logic;
    ----------------------- Receive Ports - PRBS Detection ---------------------
    GTX1_PRBSCNTRESET_IN                    : in   std_logic;
    GTX1_RXENPRBSTST_IN                     : in   std_logic_vector(2 downto 0);
    GTX1_RXPRBSERR_OUT                      : out  std_logic;
    ------------------- Receive Ports - RX Data Path interface -----------------
    GTX1_RXDATA_OUT                         : out  std_logic_vector(15 downto 0);
    GTX1_RXRESET_IN                         : in   std_logic;
    GTX1_RXUSRCLK2_IN                       : in   std_logic;
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    GTX1_RXCDRRESET_IN                      : in   std_logic;
    GTX1_RXELECIDLE_OUT                     : out  std_logic;
    GTX1_RXEQMIX_IN                         : in   std_logic_vector(2 downto 0);
    GTX1_RXN_IN                             : in   std_logic;
    GTX1_RXP_IN                             : in   std_logic;
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    GTX1_RXBUFRESET_IN                      : in   std_logic;
    GTX1_RXBUFSTATUS_OUT                    : out  std_logic_vector(2 downto 0);
    GTX1_RXCHANISALIGNED_OUT                : out  std_logic;
    GTX1_RXCHANREALIGN_OUT                  : out  std_logic;
    --------------- Receive Ports - RX Loss-of-sync State Machine --------------
    GTX1_RXLOSSOFSYNC_OUT                   : out  std_logic_vector(1 downto 0);
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    GTX1_GTXRXRESET_IN                      : in   std_logic;
    GTX1_MGTREFCLKRX_IN                     : in   std_logic;
    GTX1_PLLRXRESET_IN                      : in   std_logic;
    GTX1_RXPLLLKDET_OUT                     : out  std_logic;
    GTX1_RXRESETDONE_OUT                    : out  std_logic;
    ------------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
    GTX1_DADDR_IN                           : in   std_logic_vector(7 downto 0);
    GTX1_DCLK_IN                            : in   std_logic;
    GTX1_DEN_IN                             : in   std_logic;
    GTX1_DI_IN                              : in   std_logic_vector(15 downto 0);
    GTX1_DRDY_OUT                           : out  std_logic;
    GTX1_DRPDO_OUT                          : out  std_logic_vector(15 downto 0);
    GTX1_DWE_IN                             : in   std_logic;
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    GTX1_TXCHARISK_IN                       : in   std_logic_vector(1 downto 0);
    ------------------ Transmit Ports - TX Data Path interface -----------------
    GTX1_TXDATA_IN                          : in   std_logic_vector(15 downto 0);
    GTX1_TXOUTCLK_OUT                       : out  std_logic;
    GTX1_TXRESET_IN                         : in   std_logic;
    GTX1_TXUSRCLK2_IN                       : in   std_logic;
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    GTX1_TXDIFFCTRL_IN                      : in   std_logic_vector(3 downto 0);
    GTX1_TXN_OUT                            : out  std_logic;
    GTX1_TXP_OUT                            : out  std_logic;
    GTX1_TXPOSTEMPHASIS_IN                  : in   std_logic_vector(4 downto 0);
    --------------- Transmit Ports - TX Driver and OOB signalling --------------
    GTX1_TXPREEMPHASIS_IN                   : in   std_logic_vector(3 downto 0);
    -------- Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
    GTX1_TXDLYALIGNDISABLE_IN               : in   std_logic;
    GTX1_TXDLYALIGNMONENB_IN                : in std_logic;
    GTX1_TXDLYALIGNMONITOR_OUT              : out  std_logic_vector(7 downto 0);
    GTX1_TXDLYALIGNRESET_IN                 : in   std_logic;
    GTX1_TXENPMAPHASEALIGN_IN               : in   std_logic;
    GTX1_TXPMASETPHASE_IN                   : in   std_logic;
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    GTX1_GTXTXRESET_IN                      : in   std_logic;
    GTX1_TXRESETDONE_OUT                    : out  std_logic;
    --------------------- Transmit Ports - TX PRBS Generator -------------------
    GTX1_TXENPRBSTST_IN                     : in   std_logic_vector(2 downto 0);
    GTX1_TXPRBSFORCEERR_IN                  : in   std_logic;    
    ----------------- Transmit Ports - TX Ports for PCI Express ----------------
    GTX1_TXELECIDLE_IN                      : in   std_logic;



    --_________________________________________________________________________
    --_________________________________________________________________________
    --GTX2  (X0Y2)

    ------------------------ Loopback and Powerdown Ports ----------------------
    GTX2_LOOPBACK_IN                        : in   std_logic_vector(2 downto 0);
    GTX2_RXPOWERDOWN_IN                     : in   std_logic_vector(1 downto 0);
    GTX2_TXPOWERDOWN_IN                     : in   std_logic_vector(1 downto 0);
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    GTX2_RXCHARISCOMMA_OUT                  : out  std_logic_vector(1 downto 0);
    GTX2_RXCHARISK_OUT                      : out  std_logic_vector(1 downto 0);
    GTX2_RXDISPERR_OUT                      : out  std_logic_vector(1 downto 0);
    GTX2_RXNOTINTABLE_OUT                   : out  std_logic_vector(1 downto 0);
    ------------------- Receive Ports - Channel Bonding Ports ------------------
    GTX2_RXCHANBONDSEQ_OUT                  : out  std_logic;
    GTX2_RXCHBONDI_IN                       : in   std_logic_vector(3 downto 0);
    GTX2_RXCHBONDLEVEL_IN                   : in   std_logic_vector(2 downto 0);
    GTX2_RXCHBONDMASTER_IN                  : in   std_logic;
    GTX2_RXCHBONDO_OUT                      : out  std_logic_vector(3 downto 0);
    GTX2_RXCHBONDSLAVE_IN                   : in   std_logic;
    GTX2_RXENCHANSYNC_IN                    : in   std_logic;
    ------------------- Receive Ports - Clock Correction Ports -----------------
    GTX2_RXCLKCORCNT_OUT                    : out  std_logic_vector(2 downto 0);
    --------------- Receive Ports - Comma Detection and Alignment --------------
    GTX2_RXBYTEISALIGNED_OUT                : out  std_logic;
    GTX2_RXBYTEREALIGN_OUT                  : out  std_logic;
    GTX2_RXCOMMADET_OUT                     : out  std_logic;
    GTX2_RXENMCOMMAALIGN_IN                 : in   std_logic;
    GTX2_RXENPCOMMAALIGN_IN                 : in   std_logic;
    ----------------------- Receive Ports - PRBS Detection ---------------------
    GTX2_PRBSCNTRESET_IN                    : in   std_logic;
    GTX2_RXENPRBSTST_IN                     : in   std_logic_vector(2 downto 0);
    GTX2_RXPRBSERR_OUT                      : out  std_logic;
    ------------------- Receive Ports - RX Data Path interface -----------------
    GTX2_RXDATA_OUT                         : out  std_logic_vector(15 downto 0);
    GTX2_RXRESET_IN                         : in   std_logic;
    GTX2_RXUSRCLK2_IN                       : in   std_logic;
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    GTX2_RXCDRRESET_IN                      : in   std_logic;
    GTX2_RXELECIDLE_OUT                     : out  std_logic;
    GTX2_RXEQMIX_IN                         : in   std_logic_vector(2 downto 0);
    GTX2_RXN_IN                             : in   std_logic;
    GTX2_RXP_IN                             : in   std_logic;
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    GTX2_RXBUFRESET_IN                      : in   std_logic;
    GTX2_RXBUFSTATUS_OUT                    : out  std_logic_vector(2 downto 0);
    GTX2_RXCHANISALIGNED_OUT                : out  std_logic;
    GTX2_RXCHANREALIGN_OUT                  : out  std_logic;
    --------------- Receive Ports - RX Loss-of-sync State Machine --------------
    GTX2_RXLOSSOFSYNC_OUT                   : out  std_logic_vector(1 downto 0);
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    GTX2_GTXRXRESET_IN                      : in   std_logic;
    GTX2_MGTREFCLKRX_IN                     : in   std_logic;
    GTX2_PLLRXRESET_IN                      : in   std_logic;
    GTX2_RXPLLLKDET_OUT                     : out  std_logic;
    GTX2_RXRESETDONE_OUT                    : out  std_logic;
    ------------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
    GTX2_DADDR_IN                           : in   std_logic_vector(7 downto 0);
    GTX2_DCLK_IN                            : in   std_logic;
    GTX2_DEN_IN                             : in   std_logic;
    GTX2_DI_IN                              : in   std_logic_vector(15 downto 0);
    GTX2_DRDY_OUT                           : out  std_logic;
    GTX2_DRPDO_OUT                          : out  std_logic_vector(15 downto 0);
    GTX2_DWE_IN                             : in   std_logic;
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    GTX2_TXCHARISK_IN                       : in   std_logic_vector(1 downto 0);
    ------------------ Transmit Ports - TX Data Path interface -----------------
    GTX2_TXDATA_IN                          : in   std_logic_vector(15 downto 0);
    GTX2_TXOUTCLK_OUT                       : out  std_logic;
    GTX2_TXRESET_IN                         : in   std_logic;
    GTX2_TXUSRCLK2_IN                       : in   std_logic;
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    GTX2_TXDIFFCTRL_IN                      : in   std_logic_vector(3 downto 0);
    GTX2_TXN_OUT                            : out  std_logic;
    GTX2_TXP_OUT                            : out  std_logic;
    GTX2_TXPOSTEMPHASIS_IN                  : in   std_logic_vector(4 downto 0);
    --------------- Transmit Ports - TX Driver and OOB signalling --------------
    GTX2_TXPREEMPHASIS_IN                   : in   std_logic_vector(3 downto 0);
    -------- Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
    GTX2_TXDLYALIGNDISABLE_IN               : in   std_logic;
    GTX2_TXDLYALIGNMONENB_IN                : in std_logic;
    GTX2_TXDLYALIGNMONITOR_OUT              : out  std_logic_vector(7 downto 0);
    GTX2_TXDLYALIGNRESET_IN                 : in   std_logic;
    GTX2_TXENPMAPHASEALIGN_IN               : in   std_logic;
    GTX2_TXPMASETPHASE_IN                   : in   std_logic;
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    GTX2_GTXTXRESET_IN                      : in   std_logic;
    GTX2_TXRESETDONE_OUT                    : out  std_logic;
    --------------------- Transmit Ports - TX PRBS Generator -------------------
    GTX2_TXENPRBSTST_IN                     : in   std_logic_vector(2 downto 0);
    GTX2_TXPRBSFORCEERR_IN                  : in   std_logic;
    ----------------- Transmit Ports - TX Ports for PCI Express ----------------
    GTX2_TXELECIDLE_IN                      : in   std_logic;


    --_________________________________________________________________________
    --_________________________________________________________________________
    --GTX3  (X0Y3)

    ------------------------ Loopback and Powerdown Ports ----------------------
    GTX3_LOOPBACK_IN                        : in   std_logic_vector(2 downto 0);
    GTX3_RXPOWERDOWN_IN                     : in   std_logic_vector(1 downto 0);
    GTX3_TXPOWERDOWN_IN                     : in   std_logic_vector(1 downto 0);
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    GTX3_RXCHARISCOMMA_OUT                  : out  std_logic_vector(1 downto 0);
    GTX3_RXCHARISK_OUT                      : out  std_logic_vector(1 downto 0);
    GTX3_RXDISPERR_OUT                      : out  std_logic_vector(1 downto 0);
    GTX3_RXNOTINTABLE_OUT                   : out  std_logic_vector(1 downto 0);
    ------------------- Receive Ports - Channel Bonding Ports ------------------
    GTX3_RXCHANBONDSEQ_OUT                  : out  std_logic;
    GTX3_RXCHBONDI_IN                       : in   std_logic_vector(3 downto 0);
    GTX3_RXCHBONDLEVEL_IN                   : in   std_logic_vector(2 downto 0);
    GTX3_RXCHBONDMASTER_IN                  : in   std_logic;
    GTX3_RXCHBONDO_OUT                      : out  std_logic_vector(3 downto 0);
    GTX3_RXCHBONDSLAVE_IN                   : in   std_logic;
    GTX3_RXENCHANSYNC_IN                    : in   std_logic;
    ------------------- Receive Ports - Clock Correction Ports -----------------
    GTX3_RXCLKCORCNT_OUT                    : out  std_logic_vector(2 downto 0);
    --------------- Receive Ports - Comma Detection and Alignment --------------
    GTX3_RXBYTEISALIGNED_OUT                : out  std_logic;
    GTX3_RXBYTEREALIGN_OUT                  : out  std_logic;
    GTX3_RXCOMMADET_OUT                     : out  std_logic;
    GTX3_RXENMCOMMAALIGN_IN                 : in   std_logic;
    GTX3_RXENPCOMMAALIGN_IN                 : in   std_logic;
     ----------------------- Receive Ports - PRBS Detection ---------------------
    GTX3_PRBSCNTRESET_IN                    : in   std_logic;
    GTX3_RXENPRBSTST_IN                     : in   std_logic_vector(2 downto 0);
    GTX3_RXPRBSERR_OUT                      : out  std_logic;
    ------------------- Receive Ports - RX Data Path interface -----------------
    GTX3_RXDATA_OUT                         : out  std_logic_vector(15 downto 0);
    GTX3_RXRESET_IN                         : in   std_logic;
    GTX3_RXUSRCLK2_IN                       : in   std_logic;
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    GTX3_RXCDRRESET_IN                      : in   std_logic;
    GTX3_RXELECIDLE_OUT                     : out  std_logic;
    GTX3_RXEQMIX_IN                         : in   std_logic_vector(2 downto 0);
    GTX3_RXN_IN                             : in   std_logic;
    GTX3_RXP_IN                             : in   std_logic;
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    GTX3_RXBUFRESET_IN                      : in   std_logic;
    GTX3_RXBUFSTATUS_OUT                    : out  std_logic_vector(2 downto 0);
    GTX3_RXCHANISALIGNED_OUT                : out  std_logic;
    GTX3_RXCHANREALIGN_OUT                  : out  std_logic;
    --------------- Receive Ports - RX Loss-of-sync State Machine --------------
    GTX3_RXLOSSOFSYNC_OUT                   : out  std_logic_vector(1 downto 0);
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    GTX3_GTXRXRESET_IN                      : in   std_logic;
    GTX3_MGTREFCLKRX_IN                     : in   std_logic;
    GTX3_PLLRXRESET_IN                      : in   std_logic;
    GTX3_RXPLLLKDET_OUT                     : out  std_logic;
    GTX3_RXRESETDONE_OUT                    : out  std_logic;
    ------------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
    GTX3_DADDR_IN                           : in   std_logic_vector(7 downto 0);
    GTX3_DCLK_IN                            : in   std_logic;
    GTX3_DEN_IN                             : in   std_logic;
    GTX3_DI_IN                              : in   std_logic_vector(15 downto 0);
    GTX3_DRDY_OUT                           : out  std_logic;
    GTX3_DRPDO_OUT                          : out  std_logic_vector(15 downto 0);
    GTX3_DWE_IN                             : in   std_logic;
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    GTX3_TXCHARISK_IN                       : in   std_logic_vector(1 downto 0);
    ------------------ Transmit Ports - TX Data Path interface -----------------
    GTX3_TXDATA_IN                          : in   std_logic_vector(15 downto 0);
    GTX3_TXOUTCLK_OUT                       : out  std_logic;
    GTX3_TXRESET_IN                         : in   std_logic;
    GTX3_TXUSRCLK2_IN                       : in   std_logic;
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    GTX3_TXDIFFCTRL_IN                      : in   std_logic_vector(3 downto 0);
    GTX3_TXN_OUT                            : out  std_logic;
    GTX3_TXP_OUT                            : out  std_logic;
    GTX3_TXPOSTEMPHASIS_IN                  : in   std_logic_vector(4 downto 0);
    --------------- Transmit Ports - TX Driver and OOB signalling --------------
    GTX3_TXPREEMPHASIS_IN                   : in   std_logic_vector(3 downto 0);
    -------- Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
    GTX3_TXDLYALIGNDISABLE_IN               : in   std_logic;
    GTX3_TXDLYALIGNMONENB_IN                : in std_logic;
    GTX3_TXDLYALIGNMONITOR_OUT              : out  std_logic_vector(7 downto 0);
    GTX3_TXDLYALIGNRESET_IN                 : in   std_logic;
    GTX3_TXENPMAPHASEALIGN_IN               : in   std_logic;
    GTX3_TXPMASETPHASE_IN                   : in   std_logic;
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    GTX3_GTXTXRESET_IN                      : in   std_logic;
    GTX3_TXRESETDONE_OUT                    : out  std_logic;
    --------------------- Transmit Ports - TX PRBS Generator -------------------
    GTX3_TXENPRBSTST_IN                     : in   std_logic_vector(2 downto 0);
    GTX3_TXPRBSFORCEERR_IN                  : in   std_logic;
    ----------------- Transmit Ports - TX Ports for PCI Express ----------------
    GTX3_TXELECIDLE_IN                      : in   std_logic
);
end component;

component xaui_v10_4_tx_sync is
generic
(
    SIM_TXPMASETPHASE_SPEEDUP   : integer:=1
); 
port
(
    TXENPMAPHASEALIGN : out std_logic;
    TXPMASETPHASE     : out std_logic;
    TXDLYALIGNDISABLE : out std_logic;
    TXDLYALIGNRESET   : out std_logic;
    SYNC_DONE         : out std_logic;
    USER_CLK          : in  std_logic;
    RESET             : in  std_logic
);
end component;

  component xaui_v10_4_chanbond_monitor is
  port
  (
    CLK                     :  in  std_logic;
    RST                     :  in  std_logic;
    COMMA_ALIGN_DONE        :  in  std_logic;
    CORE_ENCHANSYNC         :  in  std_logic;
    CHANBOND_DONE           :  in  std_logic;
    RXRESET                 :  out std_logic
  );
  end component;

----------------------------------------------------------------------------
-- Signal declarations.
---------------------------------------------------------------------------
  signal clk156_reset_txsync_r1 : std_logic;
  signal clk156_reset_txsync_r2 : std_logic;
  signal clk156_reset_txsync_r3 : std_logic;
  signal GT_TXOUTCLK        : std_logic;
  signal mgt_txdata         : std_logic_vector(63 downto 0);
  signal mgt_txcharisk      : std_logic_vector(7 downto 0);
  signal mgt_rxdata         : std_logic_vector(63 downto 0);
  signal mgt_rxcharisk      : std_logic_vector(7 downto 0);
  signal mgt_enable_align   : std_logic_vector(3 downto 0);
  signal mgt_enchansync     : std_logic;
  signal mgt_syncok         : std_logic_vector(3 downto 0);
  signal mgt_rxdisperr      : std_logic_vector(7 downto 0);
  signal mgt_rxnotintable   : std_logic_vector(7 downto 0);
  signal mgt_reset_terms    : std_logic;
  signal mgt_codevalid      : std_logic_vector(7 downto 0);
  signal mgt_rxchariscomma  : std_logic_vector(7 downto 0);
  signal mgt_rxdata_reg       : std_logic_vector(63 downto 0);
  signal mgt_rxcharisk_reg0 : std_logic := '0';
  signal mgt_rxcharisk_reg1 : std_logic := '0';
  signal mgt_rxcharisk_reg2 : std_logic := '0';
  signal mgt_rxcharisk_reg3 : std_logic := '0';
  signal mgt_rxcharisk_reg4 : std_logic := '0';
  signal mgt_rxcharisk_reg5 : std_logic := '0';
  signal mgt_rxcharisk_reg6 : std_logic := '0';
  signal mgt_rxcharisk_reg7 : std_logic := '0';
  signal mgt_rxcharisk_reg : std_logic_vector(7 downto 0);
  signal mgt_rxlock_reg       : std_logic_vector(3 downto 0);
  signal mgt_rxlock_r1        : std_logic_vector(3 downto 0);
  signal mgt_rxnotintable_reg0 : std_logic := '1';
  signal mgt_rxnotintable_reg1 : std_logic := '1';
  signal mgt_rxnotintable_reg2 : std_logic := '1';
  signal mgt_rxnotintable_reg3 : std_logic := '1';
  signal mgt_rxnotintable_reg4 : std_logic := '1';
  signal mgt_rxnotintable_reg5 : std_logic := '1';
  signal mgt_rxnotintable_reg6 : std_logic := '1';
  signal mgt_rxnotintable_reg7 : std_logic := '1';
  signal mgt_rxdisperr_reg0    : std_logic := '1';
  signal mgt_rxdisperr_reg1    : std_logic := '1';
  signal mgt_rxdisperr_reg2    : std_logic := '1';
  signal mgt_rxdisperr_reg3    : std_logic := '1';
  signal mgt_rxdisperr_reg4    : std_logic := '1';
  signal mgt_rxdisperr_reg5    : std_logic := '1';
  signal mgt_rxdisperr_reg6    : std_logic := '1';
  signal mgt_rxdisperr_reg7    : std_logic := '1';
  signal mgt_codecomma_reg0    : std_logic := '0';
  signal mgt_codecomma_reg1    : std_logic := '0';
  signal mgt_codecomma_reg2    : std_logic := '0';
  signal mgt_codecomma_reg3    : std_logic := '0';
  signal mgt_codecomma_reg4    : std_logic := '0';
  signal mgt_codecomma_reg5    : std_logic := '0';
  signal mgt_codecomma_reg6    : std_logic := '0';
  signal mgt_codecomma_reg7    : std_logic := '0';
  signal mgt_codecomma_reg     : std_logic_vector(7 downto 0);
  signal mgt_rxcdr_reset       : std_logic_vector(3 downto 0) := "0000";
  signal mgt_rx_reset          : std_logic;
  signal mgt_rxlock            : std_logic_vector(3 downto 0);
  signal mgt_tx_fault          : std_logic_vector(3 downto 0);
  signal mgt_loopback          : std_logic;
  signal mgt_powerdown         : std_logic := '0';
  signal mgt_powerdown_2       : std_logic_vector(1 downto 0);
  signal mgt_powerdown_r       : std_logic := '0';
  signal mgt_powerdown_falling : std_logic := '0';
  signal mgt_plllocked         : std_logic_vector(3 downto 0);
  signal mgt_rxresetdone       : std_logic_vector(3 downto 0);
  signal mgt_rxbuferr          : std_logic_vector(3 downto 0);
  signal mgt_rxbufstatus       : std_logic_vector(11 downto 0);
  signal mgt_rxbufstatus_reg   : std_logic_vector(11 downto 0) := (others => '0');  
  signal mgt_rxlossofsync      : std_logic_vector(7 downto 0);
  signal mgt_txresetdone       : std_logic_vector(3 downto 0);
  signal loopback_int          : std_logic_vector(2 downto 0);
  signal lock                  : std_logic;
  signal cbm_rx_reset          : std_logic;
  signal reset_txsync          : std_logic;

  -------------------------- Channel Bonding Wires ---------------------------
  signal    gtx0_rxchbondo_i : std_logic_vector(3 downto 0);
  signal    gtx1_rxchbondo_i : std_logic_vector(3 downto 0);
  signal    gtx2_rxchbondo_i : std_logic_vector(3 downto 0);
  signal    gtx3_rxchbondo_i : std_logic_vector(3 downto 0);

  --CHANBOND_MONITOR signals
  signal mgt_rxchanisaligned : std_logic_vector(3 downto 0);
  signal comma_align_done    : std_logic;
  signal chanbond_done       : std_logic;
  signal sync_status_i       : std_logic_vector(3 downto 0);
  signal align_status_i      : std_logic;

  signal mgt_txenpmaphasealign : std_logic;
  signal mgt_txpmasetphase   : std_logic;
  signal mgt_txdlyaligndisable : std_logic;
  signal mgt_txdlyalignreset : std_logic;
  signal mgt_txreset         : std_logic;
  signal resetdone           : std_logic;
  signal tx_sync_done        : std_logic;

  --ASYNC_REG attributes
  attribute ASYNC_REG : string;
  attribute ASYNC_REG of mgt_rxlock_r1 : signal is "TRUE";
  attribute ASYNC_REG of clk156_reset_txsync_r1  : signal is "TRUE";

----------------------------------------------------------------------------
-- Function declarations.
---------------------------------------------------------------------------
function IsBufError (bufStatus:std_logic_vector(2 downto 0)) return std_logic is
  variable result : std_logic;
begin
  if bufStatus = "101" or bufStatus = "110" then
    result := '1';
  else
    result := '0';
  end if;
  return result;
end;

begin

  xaui_core : xaui_v10_4
    port map (
      reset            => reset156,
      xgmii_txd        => xgmii_txd,
      xgmii_txc        => xgmii_txc,
      xgmii_rxd        => xgmii_rxd,
      xgmii_rxc        => xgmii_rxc,
      usrclk           => clk156,
      mgt_txdata       => mgt_txdata,
      mgt_txcharisk    => mgt_txcharisk,
      mgt_rxdata       => mgt_rxdata_reg,
      mgt_rxcharisk    => mgt_rxcharisk_reg,
      mgt_codevalid    => mgt_codevalid,
      mgt_codecomma    => mgt_codecomma_reg,
      mgt_enable_align => mgt_enable_align,
      mgt_enchansync   => mgt_enchansync,
      mgt_syncok       => mgt_syncok,
      mgt_rxlock       => mgt_rxlock_reg,
      mgt_loopback     => mgt_loopback,
      mgt_powerdown    => mgt_powerdown,
      mgt_tx_reset     => mgt_tx_fault,
      mgt_rx_reset     => mgt_rxcdr_reset,
      signal_detect    => signal_detect,
      align_status     => align_status_i,
      sync_status      => sync_status_i,
      configuration_vector => configuration_vector,
      status_vector        => status_vector);

  ----------------------------------------------------------------------
   -- Transceiver instances
   gtx_wrapper_i : xaui_v10_4_gtx_wrapper
    generic map (
      WRAPPER_SIM_GTXRESET_SPEEDUP => WRAPPER_SIM_GTXRESET_SPEEDUP
    )
    port map (
    --_________________________________________________________________________
    --_________________________________________________________________________
    --GTX0  (X0Y0)

    ------------------------ Loopback and Powerdown Ports ----------------------
    GTX0_LOOPBACK_IN                        => loopback_int,
    GTX0_RXPOWERDOWN_IN                     => mgt_powerdown_2,
    GTX0_TXPOWERDOWN_IN                     => mgt_powerdown_2,
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    GTX0_RXCHARISCOMMA_OUT                  => mgt_rxchariscomma(1 downto 0),
    GTX0_RXCHARISK_OUT                      => mgt_rxcharisk(1 downto 0),
    GTX0_RXDISPERR_OUT                      => mgt_rxdisperr(1 downto 0),
    GTX0_RXNOTINTABLE_OUT                   => mgt_rxnotintable(1 downto 0),
    ------------------- Receive Ports - Channel Bonding Ports ------------------
    GTX0_RXCHANBONDSEQ_OUT                  => open,
    GTX0_RXCHBONDI_IN                       => gtx1_rxchbondo_i,
    GTX0_RXCHBONDLEVEL_IN                   => "000",
    GTX0_RXCHBONDMASTER_IN                  => '0',
    GTX0_RXCHBONDO_OUT                      => gtx0_rxchbondo_i,
    GTX0_RXCHBONDSLAVE_IN                   => '1',
    GTX0_RXENCHANSYNC_IN                    => mgt_enchansync,
    ------------------- Receive Ports - Clock Correction Ports -----------------
    GTX0_RXCLKCORCNT_OUT                    => open,
    --------------- Receive Ports - Comma Detection and Alignment --------------
    GTX0_RXBYTEISALIGNED_OUT                => open,
    GTX0_RXBYTEREALIGN_OUT                  => open,
    GTX0_RXCOMMADET_OUT                     => open,
    GTX0_RXENMCOMMAALIGN_IN                 => mgt_enable_align(0),
    GTX0_RXENPCOMMAALIGN_IN                 => mgt_enable_align(0),
   ----------------------- Receive Ports - PRBS Detection ---------------------
    GTX0_PRBSCNTRESET_IN                    => '0',
    GTX0_RXENPRBSTST_IN                     => "000",
    GTX0_RXPRBSERR_OUT                      => open,      
    ------------------- Receive Ports - RX Data Path interface -----------------
    GTX0_RXDATA_OUT                         => mgt_rxdata(15 downto 0),
    GTX0_RXRESET_IN                         => mgt_rx_reset,
    GTX0_RXUSRCLK2_IN                       => clk156,
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    GTX0_RXCDRRESET_IN                      => mgt_rxcdr_reset(0),
    GTX0_RXELECIDLE_OUT                     => open,
    GTX0_RXEQMIX_IN                         => "111",    
    GTX0_RXN_IN                             => xaui_rx_l0_n,
    GTX0_RXP_IN                             => xaui_rx_l0_p,
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    GTX0_RXBUFRESET_IN                      => '0',
    GTX0_RXBUFSTATUS_OUT                    => mgt_rxbufstatus(2 downto 0),
    GTX0_RXCHANISALIGNED_OUT                => mgt_rxchanisaligned(0),
    GTX0_RXCHANREALIGN_OUT                  => open,
    --------------- Receive Ports - RX Loss-of-sync State Machine --------------
    GTX0_RXLOSSOFSYNC_OUT                   => mgt_rxlossofsync(1 downto 0),
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    GTX0_GTXRXRESET_IN                      => mgt_reset_terms,
    GTX0_MGTREFCLKRX_IN                     => refclk,
    GTX0_PLLRXRESET_IN                      => '0',
    GTX0_RXPLLLKDET_OUT                     => mgt_plllocked(0),
    GTX0_RXRESETDONE_OUT                    => mgt_rxresetdone(0),
    ------------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
    GTX0_DADDR_IN                           => drp_addr,
    GTX0_DCLK_IN                            => dclk,
    GTX0_DEN_IN                             => drp_en(0),
    GTX0_DI_IN                              => drp_i,
    GTX0_DRDY_OUT                           => drp_rdy(0),
    GTX0_DRPDO_OUT                          => drp_o(15 downto 0),
    GTX0_DWE_IN                             => drp_we(0),
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    GTX0_TXCHARISK_IN                       => mgt_txcharisk(1 downto 0),
    ------------------ Transmit Ports - TX Data Path interface -----------------
    GTX0_TXDATA_IN                          => mgt_txdata(15 downto 0),
    GTX0_TXOUTCLK_OUT                       => GT_TXOUTCLK,
    GTX0_TXRESET_IN                         => mgt_txreset,
    GTX0_TXUSRCLK2_IN                       => clk156,
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    GTX0_TXDIFFCTRL_IN                      => "1010",
    GTX0_TXN_OUT                            => xaui_tx_l0_n,
    GTX0_TXP_OUT                            => xaui_tx_l0_p,
    GTX0_TXPOSTEMPHASIS_IN                  => "00000",    
    --------------- Transmit Ports - TX Driver and OOB signalling --------------
    GTX0_TXPREEMPHASIS_IN                   => "0000",    
    -------- Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
    GTX0_TXDLYALIGNDISABLE_IN               => mgt_txdlyaligndisable,
    GTX0_TXDLYALIGNMONENB_IN               => '0',
    GTX0_TXDLYALIGNMONITOR_OUT              => open,    
    GTX0_TXDLYALIGNRESET_IN                 => mgt_txdlyalignreset,
    GTX0_TXENPMAPHASEALIGN_IN               => mgt_txenpmaphasealign,
    GTX0_TXPMASETPHASE_IN                   => mgt_txpmasetphase,
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    GTX0_GTXTXRESET_IN                      => mgt_reset_terms,
    GTX0_TXRESETDONE_OUT                    => mgt_txresetdone(0),
    --------------------- Transmit Ports - TX PRBS Generator -------------------
    GTX0_TXENPRBSTST_IN                     => "000",
    GTX0_TXPRBSFORCEERR_IN                  => '0',
    ----------------- Transmit Ports - TX Ports for PCI Express ----------------
    GTX0_TXELECIDLE_IN                      => mgt_powerdown_r,

    --GTX1  (X0Y1)
    ------------------------ Loopback and Powerdown Ports ----------------------
    GTX1_LOOPBACK_IN                        => loopback_int,
    GTX1_RXPOWERDOWN_IN                     => mgt_powerdown_2,
    GTX1_TXPOWERDOWN_IN                     => mgt_powerdown_2,
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    GTX1_RXCHARISCOMMA_OUT                  => mgt_rxchariscomma(3 downto 2),
    GTX1_RXCHARISK_OUT                      => mgt_rxcharisk(3 downto 2),
    GTX1_RXDISPERR_OUT                      => mgt_rxdisperr(3 downto 2),
    GTX1_RXNOTINTABLE_OUT                   => mgt_rxnotintable(3 downto 2),
    ------------------- Receive Ports - Channel Bonding Ports ------------------
    GTX1_RXCHANBONDSEQ_OUT                  => open,
    GTX1_RXCHBONDI_IN                       => gtx2_rxchbondo_i,
    GTX1_RXCHBONDLEVEL_IN                   => "001",
    GTX1_RXCHBONDMASTER_IN                  => '0',
    GTX1_RXCHBONDO_OUT                      => gtx1_rxchbondo_i,
    GTX1_RXCHBONDSLAVE_IN                   => '1',
    GTX1_RXENCHANSYNC_IN                    => mgt_enchansync,
    ------------------- Receive Ports - Clock Correction Ports -----------------
    GTX1_RXCLKCORCNT_OUT                    => open,
    --------------- Receive Ports - Comma Detection and Alignment --------------
    GTX1_RXBYTEISALIGNED_OUT                => open,
    GTX1_RXBYTEREALIGN_OUT                  => open,
    GTX1_RXCOMMADET_OUT                     => open,
    GTX1_RXENMCOMMAALIGN_IN                 => mgt_enable_align(1),
    GTX1_RXENPCOMMAALIGN_IN                 => mgt_enable_align(1),
   ----------------------- Receive Ports - PRBS Detection ---------------------
    GTX1_PRBSCNTRESET_IN                    => '0',
    GTX1_RXENPRBSTST_IN                     => "000",
    GTX1_RXPRBSERR_OUT                      => open,         
    ------------------- Receive Ports - RX Data Path interface -----------------
    GTX1_RXDATA_OUT                         => mgt_rxdata(31 downto 16),
    GTX1_RXRESET_IN                         => mgt_rx_reset,
    GTX1_RXUSRCLK2_IN                       => clk156,
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    GTX1_RXCDRRESET_IN                      => mgt_rxcdr_reset(1),
    GTX1_RXELECIDLE_OUT                     => open,
    GTX1_RXEQMIX_IN                         => "111",
    GTX1_RXN_IN                             => xaui_rx_l1_n,
    GTX1_RXP_IN                             => xaui_rx_l1_p,
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    GTX1_RXBUFRESET_IN                      => '0',
    GTX1_RXBUFSTATUS_OUT                    => mgt_rxbufstatus(5 downto 3),
    GTX1_RXCHANISALIGNED_OUT                => mgt_rxchanisaligned(1),
    GTX1_RXCHANREALIGN_OUT                  => open,
    --------------- Receive Ports - RX Loss-of-sync State Machine --------------
    GTX1_RXLOSSOFSYNC_OUT                   => mgt_rxlossofsync(3 downto 2),
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    GTX1_GTXRXRESET_IN                      => mgt_reset_terms,
    GTX1_MGTREFCLKRX_IN                     => refclk,
    GTX1_PLLRXRESET_IN                      => '0',
    GTX1_RXPLLLKDET_OUT                     => mgt_plllocked(1),
    GTX1_RXRESETDONE_OUT                    => mgt_rxresetdone(1),
    ------------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
    GTX1_DADDR_IN                           => drp_addr,
    GTX1_DCLK_IN                            => dclk,
    GTX1_DEN_IN                             => drp_en(1),
    GTX1_DI_IN                              => drp_i,
    GTX1_DRDY_OUT                           => drp_rdy(1),
    GTX1_DRPDO_OUT                          => drp_o(31 downto 16),
    GTX1_DWE_IN                             => drp_we(1),
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    GTX1_TXCHARISK_IN                       => mgt_txcharisk(3 downto 2),
    ------------------ Transmit Ports - TX Data Path interface -----------------
    GTX1_TXDATA_IN                          => mgt_txdata(31 downto 16),
    GTX1_TXOUTCLK_OUT                       => open,
    GTX1_TXRESET_IN                         => mgt_txreset,
    GTX1_TXUSRCLK2_IN                       => clk156,
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    GTX1_TXDIFFCTRL_IN                      => "1010",    
    GTX1_TXN_OUT                            => xaui_tx_l1_n,
    GTX1_TXP_OUT                            => xaui_tx_l1_p,
    GTX1_TXPOSTEMPHASIS_IN                  => "00000",    
    --------------- Transmit Ports - TX Driver and OOB signalling --------------
    GTX1_TXPREEMPHASIS_IN                   => "0000",    
    -------- Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
    GTX1_TXDLYALIGNDISABLE_IN               => mgt_txdlyaligndisable,
    GTX1_TXDLYALIGNMONENB_IN               => '0',
    GTX1_TXDLYALIGNMONITOR_OUT              => open,
    GTX1_TXDLYALIGNRESET_IN                 => mgt_txdlyalignreset,
    GTX1_TXENPMAPHASEALIGN_IN               => mgt_txenpmaphasealign,
    GTX1_TXPMASETPHASE_IN                   => mgt_txpmasetphase,
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    GTX1_GTXTXRESET_IN                      => mgt_reset_terms,
    GTX1_TXRESETDONE_OUT                    => mgt_txresetdone(1),
    --------------------- Transmit Ports - TX PRBS Generator -------------------
    GTX1_TXENPRBSTST_IN                     => "000",
    GTX1_TXPRBSFORCEERR_IN                  => '0',    
    ----------------- Transmit Ports - TX Ports for PCI Express ----------------
    GTX1_TXELECIDLE_IN                      => mgt_powerdown_r,
    --GTX2  (X0Y2)

    ------------------------ Loopback and Powerdown Ports ----------------------
    GTX2_LOOPBACK_IN                        => loopback_int,
    GTX2_RXPOWERDOWN_IN                     => mgt_powerdown_2,
    GTX2_TXPOWERDOWN_IN                     => mgt_powerdown_2,
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    GTX2_RXCHARISCOMMA_OUT                  => mgt_rxchariscomma(5 downto 4),
    GTX2_RXCHARISK_OUT                      => mgt_rxcharisk(5 downto 4),
    GTX2_RXDISPERR_OUT                      => mgt_rxdisperr(5 downto 4),
    GTX2_RXNOTINTABLE_OUT                   => mgt_rxnotintable(5 downto 4),
    ------------------- Receive Ports - Channel Bonding Ports ------------------
    GTX2_RXCHANBONDSEQ_OUT                  => open,
    GTX2_RXCHBONDI_IN                       => "0000",
    GTX2_RXCHBONDLEVEL_IN                   => "010",
    GTX2_RXCHBONDMASTER_IN                  => '1',
    GTX2_RXCHBONDO_OUT                      => gtx2_rxchbondo_i,
    GTX2_RXCHBONDSLAVE_IN                   => '0',
    GTX2_RXENCHANSYNC_IN                    => mgt_enchansync,
    ------------------- Receive Ports - Clock Correction Ports -----------------
    GTX2_RXCLKCORCNT_OUT                    => open,
    --------------- Receive Ports - Comma Detection and Alignment --------------
    GTX2_RXBYTEISALIGNED_OUT                => open,
    GTX2_RXBYTEREALIGN_OUT                  => open,
    GTX2_RXCOMMADET_OUT                     => open,
    GTX2_RXENMCOMMAALIGN_IN                 => mgt_enable_align(2),
    GTX2_RXENPCOMMAALIGN_IN                 => mgt_enable_align(2),
   ----------------------- Receive Ports - PRBS Detection ---------------------
    GTX2_PRBSCNTRESET_IN                    => '0',
    GTX2_RXENPRBSTST_IN                     => "000",
    GTX2_RXPRBSERR_OUT                      => open,         
    ------------------- Receive Ports - RX Data Path interface -----------------
    GTX2_RXDATA_OUT                         => mgt_rxdata(47 downto 32),
    GTX2_RXRESET_IN                         => mgt_rx_reset,
    GTX2_RXUSRCLK2_IN                       => clk156,
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    GTX2_RXCDRRESET_IN                      => mgt_rxcdr_reset(2),
    GTX2_RXELECIDLE_OUT                     => open,
    GTX2_RXEQMIX_IN                         => "111",        
    GTX2_RXN_IN                             => xaui_rx_l2_n,
    GTX2_RXP_IN                             => xaui_rx_l2_p,
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    GTX2_RXBUFRESET_IN                      => '0',
    GTX2_RXBUFSTATUS_OUT                    => mgt_rxbufstatus(8 downto 6),
    GTX2_RXCHANISALIGNED_OUT                => mgt_rxchanisaligned(2),
    GTX2_RXCHANREALIGN_OUT                  => open,
    --------------- Receive Ports - RX Loss-of-sync State Machine --------------
    GTX2_RXLOSSOFSYNC_OUT                   => mgt_rxlossofsync(5 downto 4),
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    GTX2_GTXRXRESET_IN                      => mgt_reset_terms,
    GTX2_MGTREFCLKRX_IN                     => refclk,
    GTX2_PLLRXRESET_IN                      => '0',
    GTX2_RXPLLLKDET_OUT                     => mgt_plllocked(2),
    GTX2_RXRESETDONE_OUT                    => mgt_rxresetdone(2),
    ------------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
    GTX2_DADDR_IN                           => drp_addr,
    GTX2_DCLK_IN                            => dclk,
    GTX2_DEN_IN                             => drp_en(2),
    GTX2_DI_IN                              => drp_i,
    GTX2_DRDY_OUT                           => drp_rdy(2),
    GTX2_DRPDO_OUT                          => drp_o(47 downto 32),
    GTX2_DWE_IN                             => drp_we(2),
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    GTX2_TXCHARISK_IN                       => mgt_txcharisk(5 downto 4),
    ------------------ Transmit Ports - TX Data Path interface -----------------
    GTX2_TXDATA_IN                          => mgt_txdata(47 downto 32),
    GTX2_TXOUTCLK_OUT                       => open,
    GTX2_TXRESET_IN                         => mgt_txreset,
    GTX2_TXUSRCLK2_IN                       => clk156,
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    GTX2_TXDIFFCTRL_IN                      => "1010",    
    GTX2_TXN_OUT                            => xaui_tx_l2_n,
    GTX2_TXP_OUT                            => xaui_tx_l2_p,
    GTX2_TXPOSTEMPHASIS_IN                  => "00000",    
    --------------- Transmit Ports - TX Driver and OOB signalling --------------
    GTX2_TXPREEMPHASIS_IN                   => "0000",    
    -------- Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
    GTX2_TXDLYALIGNDISABLE_IN               => mgt_txdlyaligndisable,
    GTX2_TXDLYALIGNMONENB_IN               => '0',
    GTX2_TXDLYALIGNMONITOR_OUT              => open,
    GTX2_TXDLYALIGNRESET_IN                 => mgt_txdlyalignreset,
    GTX2_TXENPMAPHASEALIGN_IN               => mgt_txenpmaphasealign,
    GTX2_TXPMASETPHASE_IN                   => mgt_txpmasetphase,
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    GTX2_GTXTXRESET_IN                      => mgt_reset_terms,
    GTX2_TXRESETDONE_OUT                    => mgt_txresetdone(2),
    --------------------- Transmit Ports - TX PRBS Generator -------------------
    GTX2_TXENPRBSTST_IN                     => "000",
    GTX2_TXPRBSFORCEERR_IN                  => '0',    
    ----------------- Transmit Ports - TX Ports for PCI Express ----------------
    GTX2_TXELECIDLE_IN                      => mgt_powerdown_r,

    --GTX3  (X0Y3)
    ------------------------ Loopback and Powerdown Ports ----------------------
    GTX3_LOOPBACK_IN                        => loopback_int,
    GTX3_RXPOWERDOWN_IN                     => mgt_powerdown_2,
    GTX3_TXPOWERDOWN_IN                     => mgt_powerdown_2,
    ----------------------- Receive Ports - 8b10b Decoder ----------------------
    GTX3_RXCHARISCOMMA_OUT                  => mgt_rxchariscomma(7 downto 6),
    GTX3_RXCHARISK_OUT                      => mgt_rxcharisk(7 downto 6),
    GTX3_RXDISPERR_OUT                      => mgt_rxdisperr(7 downto 6),
    GTX3_RXNOTINTABLE_OUT                   => mgt_rxnotintable(7 downto 6),
    ------------------- Receive Ports - Channel Bonding Ports ------------------
    GTX3_RXCHANBONDSEQ_OUT                  => open,
    GTX3_RXCHBONDI_IN                       => gtx2_rxchbondo_i,
    GTX3_RXCHBONDLEVEL_IN                   => "001",
    GTX3_RXCHBONDMASTER_IN                  => '0',
    GTX3_RXCHBONDO_OUT                      => gtx3_rxchbondo_i,
    GTX3_RXCHBONDSLAVE_IN                   => '1',
    GTX3_RXENCHANSYNC_IN                    => mgt_enchansync,
    ------------------- Receive Ports - Clock Correction Ports -----------------
    GTX3_RXCLKCORCNT_OUT                    => open,
    --------------- Receive Ports - Comma Detection and Alignment --------------
    GTX3_RXBYTEISALIGNED_OUT                => open,
    GTX3_RXBYTEREALIGN_OUT                  => open,
    GTX3_RXCOMMADET_OUT                     => open,
    GTX3_RXENMCOMMAALIGN_IN                 => mgt_enable_align(3),
    GTX3_RXENPCOMMAALIGN_IN                 => mgt_enable_align(3),
   ----------------------- Receive Ports - PRBS Detection ---------------------
    GTX3_PRBSCNTRESET_IN                    => '0',
    GTX3_RXENPRBSTST_IN                     => "000",
    GTX3_RXPRBSERR_OUT                      => open,         
    ------------------- Receive Ports - RX Data Path interface -----------------
    GTX3_RXDATA_OUT                         => mgt_rxdata(63 downto 48),
    GTX3_RXRESET_IN                         => mgt_rx_reset,
    GTX3_RXUSRCLK2_IN                       => clk156,
    ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
    GTX3_RXCDRRESET_IN                      => mgt_rxcdr_reset(3),
    GTX3_RXELECIDLE_OUT                     => open,
    GTX3_RXEQMIX_IN                         => "111",        
    GTX3_RXN_IN                             => xaui_rx_l3_n,
    GTX3_RXP_IN                             => xaui_rx_l3_p,
    -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
    GTX3_RXBUFRESET_IN                      => '0',
    GTX3_RXBUFSTATUS_OUT                    => mgt_rxbufstatus(11 downto 9),
    GTX3_RXCHANISALIGNED_OUT                => mgt_rxchanisaligned(3),
    GTX3_RXCHANREALIGN_OUT                  => open,
    --------------- Receive Ports - RX Loss-of-sync State Machine --------------
    GTX3_RXLOSSOFSYNC_OUT                   => mgt_rxlossofsync(7 downto 6),
    ------------------------ Receive Ports - RX PLL Ports ----------------------
    GTX3_GTXRXRESET_IN                      => mgt_reset_terms,
    GTX3_MGTREFCLKRX_IN                     => refclk,
    GTX3_PLLRXRESET_IN                      => '0',
    GTX3_RXPLLLKDET_OUT                     => mgt_plllocked(3),
    GTX3_RXRESETDONE_OUT                    => mgt_rxresetdone(3),
    ------------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
    GTX3_DADDR_IN                           => drp_addr,
    GTX3_DCLK_IN                            => dclk,
    GTX3_DEN_IN                             => drp_en(3),
    GTX3_DI_IN                              => drp_i,
    GTX3_DRDY_OUT                           => drp_rdy(3),
    GTX3_DRPDO_OUT                          => drp_o(63 downto 48),
    GTX3_DWE_IN                             => drp_we(3),
    ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
    GTX3_TXCHARISK_IN                       => mgt_txcharisk(7 downto 6),
    ------------------ Transmit Ports - TX Data Path interface -----------------
    GTX3_TXDATA_IN                          => mgt_txdata(63 downto 48),
    GTX3_TXOUTCLK_OUT                       => open,
    GTX3_TXRESET_IN                         => mgt_txreset,
    GTX3_TXUSRCLK2_IN                       => clk156,
    ---------------- Transmit Ports - TX Driver and OOB signaling --------------
    GTX3_TXDIFFCTRL_IN                      => "1010",    
    GTX3_TXN_OUT                            => xaui_tx_l3_n,
    GTX3_TXP_OUT                            => xaui_tx_l3_p,
    GTX3_TXPOSTEMPHASIS_IN                  => "00000",    
    --------------- Transmit Ports - TX Driver and OOB signalling --------------
    GTX3_TXPREEMPHASIS_IN                   => "0000",    
    -------- Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
    GTX3_TXDLYALIGNDISABLE_IN               => mgt_txdlyaligndisable,
    GTX3_TXDLYALIGNMONENB_IN               => '0',
    GTX3_TXDLYALIGNMONITOR_OUT              => open,
    GTX3_TXDLYALIGNRESET_IN                 => mgt_txdlyalignreset,
    GTX3_TXENPMAPHASEALIGN_IN               => mgt_txenpmaphasealign,
    GTX3_TXPMASETPHASE_IN                   => mgt_txpmasetphase,
    ----------------------- Transmit Ports - TX PLL Ports ----------------------
    GTX3_GTXTXRESET_IN                      => mgt_reset_terms,
    GTX3_TXRESETDONE_OUT                    => mgt_txresetdone(3),
    --------------------- Transmit Ports - TX PRBS Generator -------------------
    GTX3_TXENPRBSTST_IN                     => "000",
    GTX3_TXPRBSFORCEERR_IN                  => '0',    
    ----------------- Transmit Ports - TX Ports for PCI Express ----------------
    GTX3_TXELECIDLE_IN                      => mgt_powerdown_r

  );

  mgt_codecomma_reg <= (mgt_codecomma_reg7 & mgt_codecomma_reg6 & mgt_codecomma_reg5 & mgt_codecomma_reg4 & mgt_codecomma_reg3 & mgt_codecomma_reg2 & mgt_codecomma_reg1 & mgt_codecomma_reg0);
  mgt_rxcharisk_reg <= (mgt_rxcharisk_reg7 & mgt_rxcharisk_reg6 & mgt_rxcharisk_reg5 & mgt_rxcharisk_reg4 & mgt_rxcharisk_reg3 & mgt_rxcharisk_reg2 & mgt_rxcharisk_reg1 & mgt_rxcharisk_reg0);

  txoutclk <= GT_TXOUTCLK;
  sync_status      <= sync_status_i;
  align_status     <= align_status_i;
  mgt_codevalid <= not ((mgt_rxnotintable_reg7 & mgt_rxnotintable_reg6 & mgt_rxnotintable_reg5 & mgt_rxnotintable_reg4 & mgt_rxnotintable_reg3 & mgt_rxnotintable_reg2 & mgt_rxnotintable_reg1 & mgt_rxnotintable_reg0) or (mgt_rxdisperr_reg7 & mgt_rxdisperr_reg6 & mgt_rxdisperr_reg5 & mgt_rxdisperr_reg4 & mgt_rxdisperr_reg3 & mgt_rxdisperr_reg2 & mgt_rxdisperr_reg1 & mgt_rxdisperr_reg0));
  loopback_int  <= "010" when mgt_loopback = '1' else "000";
  mgt_syncok <= not (mgt_rxlossofsync(7) & mgt_rxlossofsync(5) & mgt_rxlossofsync(3) & mgt_rxlossofsync(1));
  mgt_powerdown_2 <= mgt_powerdown_r & mgt_powerdown_r;

  -- Detect falling edge of mgt_powerdown
  p_powerdown_r : process(clk156)
  begin
    if rising_edge(clk156) then
      mgt_powerdown_r <= mgt_powerdown;
    end if;
  end process;

  p_powerdown_falling : process(clk156)
  begin
    if rising_edge(clk156) then
      if mgt_powerdown_r = '1' and mgt_powerdown = '0' then
        mgt_powerdown_falling <= '1';
      else
        mgt_powerdown_falling <= '0';
      end if;
    end if;
  end process;

  RXBUFERR_P: process (mgt_rxbufstatus)
  begin
    for i in 0 to 3 loop
      mgt_rxbuferr(i) <= IsBufError(mgt_rxbufstatus_reg(i*3+2 downto i*3));
    end loop;
  end process;

  reset_txsync <= mgt_reset_terms or (not lock);

  p_reset_txsync_sync : process(clk156, reset_txsync)
  begin
    if (reset_txsync = '1') then
      clk156_reset_txsync_r1 <= '1';
      clk156_reset_txsync_r2 <= '1';
      clk156_reset_txsync_r3 <= '1';
    elsif rising_edge(clk156) then
      if ( mgt_txresetdone = "1111" ) then
        clk156_reset_txsync_r1 <= '0';
        clk156_reset_txsync_r2 <= clk156_reset_txsync_r1;
        clk156_reset_txsync_r3 <= clk156_reset_txsync_r2;
      end if;
    end if;
  end process;

  -- reset logic
  mgt_txreset <= reset156;
  mgt_rx_reset <= cbm_rx_reset or reset156;
  resetdone  <= '1' when mgt_txresetdone = "1111" and mgt_rxresetdone = "1111"
                else '0';
  lock       <= '1' when mgt_plllocked = "1111" else '0';
  txlock     <= lock;
  mgt_rxlock <= mgt_plllocked;

  tx_sync_i :  xaui_v10_4_tx_sync
    generic map (
    SIM_TXPMASETPHASE_SPEEDUP   => 0
    )   
    port map (
      USER_CLK          => clk156,
      RESET             => clk156_reset_txsync_r3,
      SYNC_DONE         => tx_sync_done,
      TXENPMAPHASEALIGN => mgt_txenpmaphasealign,
      TXPMASETPHASE     => mgt_txpmasetphase,
      TXDLYALIGNDISABLE => mgt_txdlyaligndisable,
      TXDLYALIGNRESET   => mgt_txdlyalignreset
      );

  mgt_tx_ready <= tx_sync_done;
  mgt_tx_fault <= "1111" when tx_sync_done = '0' else "0000";

  mgt_reset_terms <= reset or  mgt_powerdown_falling;

  -- reset the rx side when the buffer overflows / underflows or on a falling
  -- edge of powerdown
  process (clk156)
  begin
    if rising_edge(clk156) then
      if mgt_rxbuferr /= "0000"  then
        mgt_rxcdr_reset <= "1111";
      else
        mgt_rxcdr_reset <= "0000";
      end if;
    end if;
  end process;

  p_mgt_reg : process(clk156)
  begin
    if rising_edge(clk156) then
        mgt_rxlock_reg       <= mgt_rxlock_r1;
        mgt_rxlock_r1        <= mgt_rxlock;
        mgt_rxdata_reg       <= mgt_rxdata;

        mgt_rxcharisk_reg0   <= mgt_rxcharisk(0);
        mgt_rxcharisk_reg1   <= mgt_rxcharisk(1);
        mgt_rxcharisk_reg2   <= mgt_rxcharisk(2);
        mgt_rxcharisk_reg3   <= mgt_rxcharisk(3);
        mgt_rxcharisk_reg4   <= mgt_rxcharisk(4);
        mgt_rxcharisk_reg5   <= mgt_rxcharisk(5);
        mgt_rxcharisk_reg6   <= mgt_rxcharisk(6);
        mgt_rxcharisk_reg7   <= mgt_rxcharisk(7);

        mgt_rxnotintable_reg0 <= mgt_rxnotintable(0);
        mgt_rxnotintable_reg1 <= mgt_rxnotintable(1);
        mgt_rxnotintable_reg2 <= mgt_rxnotintable(2);
        mgt_rxnotintable_reg3 <= mgt_rxnotintable(3);
        mgt_rxnotintable_reg4 <= mgt_rxnotintable(4);
        mgt_rxnotintable_reg5 <= mgt_rxnotintable(5);
        mgt_rxnotintable_reg6 <= mgt_rxnotintable(6);
        mgt_rxnotintable_reg7 <= mgt_rxnotintable(7);

        mgt_rxdisperr_reg0    <= mgt_rxdisperr(0);
        mgt_rxdisperr_reg1    <= mgt_rxdisperr(1);
        mgt_rxdisperr_reg2    <= mgt_rxdisperr(2);
        mgt_rxdisperr_reg3    <= mgt_rxdisperr(3);
        mgt_rxdisperr_reg4    <= mgt_rxdisperr(4);
        mgt_rxdisperr_reg5    <= mgt_rxdisperr(5);
        mgt_rxdisperr_reg6    <= mgt_rxdisperr(6);
        mgt_rxdisperr_reg7    <= mgt_rxdisperr(7);

        mgt_codecomma_reg0    <= mgt_rxchariscomma(0);
        mgt_codecomma_reg1    <= mgt_rxchariscomma(1);
        mgt_codecomma_reg2    <= mgt_rxchariscomma(2);
        mgt_codecomma_reg3    <= mgt_rxchariscomma(3);
        mgt_codecomma_reg4    <= mgt_rxchariscomma(4);
        mgt_codecomma_reg5    <= mgt_rxchariscomma(5);
        mgt_codecomma_reg6    <= mgt_rxchariscomma(6);
        mgt_codecomma_reg7    <= mgt_rxchariscomma(7);
        
        mgt_rxbufstatus_reg   <= mgt_rxbufstatus;
    end if;
  end process p_mgt_reg;

  comma_align_done <= '1' when sync_status_i = "1111" else '0';
  chanbond_done    <= '1' when mgt_rxchanisaligned = "1111" else '0';

  chanbond_monitor_i : xaui_v10_4_chanbond_monitor
  port map (
    CLK                 => clk156,
    RST                 => reset156,
    COMMA_ALIGN_DONE    => comma_align_done,
    CORE_ENCHANSYNC     => mgt_enchansync,
    CHANBOND_DONE       => chanbond_done,
    RXRESET             => cbm_rx_reset
  );

end wrapper;
