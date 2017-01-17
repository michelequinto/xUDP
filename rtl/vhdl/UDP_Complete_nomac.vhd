-- Filename            : UDP_Complete_nomac.vhd
-- Description         : 
-- Author              : Michele Quinto
-- Created On          : Tue Oct 26 11:49:02 2016

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
use work.arp_types.all;
use work.axi_types.all;
use work.ipv4_types.all;
use work.xUDP_Common_pkg.all;

entity UDP_Complete_nomac is
  generic (
    CLOCK_FREQ			: integer := 156000000;					-- freq of data_in_clk -- needed to timout cntr
    ARP_TIMEOUT			: integer := 60;					-- ARP response timeout (s)
    ARP_MAX_PKT_TMO             : integer := 5;						-- # wrong nwk pkts received before set error
    MAX_ARP_ENTRIES 	        : integer := 255					-- max entries in the ARP store
    );
  port (
    -- UDP TX signals
    udp_tx_start			: in std_logic;					-- indicates req to tx UDP
    udp_txi				: in udp_tx_type;				-- UDP tx cxns
    udp_tx_result			: out std_logic_vector (1 downto 0);            -- tx status (changes during transmission)
    udp_tx_data_out_ready               : out std_logic;				-- indicates udp_tx is ready to take data
    
    -- UDP RX signals
    udp_rx_start			: out std_logic;				-- indicates receipt of udp header
    udp_rxo				: out udp_rx_type;
    udp_rx_data_out_ready               : in std_logic;
    
    -- IP RX signals
    ip_rx_hdr				: out ipv4_rx_header_type;
    
    -- system signals
    clk                                 : in xUDP_CLOCK_T;
    udp_conf                            : in xUDP_CONIGURATION_T;
    control				: in udp_control_type;
    
    -- status signals
    arp_pkt_count			: out STD_LOGIC_VECTOR(7 downto 0);		-- count of arp pkts received
    ip_pkt_count			: out STD_LOGIC_VECTOR(7 downto 0);		-- number of IP pkts received for us
    
    mac_tx                              : out axi4_dvlk64_t;
    mac_rx                              : in axi4_dvlk64_t;
    mac_tx_tready                       : in std_logic;
    mac_rx_tready                       : out std_logic
  );

end UDP_Complete_nomac;

architecture rtl  of UDP_Complete_nomac is

  component UDP_TX
    port (
      -- UDP TX signals
      udp_tx_start			: in std_logic;					-- indicates req to tx UDP
      udp_txi				: in udp_tx_type;				-- UDP tx
      udp_tx_result			: out std_logic_vector (1 downto 0);            -- tx status (changes during transmission)
      udp_tx_data_out_ready             : out std_logic;				-- indicates udp_tx is ready to take data

      -- system signals
      tx_clk				: in  STD_LOGIC;
      reset 				: in  STD_LOGIC;

      -- IP TX side signals
      ip_tx_start			: out std_logic;
      ip_tx				: out ipv4_tx_type;				-- IP tx
      ip_tx_result			: in std_logic_vector (1 downto 0);		-- tx status (changes during transmission)
      ip_tx_data_out_ready	        : in std_logic					-- indicates IP TX is ready to take data
      );        
  end component;

  component UDP_RX
  port(
    -- UDP Layer signals
    udp_rx_start : out std_logic;       -- indicates receipt of udp header
    udp_rxo      : out udp_rx_type;
    udp_rx_data_out_ready : in std_logic;
    -- system signals
    clk          : in  std_logic;
    reset        : in  std_logic;
    -- IP layer RX signals
    ip_rx_start  : in  std_logic;       -- indicates receipt of ip header
    ip_rx        : in  ipv4_rx_type;
    ip_rx_data_out_ready : out std_logic
    );      
  end component;

  component IPv4_Complete_nomac
    generic (
      CLOCK_FREQ			: integer := 156250000;				-- freq of data_in_clk -- needed to timout cntr
      ARP_TIMEOUT			: integer := 60;				-- ARP response timeout (s)
      ARP_MAX_PKT_TMO                   : integer := 5;					-- # wrong nwk pkts received before set error
      MAX_ARP_ENTRIES 	                : integer := 255				-- max entries in the ARP store
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

  -----------------------------------------------------------------------------
  -- signals declaration
  -----------------------------------------------------------------------------

  signal ip_tx_start		        : std_logic;
  signal ip_tx				: ipv4_tx_type;
  signal ip_tx_result			: std_logic_vector (1 downto 0);
  signal ip_tx_data_out_ready           : std_logic;

  signal ip_rx_start		        : std_logic;
  signal ip_rx				: ipv4_rx_type;
  signal ip_rx_data_out_ready           : std_logic;
  
begin  -- rtl 

  udp_tx_inst : UDP_TX
    port map (
      udp_tx_start              => udp_tx_start,
      udp_txi	                => udp_txi,		
      udp_tx_result	        => udp_tx_result,	
      udp_tx_data_out_ready     => udp_tx_data_out_ready,

      -- system signals
      tx_clk			=> clk.tx_clk,	
      reset 			=> clk.tx_reset,	

      -- IP TX side signals
      ip_tx_start		=> ip_tx_start,	
      ip_tx			=> ip_tx,	
      ip_tx_result		=> ip_tx_result,	
      ip_tx_data_out_ready	=> ip_tx_data_out_ready );

  udp_rx_inst : UDP_RX
    port map (
      -- UDP Layer signals
      udp_rx_start              => udp_rx_start,
      udp_rxo                   => udp_rxo,
      udp_rx_data_out_ready     => udp_rx_data_out_ready,
      -- system signals
      clk                       => clk.rx_clk,
      reset                     => clk.rx_reset,
      -- IP layer RX signals
      ip_rx_start               => ip_rx_start,
      ip_rx                     => ip_rx,
      ip_rx_data_out_ready      => ip_rx_data_out_ready
    );

  ip_inst : IPv4_Complete_nomac
    port map (
      -- IP Layer signals
      ip_tx_start		=> ip_tx_start,
      ip_tx			=> ip_tx,
      ip_tx_result		=> ip_tx_result,
      ip_tx_tready	        => ip_tx_data_out_ready,
      
      ip_rx_start		=> ip_rx_start,
      ip_rx			=> ip_rx,
      ip_rx_tready              => ip_rx_data_out_ready,
      
      clk                       => clk,
      udp_conf                  => udp_conf,
     
      control			=> control,
      -- status signals
      arp_pkt_count		=> arp_pkt_count,
      ip_pkt_count		=> ip_pkt_count,
      
      mac_rx                    => mac_rx,
      mac_tx                    => mac_tx,
      mac_tx_tready             => mac_tx_tready,
      mac_rx_tready             => mac_rx_tready );
  
  
end rtl ;
