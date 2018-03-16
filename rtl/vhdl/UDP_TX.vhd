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

  type tx_state_type is (IDLE, PAUSE, SEND_UDP_HDR, SEND_USER_DATA);
  signal tx_state, next_tx_state : tx_state_type;

  signal next_tx_result : std_logic_vector(1 downto 0);
  signal tx_result : std_logic_vector(1 downto 0);
  signal set_tx_result : std_logic;

  signal total_length		: std_logic_vector (15 downto 0);
  
begin  -- rtl 

  -- calculate packet total lenght in bytes
  total_length <= std_logic_vector(unsigned(udp_txi.hdr.data_length) + 8);
  
  comb_proc : process(tx_state,
                      total_length,
                      ip_tx_data_out_ready,
                      ip_tx_result,
                      udp_tx_start,
                      udp_txi.data.tlast,
                      udp_txi.data.tvalid)
  begin
    ip_tx_start <= '0';
    udp_tx_data_out_ready <= '0';

    set_tx_result <= '0';

    ip_tx.data.tvalid <= '0';
    ip_tx.data.tlast <= '0';
    ip_tx.data.tdata <= (others => 'X');
    ip_tx.data.tkeep <= (others => 'X');

    ip_tx.hdr.protocol <= x"11"; -- UDP protocol
    ip_tx.hdr.data_length <= total_length;  
    ip_tx.hdr.dst_ip_addr <= udp_txi.hdr.dst_ip_addr;
    
    next_tx_state <= tx_state;
      
    case tx_state is
      when IDLE =>
        if udp_tx_start = '1' then
          if unsigned(udp_txi.hdr.data_length) > MAX_UDP_PAYLOAD_LENGTH then
            next_tx_result <= UDPTX_RESULT_ERR;
            set_tx_result <= '1';
          else
            next_tx_result <= UDPTX_RESULT_SENDING;
            set_tx_result <= '1';

            next_tx_state <= PAUSE;
          end if;
        end if;
        
      when PAUSE =>
        -- delay one clock for IP layer to respond to ip_tx_start and remove any tx error result
        ip_tx_start <= '1';      
        
        next_tx_state <= SEND_UDP_HDR;
        
      when SEND_UDP_HDR =>
        if ip_tx_result = IPTX_RESULT_ERR then
          next_tx_result <= UDPTX_RESULT_ERR;
          set_tx_result <= '1';

          next_tx_state <= IDLE;
        elsif ip_tx_data_out_ready = '1' then
          ip_tx.data.tvalid <= '1';
          ip_tx.data.tlast <= '0';
          ip_tx.data.tdata <= udp_txi.hdr.src_port  &
                              udp_txi.hdr.dst_port &
                              total_length &
                              udp_txi.hdr.checksum;
          ip_tx.data.tkeep <= (others => '1');  
          
          next_tx_state <= SEND_USER_DATA;
        end if;
        
      when SEND_USER_DATA =>
        udp_tx_data_out_ready <= ip_tx_data_out_ready;
        ip_tx.data.tvalid <= udp_txi.data.tvalid;
        ip_tx.data.tlast <= udp_txi.data.tlast;
        ip_tx.data.tdata <= udp_txi.data.tdata;
        ip_tx.data.tkeep <= udp_txi.data.tkeep;
        if( udp_txi.data.tlast = '1' ) then
          next_tx_state <= IDLE;
        end if;
      when others =>
        next_tx_state <= IDLE;
    end case;
  end process;
  
  seq_proc : process(tx_clk, reset)
  begin
    if reset = '1' then
      tx_state <= IDLE;
    elsif rising_edge(tx_clk) then
      tx_state <= next_tx_state;
    end if;
  end process;

  tx_result_latch : process(tx_clk, reset)
  begin
    if reset = '1' then
      tx_result <= IPTX_RESULT_NONE;
    elsif rising_edge(tx_clk) then
      if( set_tx_result = '1' ) then 
        tx_result <= next_tx_result;
      end if;
    end if;
  end process;

end rtl ;
