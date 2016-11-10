--   
-- Filename            : xaui_init.vhd
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity xaui_init is
  Port ( rstn           : in  std_logic;
         clk156         : in  std_logic;
         status_vector  : in  std_logic_vector (7 downto 0);
         config_vector  : out std_logic_vector (6 downto 0));
end xaui_init;

architecture rtl of xaui_init is
  
  type state_type is (wait_sync, sync, synched);
  signal st  : state_type;

  alias reset_local_fault : std_logic is config_vector(2);
  alias reset_rx_link_status : std_logic is config_vector(3);
                              
begin

  do_reset : process(clk156, rstn)
    variable cnt : integer range 0 to 127 := 0;       -- counter
  begin
    if rstn = '0' then
      st <= wait_sync;
      reset_local_fault <= '0';        
      reset_rx_link_status <= '0';
      cnt := 0;
    elsif rising_edge(clk156) then

      reset_local_fault <= '0';
      reset_rx_link_status <= '0';
      
      case st is
        when wait_sync =>
          cnt := cnt + 1;
          if cnt = 127  then
            if status_vector /= "11111100" then
             st <= sync;
            else
             st <= synched;
            end if;
          else
            st <= wait_sync;
          end if;
        when sync =>
          cnt := 0;
          reset_local_fault <= '1';
          reset_rx_link_status <= '1';
          st <= wait_sync;
        when synched =>
          cnt := 0;
          st <= synched;
        when others =>
          cnt := 0;       
          st <= wait_sync;
      end case;
    end if;
end process;

config_vector(1 downto 0) <= "00";       
config_vector(6 downto 4) <= "000";

end rtl;
