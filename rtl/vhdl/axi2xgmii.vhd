--                              -*- Mode: Verilog -*-
-- Filename            : axi2xgmii.vhd
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


entity axi2xgmii is
    generic (
        CHANGE_EDIANESS : boolean := true
      );
    port (
      aclk                      : in std_logic;
      arstn                     : in std_logic;
      
      axi4                      : in axi4_dvlk64_t;
      tready                    : out std_logic;
      
      pkt_tx_val                : out std_logic;      
      pkt_tx_sop                : out std_logic;
      pkt_tx_mod                : out std_logic_vector(2 downto 0);
      pkt_tx_eop                : out std_logic;
      pkt_tx_data               : out std_logic_vector(63 downto 0);
      pkt_tx_full               : in std_logic
    );
end axi2xgmii;

architecture rtl of axi2xgmii is 

 begin

   do_not_change_endianess : if not CHANGE_EDIANESS generate
   
     pkt_tx_data <= axi4.tdata;
     

     with axi4.tkeep select pkt_tx_mod  <= "000" when "11111111",
                                           "001" when "00000001",             
                                           "010" when "00000011",            
                                           "011" when "00000111",      
                                           "100" when "00001111",
                                           "101" when "00011111",
                                           "110" when "00111111",
                                           "111" when "01111111",
                                           "XXX" when others;
   end generate;

   change_endianess : if CHANGE_EDIANESS generate
   
     bytes_mingling : for i in 0 to axi4.tdata'length/8-1 generate
       pkt_tx_data(8*i-1 downto i*8) <= axi4.tdata(axi4.tdata'length-1-8*i downto axi4.tdata'length-8*(i+1));
     end generate;
     
     with axi4.tkeep select pkt_tx_mod  <= "000" when "11111111",
                                           "001" when "10000000",             
                                           "010" when "11000000",            
                                           "011" when "11100000",      
                                           "100" when "11110000",
                                           "101" when "11111000",
                                           "110" when "11111100",
                                           "111" when "11111110",
                                           "XXX" when others;
   end generate;
     
   generate_sop: process(aclk)
     variable tvalid_d : std_logic := '0';
   begin
     if rising_edge(aclk) then
       pkt_tx_sop <= axi4.tvalid and (not tvalid_d);
       tvalid_d := axi4.tvalid;
     end if;
   end process;        

   tready <= not pkt_tx_full;
   
   pkt_tx_val <= axi4.tvalid;
   pkt_tx_eop <= axi4.tlast; 
   
end rtl;
