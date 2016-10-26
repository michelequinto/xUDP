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

entity counter is
  
  generic (
    length : integer := 8;      -- length of counter
    preset : integer := 0       -- preset
  );
  port (
    rst       : in std_logic;
    clk       : in std_logic;
    cnt       : in std_logic;
    
    data      : out std_logic_vector(length-1 downto 0)
  );                
      
end counter ;

architecture rtl of counter is

begin

  cont_proc : process( clk, rst )
    variable count : integer range 0 to 2**length-1 := 0;
  begin
    if rst = '1' then
      count := preset;
    elsif rising_edge(clk) then
      if cnt = '1' then
        count := count + 1;
      end if;
    end if;
    data <= std_logic_vector(to_unsigned(count,data'length));
  end process;              

end rtl ;
