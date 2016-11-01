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
use work.ipv4_types.all;
use work.xUDP_Common_pkg.all;


entity IPv4_TX is
  port (
   -- IP Layer signals
    ip_tx_start			: in std_logic;
    ip_tx			: in ipv4_tx_type;		     
    ip_tx_result		: out std_logic_vector (1 downto 0); 
    ip_tx_data_out_ready	: out std_logic;
    -- clock
    clk                         : in xUDP_CLOCK_T;
    -- udp confs
    udp_conf                    : in xUDP_CONIGURATION_T;
    -- ARP lookup signals
    arp_req_req			: out arp_req_req_type;
    arp_req_rslt		: in arp_req_rslt_type;
    -- MAC layer TX signals
    mac_tx                      : out axi4_dvlk64_t
    );                  

end IPv4_TX;

architecture rtl of IPv4_TX is 

  type tx_state_type is (
    IDLE,
    WAIT_MAC,                           -- waiting for response from ARP for mac lookup
    WAIT_CHN,                           -- waiting for tx access to MAC channel
    SEND_ETH_HDR,                       -- sending the ethernet header
    SEND_IP_HDR,                        -- sending the IP header
    SEND_USER_DATA                      -- sending the users data
  );

  type count_mode_type is (RST, INCR, HOLD);
  type settable_cnt_type is (RST, SET, INCR, HOLD);
  type set_clr_type is (SET, CLR, HOLD);

  -- Configuration
  constant IP_TTL               : std_logic_vector (7 downto 0) := x"80";

  -- TX state variables
  signal tx_state, next_tx_state : tx_state_type;
  signal tx_count               : unsigned (11 downto 0);
  signal tx_result_reg          : std_logic_vector (1 downto 0);
  signal tx_mac                 : std_logic_vector (47 downto 0);
  signal tx_mac_chn_reqd        : std_logic;
  signal tx_hdr_cks             : std_logic_vector (23 downto 0);
  signal mac_lookup_req         : std_logic;
  signal arp_req_ip_reg         : std_logic_vector (31 downto 0);
  signal mac_data_out_ready_reg : std_logic;

  signal set_tx_state           : std_logic;
  signal next_tx_result         : std_logic_vector (1 downto 0);
  signal set_tx_result          : std_logic;
  signal tx_mac_value           : std_logic_vector (47 downto 0);
  signal set_tx_mac             : std_logic;
  signal tx_count_val           : unsigned (11 downto 0);
  signal tx_count_mode          : settable_cnt_type;
  signal tx_data                : std_logic_vector (7 downto 0);
  signal set_last               : std_logic;
  signal set_chn_reqd           : set_clr_type;
  signal set_mac_lku_req        : set_clr_type;
  signal tx_data_valid          : std_logic;

  signal total_length           : std_logic_vector (15 downto 0);
  signal packet_type            : std_logic_vector (15 downto 0);

begin  -- rtl

  tx_sequential : process (clk.tx_clk, clk.tx_reset)
  begin
    if clk.tx_reset = '1' then
      tx_state <= IDLE;
    elsif rising_edge(clk.tx_clk) then 
      tx_state <= next_tx_state;
    end if;     
  end process;

  --tx_comb : process(tx_state)
  --begin
  --  ip_tx_data_out_ready <= '0';
  --  case tx_state is
  --    when IDLE =>
  --      if ip_tx_start = '1' then
  --        if unsigned(ip_tx.hdr.data_length) > MAX_IP_PAYLOAD_LENGTH then -- 1480 then
  --          next_tx_result <= IPTX_RESULT_ERR;
  --          set_tx_result  <= '1';
  --        else
  --          next_tx_result <= IPTX_RESULT_SENDING;
            
  --          if ip_tx.hdr.dst_ip_addr = IP_BC_ADDR then
  --            tx_mac_value  <= MAC_BC_ADDR;
  --            set_tx_mac    <= '1';
  --            next_tx_state <= WAIT_CHN;
  --            set_tx_state  <= '1';
  --          else
  --                                      -- need to req the mac address for this ip
  --            set_mac_lku_req <= SET;
  --            next_tx_state   <= WAIT_MAC;
  --            set_tx_state    <= '1';
  --          end if;
  --        end if;
  --      else
  --        set_mac_lku_req <= CLR;
  --      end if;
  --    when WAIT_MAC => null;
        
  --    when WAIT_CHN =>
  --      if mac_tx_granted = '1' then
  --        next_tx_state <= SEND_ETH_HDR;
  --        set_tx_state  <= '1';
  --      end if;
        
  --    when others => null;
  --  end case;
    
  --end process;
  
  mac_tx.tvalid <= '0';
  mac_tx.tdata <= (others => 'X');
  mac_tx.tlast <= '0';

end rtl;
