-- Filename            : xge_mac.vhd
-- Description         : 
-- Author              : Michele Quinto
-- Created On          : Tue Oct 18 17:49:02 2016

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

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.axi_types.all;
use work.arp_types.all;
use work.xUDP_Common_pkg.all;


entity xge_mac_axi is
    generic (
      CHANGE_EDIANESS : boolean := true );
    port (
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
	  axi_tx              : out axi4_dvlk64_t
    );
end xge_mac_axi;

architecture rtl of xge_mac_axi is

-------------------------------------------------------------------------------
-- Components declaration
-------------------------------------------------------------------------------

  -- native from opencores
  -- xge_mac
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
-- Signals declaration
-------------------------------------------------------------------------------
  signal pkt_tx_full         : std_logic;
  signal pkt_rx_val          : std_logic;
  signal pkt_rx_sop          : std_logic;
  signal pkt_rx_mod          : std_logic_vector(2 downto 0);
  signal pkt_rx_err          : std_logic;
  signal pkt_rx_eop          : std_logic;
  signal pkt_rx_data         : std_logic_vector(63 downto 0);
  signal pkt_rx_avail        : std_logic;
  signal pkt_tx_val          : std_logic;
  signal pkt_tx_sop          : std_logic;
  signal pkt_tx_mod          : std_logic_vector(2 downto 0);
  signal pkt_tx_eop          : std_logic;
  signal pkt_tx_data         : std_logic_vector(63 downto 0);
  signal pkt_rx_ren          : std_logic;
-------------------------------------------------------------------------------
-- Signals declaration
-------------------------------------------------------------------------------

  begin

    -- native xge mac block instance 
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

     

  do_not_change_endianess : if not CHANGE_EDIANESS generate
    
    axi4.tdata <= pkt_rx_data;
    
    with pkt_rx_mod select axi4.tkeep <= "11111111" when "000",
                                         "00000011" when "010",   
                                         "00000111" when "011",   
                                         "00001111" when "100",   
                                         "00011111" when "101",
                                         "00111111" when "110",
                                         "01111111" when "111",
                                         "XXXXXXXX" when others;
  end generate;

  change_endianess : if CHANGE_EDIANESS generate

    bytes_mingling : for i in 0 to axi4.tdata'length/8-1 generate
      axi4.tdata(8*i-1 downto i*8) <= pkt_rx_data(pkt_rx_data'length-1-8*i downto pkt_rx_data'length-8*(i+1));
    end generate;

    with pkt_rx_mod select axi4.tkeep <= "11111111" when "000",
                                         "11000000" when "010",
                                         "11100000" when "011",
                                         "11110000" when "100",
                                         "11111000" when "101",
                                         "11111100" when "110",
                                         "11111110" when "111",
                                         "XXXXXXXX" when others;
                              
  end generate;
  
  axi4.tvalid <= pkt_rx_val;
  axi4.tlast <=  pkt_rx_eop;
  
end rtl;
