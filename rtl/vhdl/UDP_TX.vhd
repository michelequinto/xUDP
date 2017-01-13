-- Filename            : UDP_TX.vhd
-- Description         : 
-- Author              : Michele Quinto
-- Created On          : Tue Oct 26 11:49:02 2016

-- $LastChangedBy$
-- $LastChangedRevision$
-- $LastChangedDate$
-- $URL$

------------------------------------------------------------------

-- Copyright 2017 Michele Quinto

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

entity UDP_TX is
  port (
    -- UDP TX signals
    udp_tx_start			: in std_logic;					-- indicates req to tx UDP
    udp_txi				: in udp_tx_type;				-- UDP tx
    udp_tx_result			: out std_logic_vector (1 downto 0);            -- tx status (changes during transmission)
    udp_tx_data_out_ready               : out std_logic;				-- indicates udp_tx is ready to take data
    
    -- system signals
    tx_clk				: in  STD_LOGIC;
    reset 				: in  STD_LOGIC;
    
    -- IP TX side signals
    ip_tx_start		        	: out std_logic;
    ip_tx				: out ipv4_tx_type;				-- IP tx
    ip_tx_result			: in std_logic_vector (1 downto 0);		-- tx status (changes during transmission)
    ip_tx_data_out_ready	        : in std_logic					-- indicates IP TX is ready to take data
    );

end UDP_TX;

architecture rtl  of UDP_TX is

--      IP datagram header format
--
--	0          4          8                      16      19             24                    31
--	--------------------------------------------------------------------------------------------
--	|              source port number            |              dest port number               |
--	|                                            |                                             |
--	--------------------------------------------------------------------------------------------
--	|                length (bytes)              |                checksum                     |
--	|          (header and data combined)        |                                             |
--	--------------------------------------------------------------------------------------------
--	|                                          Data                                            |
--	|                                                                                          |
--	--------------------------------------------------------------------------------------------
--	|                                          ....                                            |
--	|                                                                                          |
--	--------------------------------------------------------------------------------------------
  
begin  -- rtl 

  
  
  
end rtl ;
