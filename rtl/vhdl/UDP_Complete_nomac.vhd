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
      udp_tx				: in axi4_dvlk64_t;				-- UDP tx cxns
      udp_tx_result			: out std_logic_vector (1 downto 0);            -- tx status (changes during transmission)
      udp_tx_data_out_ready             : out std_logic;				-- indicates udp_tx is ready to take data
      -- UDP RX signals
      udp_rx_start			: out std_logic;				-- indicates receipt of udp header
      udp_rx				: out axi4_dvlk64_t;
      -- IP RX signals
      ip_rx_hdr				: out ipv4_rx_header_type;
      -- system signals
      rx_clk				: in  STD_LOGIC;
      tx_clk				: in  STD_LOGIC;
      reset 				: in  STD_LOGIC;
      our_ip_address 		        : in  std_logic_vector (31 downto 0);
      our_mac_address 		        : in  std_logic_vector (47 downto 0);
      control				: in udp_control_type;
      -- status signals
      arp_pkt_count			: out STD_LOGIC_VECTOR(7 downto 0);		-- count of arp pkts received
      ip_pkt_count			: out STD_LOGIC_VECTOR(7 downto 0);		-- number of IP pkts received for us
      
      -- MAC TX
      mac_tx                            : out axi4_dvlk64_t;
      -- MAC RX
      mac_rx                            : out axi4_dvlk64_t            
      );
end UDP_Complete_nomac;

architecture rtl  of UDP_Complete_nomac is

begin  -- rtl 

  

end rtl ;
