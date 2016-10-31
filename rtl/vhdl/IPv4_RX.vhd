-- Filename            : IP_RX.vhd
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
use work.axi_types.all;
use work.ipv4_types.all;
use work.xUDP_Common_pkg.all;

entity IPv4_RX is
  port (
    -- IP Layer signals
    ip_rx                       : out ipv4_rx_type;
    ip_rx_start                 : out std_logic;                        -- indicates receipt of ip frame.
    -- system signals
    clk                         : in  std_logic;                        -- same clock used to clock mac data and ip data
    rst                         : in  std_logic;
    our_ip_address              : in  std_logic_vector (31 downto 0);
    rx_pkt_count                : out std_logic_vector(7 downto 0);     -- number of IP pkts received for us
    -- MAC layer RX signals
    mac_rx                      : in axi4_dvlk64_t
    );                  

end IPv4_RX;

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
architecture rtl  of IPv4_RX is
  type rx_state_type is (IDLE, HDR, USER_DATA, WAIT_END, ERR);
  signal rx_state : rx_state_type := IDLE;
  signal next_rx_state : rx_state_type := IDLE;

  constant IP_HEADER_SIZE       : integer := 20;

  constant cntLength            : integer := 8;    -- length of counters
  signal wordCntCount           : std_logic;
  signal wordCntRst             : std_logic;
  signal wordCntData            : std_logic_vector(cntLength-1 downto 0);
  signal frameCntCount          : std_logic;
  signal frameCntData           : std_logic_vector(cntLength-1 downto 0);
  signal errCntCount            : std_logic;
  signal errCntData             : std_logic_vector(cntLength-1 downto 0);

  signal set_src_ip             : std_logic := '0';    
  signal set_dest_ip_l          : std_logic := '0';
  signal set_dest_ip_h          : std_logic := '0';
  signal set_protocol           : std_logic;
  signal dest_ip_addr_i         : std_logic_vector(31 downto 0);
  signal rx_err_i               : std_logic_vector(3 downto 0);

  constant OUR_IP_PROTOCOL      : std_logic_vector(15 downto 0) := x"0800";
  constant OUR_HEADER           : std_logic_vector(7 downto 0) := x"45";
  alias protocol                : std_logic_vector(15 downto 0) is mac_rx.tdata(31 downto 16);
  alias src_ip_addr             : std_logic_vector(31 downto 0) is mac_rx.tdata(47 downto 16);
  alias dest_ip_addr_h          : std_logic_vector(15 downto 0) is mac_rx.tdata(15 downto 0);
  alias dest_ip_addr_l          : std_logic_vector(15 downto 0) is mac_rx.tdata(63 downto 48);
  alias version_header          : std_logic_vector(7 downto 0) is mac_rx.tdata(15 downto 8);
  alias data_length             : std_logic_vector(15 downto 0) is mac_rx.tdata(63 downto 48);

  signal tkeep_i                : std_logic_vector(7 downto 0);
  signal tvalid_i               : std_logic;

  signal pkt_ignore             : std_logic;

  signal set_length             : std_logic;
  
begin  -- rtl 


  rx_comb : process(rx_state, mac_rx.tvalid, mac_rx.tlast, mac_rx.tdata)
  begin
    wordCntRst          <= '0';
    frameCntCount       <= '0';
    errCntCount         <= '0';
    set_src_ip          <= '0';
    set_dest_ip_h       <= '0';
    set_dest_ip_l       <= '0';
    set_protocol        <= '0';
    set_length          <= '0';
    rx_err_i            <= RX_EC_NONE;
    tkeep_i             <= (others => 'X');
    tvalid_i            <= '0';
    next_rx_state       <= rx_state;
    case rx_state is
      when IDLE =>
        wordCntRst          <= '1';
        if mac_rx.tvalid = '1' then
          wordCntRst        <= '0';
          frameCntCount     <= '1';
          next_rx_state     <= HDR;
        end if;
        
      when HDR =>
        if mac_rx.tvalid = '1' then
          if mac_rx.tlast = '1' then    -- early frame termination
            rx_err_i <= RX_EC_ET_ETH; 
            next_rx_state <= ERR;
          else
            case wordCntData is
              when x"01" =>             -- do nothing
              when x"02" =>
                if protocol /= OUR_IP_PROTOCOL or version_header /= OUR_HEADER then
                  set_protocol <= '1';
                  next_rx_state <= WAIT_END; 
                end if;
              when x"03" =>
                set_length <= '1';
              when x"04" =>
                set_src_ip <= '1';
                set_dest_ip_h <= '1';
              when x"05" =>
                set_dest_ip_l <= '1';
                tvalid_i <= '1';       
                tkeep_i <= "00111111";
                next_rx_state <= USER_DATA;
              when others =>            -- do nothing
            end case;
          end if;
        end if;
        
      when USER_DATA =>
        tvalid_i <= '1';
        tkeep_i <=  mac_rx.tkeep; 
        if mac_rx.tvalid = '1' then
          if mac_rx.tlast = '1' then
            next_rx_state <= IDLE;
          end if;
        end if;
        
      when WAIT_END =>                  -- not a frame for us
        if mac_rx.tvalid = '1' then
          if mac_rx.tlast = '1' then
            next_rx_state <= IDLE;    
          end if;
        end if;
        
      when ERR =>
        errCntCount <= '1';
        next_rx_state <= IDLE;
        
      when others =>
        next_rx_state <= IDLE;      
    end case;
  end process;        

  ----------------------------------------------------------------------------
  -- sequential process to action control signals and change states and outputs
  -----------------------------------------------------------------------------
  rx_sequential : process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        rx_state <= IDLE;
      else
        rx_state <= next_rx_state;
      end if;
    end if;     
  end process;

  word_cnt : entity work.counter
    generic map ( length => 8,
                  preset => 1 )
    port map (
      clk  => clk,
      rst  => wordCntRst,
      data => wordCntData,
      cnt  => wordCntCount );
  
  frame_cnt : entity work.counter
    generic map ( length => 8 )
    port map (
      clk  => clk,
      rst  => rst,
      data => frameCntData,
      cnt  => frameCntCount );

  err_frame_cnt : entity work.counter
    generic map ( length => 8 )
    port map (
      clk  => clk,
      rst  => rst,
      data => errCntData,
      cnt  => errCntCount );
  
  latch_length : process(clk)
  begin
    if rising_edge(clk) then
      if set_length = '1' then
        ip_rx.hdr.data_length <= std_logic_vector(unsigned(data_length) - IP_HEADER_SIZE);
      end if;   
    end if;     
  end process;
  
  ip_rx.hdr.num_frame_errors <= errCntData;

  latch_src_ip : process(clk)
  begin
    if rising_edge(clk) then
      if set_src_ip = '1' then
        ip_rx.hdr.src_ip_addr <= src_ip_addr;
      end if;   
    end if;
  end process;

  latch_protocol : process(clk)
  begin
    if rising_edge(clk) then
      if set_protocol = '1' then
        ip_rx.hdr.protocol <= protocol(15 downto 8);
      end if;   
    end if;
  end process;

  process_dest_ip : process(clk)
    variable pkt_ignore_v : std_logic := '0';
    variable pkt_brdcst_v : std_logic := '0';
  begin
    if rising_edge(clk) then
      if set_dest_ip_h = '1' then
         dest_ip_addr_i(31 downto 16) <= dest_ip_addr_h;   
      end if;
      if set_dest_ip_l = '1' then
         dest_ip_addr_i(15 downto 0) <= dest_ip_addr_l;   
      end if;
      if dest_ip_addr_i = IP_BC_ADDR then
        pkt_ignore_v := '0';
        pkt_brdcst_v := '1';
      elsif dest_ip_addr_i = our_ip_address then
        pkt_ignore_v := '0';
        pkt_brdcst_v := '0';
      else
        pkt_ignore_v := '1';
        pkt_brdcst_v := '0';
      end if;
    end if;
    ip_rx.hdr.is_broadcast <= pkt_brdcst_v;
    ip_rx.hdr.is_valid <= not pkt_ignore_v;  --tbc
    pkt_ignore <= pkt_ignore_v;
  end process;

 
  
  out_bus : process(clk)
  begin  -- process
    if rising_edge(clk) then
      ip_rx.data.tdata <= mac_rx.tdata;
      ip_rx.data.tvalid <= tvalid_i;
      ip_rx.data.tlast <= mac_rx.tlast;
      ip_rx.data.tkeep <= tkeep_i;
    end if;
  end process;
     
  wordCntCount <= mac_rx.tvalid;
  rx_pkt_count <= frameCntData;
  
end rtl ;
