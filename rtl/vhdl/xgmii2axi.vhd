--                              -*- Mode: Verilog -*-
-- Filename            : xgmii2axi.vhd
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


entity xgmii2axi is
    generic (
      CHANGE_EDIANESS : boolean := true );
    
    port (
      pkt_rx_val                : in std_logic;
      pkt_rx_sop                : in std_logic;
      pkt_rx_mod                : in std_logic_vector(2 downto 0);
      pkt_rx_err                : in std_logic;
      pkt_rx_eop                : in std_logic;
      pkt_rx_data               : in std_logic_vector(63 downto 0);
      pkt_rx_avail              : in std_logic;
      pkt_rx_ren                : out std_logic;

      axi4                      : out axi4_dvlk64_t
    );
end xgmii2axi;

architecture rtl of xgmii2axi is
  
begin

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
