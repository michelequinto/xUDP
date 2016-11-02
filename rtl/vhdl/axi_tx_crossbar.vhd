-- Filename            : xUDP.vhd
-- Description         : 
-- Author              : Michele Quinto
-- Created On          : Tue Oct 30 20:49:07 2016

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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axi_types.all;
use ieee.math_real.all;

entity axi_tx_crossbar is
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
end axi_tx_crossbar;

architecture rtl of axi_tx_crossbar is

  type state_t is (IDLE, TRANSFER);

  signal st, n_st  : state_t;

  signal sel_i, sel : std_logic_vector(integer(ceil(log2(real(N_PORTS-1)))) downto 0);
  signal latch_sel  : std_logic;
  
  begin
    
    sequential : process (clk)
    begin
      if rising_edge(clk) then
        if rst = '1' then
          st <= IDLE;
        else
          st <= n_st;
        end if;
      end if;     
    end process;

    comb : process( axi_in, axi_out_tready )
    begin
      latch_sel <= '0';
      sel_i <= (others => '0');
      n_st <= st;
      case st is
        when IDLE =>
          if axi_out_tready = '1' then
            for i in 0 to N_PORTS-1 loop
              if axi_in(i).tvalid = '1' then
                sel_i <= std_logic_vector(to_unsigned(i, sel_i'length));
                latch_sel <= '1';
                n_st <= TRANSFER;
                exit;
              end if;   
            end loop;
          end if;
        when TRANSFER =>
          if( axi_in(to_integer(unsigned(sel))).tvalid = '1'
            and axi_in(to_integer(unsigned(sel))).tlast = '1' ) then
            n_st <= IDLE;
          end if;
        when others =>
          n_st <= IDLE;
    end case;
    end process;

    selector : process (clk, rst)
    begin
      if rst = '1' then
        sel <= (others => '0');
      elsif rising_edge(clk) then
        if latch_sel = '1' then
          sel <= sel_i;
        end if;
      end if;     
    end process;

    selector_out : process (sel, axi_in, axi_out_tready)
    begin
      axi_in_tready <= (others => '0');
      for i in 0 to N_PORTS-1 loop
        if to_integer(unsigned(sel)) = i then
          axi_out.tdata <= axi_in(i).tdata;
          axi_out.tvalid <= axi_in(i).tvalid;
          axi_out.tkeep <= axi_in(i).tkeep;
          axi_out.tlast <= axi_in(i).tlast;
          axi_in_tready(i) <= axi_out_tready;
        end if;   
      end loop;
    end process;
    
end rtl;
