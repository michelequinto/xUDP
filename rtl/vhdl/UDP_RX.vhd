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
    rx_clk          : in  std_logic;
    reset        : in  std_logic;
    -- IP layer RX signals
    ip_rx_start  : in  std_logic;       -- indicates receipt of ip header
    ip_rx        : in  ipv4_rx_type;
    ip_rx_data_out_ready : out std_logic	
);
end UDP_RX ;

architecture rtl of UDP_RX is

  type rx_state_type is (IDLE, UDP_HDR, USER_DATA);
  signal next_rx_state, rx_state : rx_state_type;
  signal set_udp_header : std_logic;

-- IP datagram header format
--
--      0          4          8                      16      19             24                    31
--      --------------------------------------------------------------------------------------------
--      |              source port number            |              dest port number               |
--      |                                            |                                             |
--      --------------------------------------------------------------------------------------------
--      |                length (bytes)              |                checksum                     |
--      |          (header and data combined)        |                                             |
--      --------------------------------------------------------------------------------------------
--      |                                          Data                                            |
--      |                                                                                          |
--      --------------------------------------------------------------------------------------------
--      |                                          ....                                            |
--      |                                                                                          |
--      --------------------------------------------------------------------------------------------
  
begin


  comb_proc : process(rx_state,
                      ip_rx_start,
                      ip_rx.data.tvalid,
                      ip_rx.data.tlast,
                      udp_rx_data_out_ready)
  begin
    next_rx_state <= rx_state;

    udp_rxo.data.tdata <= (others => 'X');
    udp_rxo.data.tvalid <= '0';
    udp_rxo.data.tlast <= 'X';
    udp_rxo.data.tkeep <= (others => 'X');

    ip_rx_data_out_ready <= '1';
    set_udp_header <= '0';
    
    case rx_state is
      when IDLE =>
        if ip_rx_start = '1' then
          next_rx_state <= IDLE;
        end if;
      when UDP_HDR =>
        set_udp_header <= '1';
        next_rx_state <= USER_DATA;
      when USER_DATA =>
        ip_rx_data_out_ready <= udp_rx_data_out_ready;
        udp_rxo.data.tdata <= ip_rx.data.tdata;
        udp_rxo.data.tvalid <= ip_rx.data.tvalid;
        udp_rxo.data.tlast <= ip_rx.data.tlast;
        udp_rxo.data.tkeep <= ip_rx.data.tkeep;
        if(  ip_rx.data.tlast = '1' ) then
          next_rx_state <= IDLE;
        end if;             
      when others =>
        next_rx_state <= IDLE;
    end case;   
  end process;
  
  seq_proc : process(rx_clk, reset)
  begin
    if reset = '1' then
      rx_state <= IDLE;
    elsif rising_edge(rx_clk) then
      rx_state <= next_rx_state;
    end if;
  end process;

  set_udp_header_proc : process(rx_clk)
  begin
    if reset = '1' then
      udp_rxo.hdr.data_length <= (others => 'X');
      udp_rxo.hdr.src_port    <= (others => 'X'); 
      udp_rxo.hdr.dst_port    <= (others => 'X');
      udp_rxo.hdr.src_ip_addr <= (others => 'X');
      udp_rxo.hdr.is_valid <= '0';
    elsif rising_edge(rx_clk) then
      if( set_udp_header = '1' ) then
        udp_rxo.hdr.data_length <= std_logic_vector(unsigned(ip_rx.data.tdata(31 downto 16))-8);
        udp_rxo.hdr.src_port    <= ip_rx.data.tdata(63 downto 48);
        udp_rxo.hdr.dst_port    <= ip_rx.data.tdata(47 downto 32);
        udp_rxo.hdr.src_ip_addr <= ip_rx.hdr.src_ip_addr;
        udp_rxo.hdr.is_valid <= '1';
      end if;
    end if;
  end process;
  
end rtl;        
