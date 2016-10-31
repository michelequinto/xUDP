-- Filename            : IPv4.vhd
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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.axi_types.all;
use work.ipv4_types.all;
use work.arp_types.all;
use work.xUDP_Common_pkg.all;
 
entity IPv4 is
    port (
      -- IP Layer signals
      ip_tx_start				: in std_logic;
      ip_tx					: in ipv4_tx_type;				-- IP tx cxns
      ip_tx_result		        	: out std_logic_vector (1 downto 0);		-- tx status (changes during transmission)
      ip_tx_data_out_ready	                : out std_logic;				-- indicatess IP TX is ready to take data
      ip_rx_start				: out std_logic;				-- indicates receipt of ip frame.
      ip_rx					: out ipv4_rx_type;
      -- system control signals
      rx_clk					: in STD_LOGIC;
      tx_clk					: in STD_LOGIC;
      reset 					: in STD_LOGIC;
      udp_conf                                  : xUDP_CONIGURATION_T;

      -- system status signals
      rx_pkt_count	        		: out STD_LOGIC_VECTOR(7 downto 0);		-- number of IP pkts received for uses
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
end IPv4;
 
architecture structural of IPv4 is

  component IPv4_RX
  port (
    -- IP Layer signals
    ip_rx                       : out ipv4_rx_type;
    ip_rx_start                 : out std_logic;                        -- indicates receipt of ip frame.
    -- system signals
    clk                         : in  std_logic;                        -- same clock used to clock mac data and ip data
    rst                         : in  std_logic;
    our_ip_address              : in  std_logic_vector (31 downto 0);
    rx_pkt_count                : out std_logic_vector(7 downto 0);     -- number of IP pkts received for us
    -- MAC layer RX signals
    mac_rx                      : in axi4_dvlk64_t
    );
  end component;
  
begin

  RX : IPv4_RX port map (
    ip_rx 	        => ip_rx,
    ip_rx_start         => ip_rx_start,
    clk 	        => rx_clk,
    rst 	        => reset,
    our_ip_address	=> udp_conf.ip_address,
    rx_pkt_count	=> rx_pkt_count,
    mac_rx 	        => mac_rx
    );

  mac_tx.tvalid <= '0';
  mac_tx.tdata <= (others => 'X');
  mac_tx.tlast <= '0';
    
end structural;
