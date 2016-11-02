----------------------------------------------------------------------------------
-- Company: 
-- Engineer:            Peter Fall
-- 
-- Create Date:    14 July 2014
-- Design Name: 
-- Module Name:    arp_rx - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:
--              handle receipt of arp pkt - 10GE version.
--              ignores other types of pkt
--
--              When it receives an ARP pkt that is either addressed to our IP or is a global request,
--              it outputs for a single clock cycle either recv_who_has or recv_I_have along
--              with associated mac or arp entry data.
--
--              Note that if recv who_has and we have it, then we also assert I_have so that we can cache the rev lookup
--              on the expectation that we will want to reply to this host.
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created - refactored from Open Cores UDP_IP_Stack 1G project
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.axi_types.all;
use work.arp_types.all;
use work.xUDP_Common_pkg.all;

entity arp_rx is
    port (
        -- MAC layer RX signals
        data_in                 : in axi4_dvlk64_t; -- ethernet frame (from dst mac addr through to last word of frame)
        -- ARP output signals
        recv_who_has            : out std_logic;    -- pulse will be latched
        arp_entry_for_who_has   : out arp_entry_t;  -- target for who_has msg (Iie, who to reply to)
        recv_I_have             : out std_logic;    -- pulse will be latched
        arp_entry_for_I_have    : out arp_entry_t;  -- arp target for I_have msg
        -- control and status signals
        req_count               : out std_logic_vector(7 downto 0);   -- count of arp pkts received
        -- system signals
        cfg                     : in xUDP_CONIGURATION_T; -- system config
        clk                     : in  std_logic;
        reset                   : in  std_logic
    );
end arp_rx;


architecture Behavioral of arp_rx is

    type rx_state_t is (IDLE, PARSE, PROCESS_ARP, WAIT_END);
    type count_mode_t is (RST, INCR, HOLD);
    type arp_oper_t is (NOP, REQUEST, REPLY);
    type arp_save_t is (NOP, MAC_HIGH, MAC_LOW_IP);
    type set_clr_t is (NOP,SET,CLR);

    type tx_state_type is (IDLE, WAIT_MAC, SEND);

    -- state variables
    signal send_request_needed : std_logic;
    signal tx_mac_chn_reqd     : std_logic;
    signal eop_reg     : std_logic;
    signal rx_state        : rx_state_t;
    signal rx_count       : unsigned (2 downto 0);
    signal arp_operation   : arp_oper_t;
    signal arp_req_count   : unsigned (7 downto 0);
    signal new_arp_entry   : arp_entry_t;

    -- FIXME        - remove these debug state signals
    signal arp_err_data : axi4_dvlk64_t;
    signal set_err_data : std_logic;

--    attribute keep                 : string;
--    attribute keep of arp_err_data : signal is "true";

    -- busses
    signal next_rx_state   : rx_state_t;
    -- controls
    signal rx_count_mode   : count_mode_t;
    signal set_arp_oper   : std_logic;
    signal arp_oper_set_val  : arp_oper_t;
    signal count_arp_rcvd   : std_logic;
    signal arp_save     : arp_save_t;
    signal set_eop     : set_clr_t;
  
--  +-word-+63----56|55----48|47----40|39----32|31----24|23----16|15----08|07----00+
--    |      |                                                     |                 |
--    | 0    |               target mac                            | src mac (47..32)|
--    |      |                                                     |                 |
--    |------|-----------------------------------------------------------------------|
--    |      |                                   |                 |        |        |
--    | 1    |           src mac (32..0)         |   pkt type      |arp type| HW type|
--    |      |                                   |                 |        |        |
--    |------|-----------------------------------------------------------------------|
--    |      |                 |        |        |                 |                 |
--    | 2    |        prot     | HW     | prot   |    opcode       |  SHA (47..32)   |
--    |      |                 | size   | size   |                 |                 |
--    |------|-----------------------------------------------------------------------|
--    |      |                                   |                                   |
--    | 3    |    SHA (sender HW addr) (31..0)   |   SPA (sender PROT addr) (31..0)  |
--    |      |                                   |                                   |
--    |------|-----------------------------------------------------------------------|
--    |      |                                                     |                 |
--    | 4    |         THA (target HW addr) (47..0)                |  TPA  (31..16)  |
--    |      |                                                     |                 |
--    |------|-----------------+-----------------------------------------------------+
--    |      |                 |
--    | 5    |   TPA (15..0)   |
--    |      |                 |
--    +------+-----------------+

begin

rx_combinatorial : process (
    -- input signals
    data_in, cfg,
    -- state variables
    rx_state, rx_count, arp_operation, arp_req_count, arp_err_data, new_arp_entry, eop_reg, 
    -- busses
    next_rx_state, 
    -- control signals
    rx_count_mode, set_arp_oper, arp_oper_set_val,
    arp_save, set_err_data, count_arp_rcvd, set_eop
)
begin
    -- set output followers
    req_count <= std_logic_vector(arp_req_count);

    -- set defaults for combinatorial outputs
    recv_who_has              <= '0';
    arp_entry_for_who_has.ip  <= (others => '0');
    arp_entry_for_who_has.mac <= (others => '0');
    recv_I_have               <= '0';
    arp_entry_for_I_have.ip   <= (others => '0');
    arp_entry_for_I_have.mac  <= (others => '0');

    -- set bus defaults
    next_rx_state    <= rx_state;
    -- set control defaults
    rx_count_mode    <= HOLD;
    set_arp_oper     <= '0';
    arp_oper_set_val <= NOP;
    arp_save   <= NOP;
    count_arp_rcvd   <= '0';
    set_err_data     <= '0';
    if data_in.tvalid = '1' and data_in.tlast = '1' then
    set_eop <= SET;
    else
    set_eop <= NOP;
    end if;
 
    -- RX FSM
    case rx_state is
      when IDLE =>
        rx_count_mode <= RST;
        set_eop <= CLR;
        if data_in.tvalid = '1' then
            next_rx_state <= PARSE;
            rx_count_mode <= INCR;
        end if;

      when PARSE =>
        if data_in.tvalid = '1' then
            rx_count_mode <= INCR;
            -- handle early frame termination as default case
     
            case (to_integer(rx_count)) is
              when 1 =>
                --  +-word-+63----56|55----48|47----40|39----32|31----24|23----16|15----08|07----00+
                --    | 1  |           src mac (32..0)         |   pkt type      |arp type| HW type|
                if data_in.tdata(31 downto 0) /= x"08060001" then
                    -- pkt type not ARP or HW type not 0001
                    set_err_data  <= '1';
                    next_rx_state <= WAIT_END;
                end if;
                if data_in.tlast = '1' then
                    set_err_data  <= '1';
                    next_rx_state <= IDLE;
                    rx_count_mode <= RST;
                end if;

              when 2 =>
                --  +-word-+63----56|55----48|47----40|39----32|31----24|23----16|15----08|07----00+
                --  |   2  |        prot     | HW     | prot   |    opcode       |  SHA (47..32)   |
                case data_in.tdata(31 downto 16) is
                    when x"0001" =>         
                        arp_oper_set_val <= REQUEST;
                        set_arp_oper     <= '1';
                    when x"0002" =>
                        arp_oper_set_val <= REPLY;
                        set_arp_oper     <= '1';
                    when others =>
                        -- arp operation not supported
                        set_err_data  <= '1';
                        next_rx_state <= WAIT_END;
                end case;
                arp_save <= MAC_HIGH;
                if data_in.tdata(63 downto 32) /= x"08000604" then
                    -- prot not IP or addr sizes not supported
                    set_err_data  <= '1';
                    next_rx_state <= WAIT_END;
                end if;
                if data_in.tlast = '1' then
                    set_err_data  <= '1';
                    next_rx_state <= IDLE;
                    rx_count_mode <= RST;
                end if;

              when 3 =>
                --  +-word-+63----56|55----48|47----40|39----32|31----24|23----16|15----08|07----00+
                --    | 3  |    SHA (sender HW addr) (31..0)   |   SPA (sender PROT addr) (31..0)  |
                arp_save <= MAC_LOW_IP;
                if data_in.tlast = '1' then
                    set_err_data  <= '1';
                    next_rx_state <= IDLE;
                    rx_count_mode <= RST;
                end if;

              when 4 =>
                --  +-word-+63----56|55----48|47----40|39----32|31----24|23----16|15----08|07----00+
                --    | 4  |         THA (target HW addr) (47..0)                |  TPA  (31..16)  |
                if data_in.tdata(15 downto 0) /= cfg.ip_address(31 downto 16) then
                    -- not addressed to us
                    next_rx_state <= WAIT_END;
                end if;
                if data_in.tlast = '1' then
                    set_err_data  <= '1';
                    next_rx_state <= IDLE;
                    rx_count_mode <= RST;
                end if;
     
              when 5 =>
                --  +-word-+63----56|55----48|47----40|39----32|31----24|23----16|15----08|07----00+
                --    | 5  |   TPA (15..0)   |
                if data_in.tdata(63 downto 48) /= cfg.ip_address(15 downto 0) then
                    -- not addressed to us
                    if data_in.tlast = '1' then
                        next_rx_state <= IDLE;
                        rx_count_mode <= RST;
                    else
                        -- maybe there are some options being transmitted. Just ignore them.
                        next_rx_state <= WAIT_END;
                    end if;
                else
                    next_rx_state <= PROCESS_ARP;
                end if;

              when others =>  -- do nothing
            end case;
        end if;

    when PROCESS_ARP =>
        case arp_operation is
            when NOP =>                   -- (nothing to do)

            when REQUEST =>
                count_arp_rcvd        <= '1';
                recv_who_has          <= '1';
                arp_entry_for_who_has <= new_arp_entry;
                -- setting I_Have as well allows us to cache the remote node's entry immediately
                recv_I_have           <= '1';
                arp_entry_for_I_have  <= new_arp_entry;
     
            when REPLY =>
                count_arp_rcvd       <= '1';
                recv_I_have          <= '1';
                arp_entry_for_I_have <= new_arp_entry;
     
        end case;
        arp_oper_set_val <= NOP;
        set_arp_oper     <= '1';
        if data_in.tlast = '1' or eop_reg = '1' then
            next_rx_state <= IDLE;
            rx_count_mode <= RST;
        else
            next_rx_state <= WAIT_END;
        end if;

    when WAIT_END =>
        if data_in.tvalid = '1' then
            if data_in.tlast = '1' then
                next_rx_state <= IDLE;
                rx_count_mode <= RST;
            end if;
        end if;

    end case;
    
end process;

rx_sequential : process (clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            -- reset state variables
            rx_state   <= IDLE;
            rx_count   <= "000";
            arp_operation <= NOP;
            arp_req_count <= x"00";
            arp_err_data <= empty_axi4_dvlk64;
            eop_reg   <= '0';
        else
            -- Next rx_state processing
            rx_state <= next_rx_state;

            -- eop processing
            case set_eop is
                when SET => eop_reg <= '1';
                when CLR => eop_reg <= '0';
                when NOP => -- do nothing
            end case;

            -- rx_count processing
            case rx_count_mode is
                when RST  => rx_count <= "000";
                when INCR => rx_count <= rx_count + 1;
                when HOLD => rx_count <= rx_count;
            end case;

            -- err data
            if set_err_data = '1' then
                arp_err_data <= data_in;
            end if;

            -- arp operation processing
            if set_arp_oper = '1' then
                arp_operation <= arp_oper_set_val;
            end if;

            -- data capture
            case arp_save is
                when MAC_HIGH => 
                    new_arp_entry.mac(47 downto 32) <= data_in.tdata(15 downto 0);

                when MAC_LOW_IP => 
                new_arp_entry.mac(31 downto 0) <= data_in.tdata(63 downto 32);
                new_arp_entry.ip <= data_in.tdata(31 downto 0);

                when NOP => -- nothing to do
            end case;

            -- set arp entry request
            if count_arp_rcvd = '1' then
                -- count another ARP pkt received
                arp_req_count <= arp_req_count + 1;
            end if;

        end if;
    end if;
end process;

end Behavioral;

