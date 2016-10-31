-- Filename            : IPv4_Complete_nomac.vhd
-- Description         : 
-- Author              : Michele Quinto
-- Created On          : Tue Oct 26 12:49:02 2016

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
use work.ipv4_types.all;
use work.xUDP_Common_pkg.all;

entity IPv4_Complete_nomac is
  generic (
    CLOCK_FREQ			: integer := 156250000;					-- freq of data_in_clk -- needed to timout cntr
    ARP_TIMEOUT			: integer := 60;					-- ARP response timeout (s)
    ARP_MAX_PKT_TMO             : integer := 5;						-- # wrong nwk pkts received before set error
    MAX_ARP_ENTRIES 	        : integer := 255					-- max entries in the ARP store
    );
    port (
      -- IP Layer signals
      ip_tx_start			: in std_logic;
      ip_tx				: in ipv4_tx_type;						           -- IP tx cxns
      ip_tx_result			: out std_logic_vector (1 downto 0);		-- tx status (changes during transmission)
      ip_tx_data_out_ready	        : out std_logic;									-- indicates IP TX is ready to take data
      ip_rx_start			: out std_logic;								   -- indicates receipt of ip frame.
      ip_rx				: out ipv4_rx_type;
      -- system signals
      rx_clk				: in  STD_LOGIC;
      tx_clk				: in  STD_LOGIC;
      reset 				: in  STD_LOGIC;

      udp_conf                          : xUDP_CONIGURATION_T;
      control				: in udp_control_type;

      -- status signals
      arp_pkt_count			: out STD_LOGIC_VECTOR(7 downto 0);		-- count of arp pkts received
      ip_pkt_count			: out STD_LOGIC_VECTOR(7 downto 0);		-- number of IP pkts received for us
      
      -- MAC TX
      mac_tx                            : out axi4_dvlk64_t;
      -- MAC RX
      mac_rx                            : in axi4_dvlk64_t            
      );
end IPv4_Complete_nomac;

architecture structural of IPv4_Complete_nomac is

  component arp
    generic (
      no_default_gateway  : boolean := true;            -- set to false if communicating with devices accessed
                                                        -- through a "default gateway or router"
      CLOCK_FREQ_HZ       : integer := 156250000;       -- freq of data_in_clk -- needed to timout cntr
      ARP_TIMEOUT_S       : integer := 60;              -- ARP response timeout (s)
      ARP_TX_TIMEOUT_CLKS : integer := 200;             -- # time allowed to tx before abort
      ARP_MAX_PKT_TMO     : integer := 5;               -- # wrong nwk pkts received before set error
      MAX_ARP_ENTRIES     : integer := 255              -- max entries in the arp store
      );
    port (
      -- lookup request signals
      arp_req_req         : in  arp_req_req_type;
      arp_req_rslt        : out arp_req_rslt_type;
      -- MAC layer RX signals
      data_in             : in axi4_dvlk64_t;           -- AXI4 input stream
      -- MAC layer TX signals
      mac_tx_req          : out std_logic;              -- indicates that ip wants access to channel (stays up for as long as tx)
      mac_tx_granted      : in  std_logic;              -- indicates that access to channel has been granted            
      data_out_ready      : in  std_logic;              -- indicates system ready to consume data
      data_out            : out axi4_dvlk64_t;          -- AXI4 output stream
      -- system signals
      cfg                 : in xUDP_CONIGURATION_T;
      control             : in  arp_control_type;
      req_count           : out std_logic_vector(7 downto 0);    -- count of arp pkts received
      clks                : in xUDP_CLOCK_T
    );
  end component;
  
  component IPv4
    port (
      -- IP Layer signals
      ip_tx_start				: in std_logic;
      ip_tx					: in ipv4_tx_type;				-- IP tx cxns
      ip_tx_result		        	: out std_logic_vector (1 downto 0);		-- tx status (changes during transmission)
      ip_tx_data_out_ready	                : out std_logic;				-- indicatess IP TX is ready to take data
      ip_rx_start				: out std_logic;				-- indicates receipt of ip frame.
      ip_rx					: out ipv4_rx_type;
      -- system control signals
      rx_clk					: in std_logic;
      tx_clk					: in std_logic;
      reset 					: in std_logic;

      udp_conf                                  : xUDP_CONIGURATION_T;
      
      -- system status signals
      rx_pkt_count	        		: out std_logic_vector(7 downto 0);		-- number of IP pkts received for uses
      -- ARP lookup signals
      arp_req_req				: out arp_req_req_type;
      arp_req_rslt		        	: in arp_req_rslt_type;
      -- MAC layer RX signals
      mac_rx     			        : in axi4_dvlk64_t;
      -- MAC layer TX signals
      mac_tx_req				: out std_logic;				-- indicates that ip wants access to channel (stays up for as long as tx)
      mac_tx_granted			        : in std_logic;					-- indicatess that access to channel has been granted		
      mac_tx                                    : out axi4_dvlk64_t
      );
end component;

component axi_tx_crossbar
  generic (
    N_PORTS			: integer := 2
    );
  port (
      clk                       : in std_logic;
      rst                       : in std_logic;        
      
      axi_in_tready             : out std_logic_vector(N_PORTS-1 downto 0);
      axi_in                    : in axi_in_t(N_PORTS-1 downto 0);
      axi_out                   : out axi4_dvlk64_t;
      axi_out_tready            : in std_logic
    );
end component;

-------------------------------------------------------------------------------
-- Signal declaration
-------------------------------------------------------------------------------
-- ARP REQUEST
signal arp_req_req_int    : arp_req_req_type;
signal arp_req_rslt_int   : arp_req_rslt_type;
signal ip_mac_req         : std_logic;
signal ip_mac_grant       : std_logic;
signal udp_clk            : xUDP_CLOCK_T;
signal arp_control        : arp_control_type;

signal ip_mac_tready, arp_mac_tready    : std_logic;
signal ip_mac_tx, arp_mac_tx            : axi4_dvlk64_t;

begin
  
  ip_layer_inst : IPv4 port map
    (
      rx_clk               => rx_clk,
      tx_clk               => tx_clk,
      reset                => reset,
      
      ip_tx_start          => ip_tx_start,
      ip_tx                => ip_tx,
      ip_tx_result         => ip_tx_result,
      ip_tx_data_out_ready => ip_tx_data_out_ready,
      ip_rx_start          => ip_rx_start,
      ip_rx                => ip_rx,
      udp_conf             => udp_conf,
      rx_pkt_count         => ip_pkt_count,
      arp_req_req          => arp_req_req_int,
      arp_req_rslt         => arp_req_rslt_int,
      mac_tx_req           => ip_mac_req,
      mac_tx_granted       => ip_mac_grant,
      mac_tx               => ip_mac_tx,
      mac_rx               => mac_rx
      );

  arp_layer_inst : arp port map (
     
      arp_req_req         => arp_req_req_int,
      arp_req_rslt        => arp_req_rslt_int,
     
      data_in             => mac_rx, 
     
      mac_tx_req          => open, 
      mac_tx_granted      => '0',
      data_out_ready      => arp_mac_tready, 
      data_out            => arp_mac_tx,
  
      cfg                 => udp_conf,
      control             => arp_control,
      req_count           => open,
      clks                => udp_clk
    );

  arp_control <= control.ip_controls.arp_controls;
  
  udp_clk.rx_clk <= rx_clk;
  udp_clk.rx_reset <= reset;
  udp_clk.tx_clk <= tx_clk;
  udp_clk.tx_reset <= reset;

  axi_tx_crossbar_inst : axi_tx_crossbar port map (
      clk                  => tx_clk,
      rst                  => reset,        
      
      axi_in_tready(0)     => ip_mac_tready,
      axi_in_tready(1)     => arp_mac_tready,
      axi_in(0)            => ip_mac_tx,
      axi_in(1)            => arp_mac_tx,
      axi_out              => mac_tx,
      axi_out_tready       => '1'
    );

end structural;
