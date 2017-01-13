-- Filename            : UDP_TX.vhd
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

entity UDP_RX  is
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
    ip_rx        : in  ipv4_rx_type
);
end UDP_RX ;

architecture rtl of UDP_RX is

begin
    
end rtl;        
