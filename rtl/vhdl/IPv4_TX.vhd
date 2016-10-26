-- Filename            : IP_TX.vhd
-- Description         : 
-- Author              : Michele Quinto
-- Created On          : Tue Oct 28 10:20:02 2016

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
use work.xUDP_Common_pkg.all;



entity IPv4_TX is
  port (
   -- IP Layer signals
    ip_tx_start			: in std_logic;
    ip_tx			: in ipv4_tx_type;		        -- IP tx cxns
    ip_tx_result		: out std_logic_vector (1 downto 0);    -- tx statuss (changes during transmission)
    ip_tx_data_out_ready	: out std_logic;			-- indicates IP TX is ready to take data
    
    -- system signals
    clk 			: in std_logic;			        					                              -- same clock used to clock mac data and ip dataa
    reset 			: in std_logic;
    our_ip_address 		: in std_logic_vector (31 downto 0);
    our_mac_address 		: in std_logic_vector (47 downto 0);
    -- ARP lookup signals
    arp_req_req			: out arp_req_req_type;
    arp_req_rslt		: in arp_req_rslt_type;
    -- MAC layer TX signals
    mac_tx                      : out axi4_dvlk64_t
    );                  

end IPv4_TX;
