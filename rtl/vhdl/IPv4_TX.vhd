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
    ip_tx_tready	        : out std_logic;
    -- clock
    clk                         : in xUDP_CLOCK_T;
    -- udp confs
    udp_conf                    : in xUDP_CONIGURATION_T;
    -- ARP lookup signals
    arp_req_req			: out arp_req_req_type;
    arp_req_rslt		: in arp_req_rslt_type;
    -- MAC layer TX signals
    mac_tx                      : out axi4_dvlk64_t;
    mac_tx_tready               : in std_logic
    );                  

end IPv4_TX;

-- IP datagram header format
--
--      0          4          8                      16      19             24                    31
--      --------------------------------------------------------------------------------------------
--      | Version  | *Header  |    Service Type      |        Total Length including header        |
--      |   (4)    |  Length  |     (ignored)        |                 (in bytes)                  |
--      --------------------------------------------------------------------------------------------
--      |           Identification                   | Flags |       Fragment Offset               |
--      |                                            |       |      (in 32 bit words)              |
--      --------------------------------------------------------------------------------------------
--      |    Time To Live     |       Protocol       |             Header Checksum                 |
--      |     (ignored)       |                      |                                             |
--      --------------------------------------------------------------------------------------------
--      |                                   Source IP Address                                      |
--      |                                                                                          |
--      --------------------------------------------------------------------------------------------
--      |                                 Destination IP Address                                   |
--      |                                                                                          |
--      --------------------------------------------------------------------------------------------
--      |                          Options (if any - ignored)               |       Padding        |
--      |                                                                   |      (if needed)     |
--      --------------------------------------------------------------------------------------------
--      |                                          Data                                            |
--      |                                                                                          |
--      --------------------------------------------------------------------------------------------
--      |                                          ....                                            |
--      |                                                                                          |
--      --------------------------------------------------------------------------------------------
--
-- * - in 32 bit words
-- 

architecture rtl of IPv4_TX is 

  type tx_state_type is (
    IDLE,
    GET_MAC,                            -- waiting for response from ARP for mac lookup
    SEND_HDR,                           -- sending the ethernet/IP header
    SEND_USR_DATA                       -- sending the users data
  );

  constant cntLength            : integer := 12;    -- length of counters
  signal wordCntCount           : std_logic;
  signal wordCntRst             : std_logic;
  signal wordCntData            : std_logic_vector(cntLength-1 downto 0);

  -- Configuration
  constant IP_TTL               : std_logic_vector (7 downto 0) := x"80";

  -- TX state variables
  signal tx_state, next_tx_state : tx_state_type;

  signal total_length           : std_logic_vector (15 downto 0);
  signal set_tx_mac             : std_logic;
  signal tx_mac, tx_mac_reg     : std_logic_vector(47 downto 0) := (others => '0');
  signal mac_lookup_req_i       : std_logic;

  signal hdr_checksum           : std_logic_vector(15 downto 0) := (others => '1');

begin  -- rtl

  total_length <= std_logic_vector(unsigned(ip_tx.hdr.data_length) + 20);      
  
  tx_sequential : process (clk.tx_clk, clk.tx_reset)
  begin
    if clk.tx_reset = '1' then
      tx_state <= IDLE;
    elsif rising_edge(clk.tx_clk) then 
      tx_state <= next_tx_state;
    end if;     
  end process;

  tx_comb : process(tx_state, wordCntData,
                    ip_tx_start, mac_tx_tready,
                    arp_req_rslt.got_mac, ip_tx.data.tvalid,
                    tx_mac_reg, udp_conf,
                    total_length, hdr_checksum)
  begin
    wordCntRst          <= '1';
    wordCntCount        <= '0';
    ip_tx_tready        <= '0';
    set_tx_mac          <= '0';
    tx_mac              <= (others => 'X');
    mac_lookup_req_i    <= '0';
    mac_tx.tvalid       <= '0';
    mac_tx.tdata        <= (others => 'X');
    mac_tx.tlast        <= '0';
    ip_tx_tready        <= '0';
    case tx_state is
      when IDLE =>
        if ip_tx_start = '1' then
          if unsigned(ip_tx.hdr.data_length) <= MAX_IP_PAYLOAD_LENGTH then -- 1480 then
            if ip_tx.hdr.dst_ip_addr = IP_BC_ADDR then
              tx_mac <= MAC_BC_ADDR;
              set_tx_mac <= '1';
              next_tx_state <= SEND_HDR;
            else
              mac_lookup_req_i <= '1';
              next_tx_state <= GET_MAC;
            end if;
          end if;
        end if;
      when GET_MAC =>
        if arp_req_rslt.got_mac = '1' then
           tx_mac <= arp_req_rslt.mac;
           set_tx_mac <= '1';
           next_tx_state <= SEND_HDR;
        end if;
      when SEND_HDR =>
        wordCntRst <= '0';
        if mac_tx_tready = '1' then
          wordCntCount <= '1';
          mac_tx.tvalid <= '1';
          mac_tx.tlast <= '0';
          mac_tx.tkeep <= (others => '1');
          case wordCntData is
            when x"001" => -- send MAC
              mac_tx.tdata <= ( tx_mac_reg & udp_conf.mac_address(47 downto 32) );
            when x"002" => -- send MAC 
              mac_tx.tdata <= ( udp_conf.mac_address(31 downto 0) & IPV4_FRAME_TYPE & x"4500" );       
            when x"003" => -- length & flags
              mac_tx.tdata <= ( total_length & x"00000000" & IP_TTL & ip_tx.hdr.protocol);
            when x"004" => -- IP
              mac_tx.tdata <= ( hdr_checksum & udp_conf.ip_address & ip_tx.hdr.dst_ip_addr(31 downto 16) );
            when x"005" => -- IP
              mac_tx.tdata <= ( ip_tx.hdr.dst_ip_addr(15 downto 0) & x"000000000000" ); 
              next_tx_state <= SEND_USR_DATA;       
            when others => null;
          end case;
        end if; 
      when SEND_USR_DATA =>
        ip_tx_tready <= mac_tx_tready;
        mac_tx.tvalid <= ip_tx.data.tvalid;
        mac_tx.tlast <= ip_tx.data.tlast;
        mac_tx.tkeep <= ip_tx.data.tkeep;
        if ip_tx.data.tvalid = '1' then
          wordCntCount <= '1';
          if ip_tx.data.tlast = '1' then
            next_tx_state <= IDLE;
          end if;
        end if; 
      when others => null;
    end case;
  end process;

  latch_mac : process(clk.tx_clk)
  begin
    if rising_edge(clk.tx_clk) then
      if set_tx_mac = '1' then
        tx_mac_reg <= tx_mac;   
      end if;
    end if;
  end process;

  word_cnt : entity work.counter
    generic map ( length => cntLength,
                  preset => 1 )
    port map (
      clk  => clk.tx_clk,
      rst  => wordCntRst,
      data => wordCntData,
      cnt  => wordCntCount );

  -- set arp signals
  arp_req_req.lookup_req <= mac_lookup_req_i;
  arp_req_req.ip <= ip_tx.hdr.dst_ip_addr;
  
end rtl;
