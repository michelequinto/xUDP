----------------------------------------------------------------------------------
-- Company: 
-- Engineer:            Peter Fall
-- 
-- Create Date:    11 July 2014 
-- Design Name: 
-- Module Name:    arp_tx - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:
--              handle transmission of an ARP packet - 10GE version.
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created - refactored this arp_tx module from the complete arp v0.02 module
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.axi_types.all;
use work.arp_types.all;
use work.xUDP_Common_pkg.all;


entity arp_tx is
    generic (
        TIMEOUT_CLKS    : integer := 200    -- # time allowed to tx before abort
      );
    port (
        -- control signals
        send_I_have     : in  std_logic;    -- pulse will be latched
        arp_entry       : in  arp_entry_t;  -- arp target for I_have req (will be latched)
        send_who_has    : in  std_logic;    -- pulse will be latched
        ip_entry        : in  std_logic_vector (31 downto 0);  -- IP target for who_has req (will be latched)
        -- MAC layer TX signals
        mac_tx_req      : out std_logic;  -- indicates that ip wants access to channel (stays up for as long as tx)
        mac_tx_granted  : in  std_logic;  -- indicates that access to channel has been granted            
        data_out_ready  : in  std_logic;    -- indicates system ready to consume data
        data_out        : out axi4_dvlk64_t;
        -- system signals
        cfg             : in xUDP_CONIGURATION_T; -- system config
        clk             : in  std_logic;
        reset           : in  std_logic
    );
end arp_tx;

architecture Behavioral of arp_tx is

    type count_mode_t is (RST, INCR, HOLD);
    type dcount_mode_t is (SET, DECR, HOLD);
    type set_clr_t is (SET, CLR, HOLD);
    type tx_state_t is (IDLE, SEND);
    type tx_mode_t is (REPLY, REQUEST);

    -- state variables
    signal tx_mac_chn_reqd  : std_logic;
    signal tx_state         : tx_state_t;
    signal tx_count         : unsigned(2 downto 0);
    signal send_I_have_reg  : std_logic;
    signal send_who_has_reg : std_logic;
    signal I_have_target    : arp_entry_t;  -- latched target for "I have" request
    signal who_has_target   : std_logic_vector (31 downto 0);  -- latched IP for "who has" request
    signal tx_mode          : tx_mode_t;  -- what sort of tx to make
    signal target           : arp_entry_t;  -- target to send to
    signal timer            : unsigned(7 downto 0); -- down counter which stops at 0

    -- busses
    signal next_tx_state   : tx_state_t;
    signal tx_mode_val    : tx_mode_t;
    signal target_val    : arp_entry_t;

    -- tx control signals
    signal tx_count_mode       : count_mode_t;
    signal set_chn_reqd        : set_clr_t;
    signal set_send_I_have     : set_clr_t;
    signal set_send_who_has    : set_clr_t;
    signal set_tx_mode         : std_logic;
    signal set_target          : std_logic;
    signal set_timer           : dcount_mode_t;

-- big endian encoding
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

tx_combinatorial : process (
    -- input signals
    send_I_have, send_who_has, arp_entry, ip_entry, data_out_ready, mac_tx_granted,
    cfg, reset,
    -- state variables
    tx_state, tx_count, tx_mac_chn_reqd, I_have_target, who_has_target,
    send_I_have_reg, send_who_has_reg, tx_mode, target, timer, 
    -- busses
    next_tx_state, tx_mode_val, target_val,
    -- control signals
    tx_count_mode, set_send_I_have, set_send_who_has,
    set_chn_reqd, set_tx_mode, set_target, set_timer
)
begin
    -- set output followers
    mac_tx_req <= tx_mac_chn_reqd;

    -- set combinatorial output defaults
    data_out <= empty_axi4_dvlk64;

    -- set bus defaults
    next_tx_state  <= tx_state;
    tx_mode_val    <= REPLY;
    target_val.ip  <= (others => '0');
    target_val.mac <= (others => '1');

    -- set control defaults
    tx_count_mode       <= HOLD;
    set_chn_reqd        <= HOLD;
    set_send_I_have     <= HOLD;
    set_send_who_has    <= HOLD;
    set_tx_mode         <= '0';
    set_target          <= '0';
    set_timer           <= HOLD;

    -- process requests in regardless of FSM state
    if send_I_have = '1' then
        set_send_I_have <= SET;
    end if;
    if send_who_has = '1' then
        set_send_who_has <= SET;
    end if;

    -- TX FSM
    case tx_state is
        when IDLE =>
            tx_count_mode <= RST;
            if send_I_have_reg = '1' then
                set_chn_reqd    <= SET;
                tx_mode_val     <= REPLY;
                set_tx_mode     <= '1';
                target_val      <= I_have_target;
                set_target      <= '1';
                set_send_I_have <= CLR;
                next_tx_state   <= SEND;--WAIT_MAC;
                set_timer       <= SET;
            elsif send_who_has_reg = '1' then
                set_chn_reqd     <= SET;
                tx_mode_val      <= REQUEST;
                set_tx_mode      <= '1';
                target_val.ip    <= who_has_target;
                target_val.mac   <= (others => '1');
                set_target       <= '1';
                set_send_who_has <= CLR;
                next_tx_state    <= SEND;--WAIT_MAC;
                set_timer        <= SET;
            else
                set_chn_reqd <= CLR;
            end if;

        --when WAIT_MAC =>
        --    tx_count_mode <= RST;
        --    data_out.tvalid <= '1';
        --    if mac_tx_granted = '1' then
        --        next_tx_state <= SEND;
        --    end if;
        --    set_timer <= DECR;
        --    if timer = x"00" then
        --        next_tx_state <= IDLE;
        --        set_chn_reqd <= SET;
        --    end if;

        when SEND =>
            data_out.tvalid <= '1';
                   
            if data_out_ready = '1' then  -- count words
              tx_count_mode <= INCR;
            end if;
            
            case to_integer(tx_count) is

              when 0 =>
                --  +-word-+63----56|55----48|47----40|39----32|31----24|23----16|15----08|07----00+
                --    | 0  |               target mac                            | src mac (47..32)|
                data_out.tdata(63 downto 16) <= target.mac;                     -- DEST MAC
                data_out.tdata(15 downto 0)  <= cfg.mac_address (47 downto 32); -- SRC MAC (top 16 bits)

              when 1 =>
                --  +-word-+63----56|55----48|47----40|39----32|31----24|23----16|15----08|07----00+
                --    | 1  |           src mac (32..0)         |   pkt type      |arp type| HW type|
                data_out.tdata(63 downto 32) <= cfg.mac_address (31 downto 0); -- SRC MAC (next 32 bits)
                data_out.tdata(31 downto 0)  <= x"08060001"; -- pkt type = 0806 : ARP, HW type = 0001 : eth

              when 2 =>
                --  +-word-+63----56|55----48|47----40|39----32|31----24|23----16|15----08|07----00+
                --    | 2  |        prot     | HW     | prot   |    opcode       |  SHA (47..32)   |
                data_out.tdata(63 downto 32) <= x"08000604"; -- protocol = 0800 : ip, HW/prot size = 6/4
                if tx_mode = REPLY then
                    data_out.tdata(31 downto 16) <= x"0002"; -- opcode = 02 : REPLY
                else
                    data_out.tdata(31 downto 16) <= x"0001"; -- opcode = 01 : REQ
                end if;
                data_out.tdata(15 downto 0)  <= cfg.mac_address (47 downto 32); -- SHA (sender HW addr)

              when 3 =>
                --  +-word-+63----56|55----48|47----40|39----32|31----24|23----16|15----08|07----00+
                --    | 3  |    SHA (sender HW addr) (31..0)   |   SPA (sender PROT addr) (31..0)  |
                data_out.tdata(63 downto 32)  <= cfg.mac_address (31 downto 0); -- SHA (sender HW addr)
                data_out.tdata(31 downto 0)  <= cfg.ip_address;       -- SPA (sender prot addr)

              when 4 =>
                --  +-word-+63----56|55----48|47----40|39----32|31----24|23----16|15----08|07----00+
                --    | 4  |         THA (target HW addr) (47..0)                |  TPA  (31..16)  |
                data_out.tdata(63 downto 16)  <= target.mac;        -- THA (target HW addr)
                data_out.tdata(15 downto 0)   <= target.ip(31 downto 16);     -- TPA (target prot addr)

              when 5 =>
                --  +-word-+63----56|55----48|47----40|39----32|31----24|23----16|15----08|07----00+
                --    | 5  |   TPA (15..0)   |
                data_out.tdata(63 downto 48)  <= target.ip (15 downto 0);     -- TPA (target prot addr)
                data_out.tlast <= '1';
                data_out.tkeep <= "11000000";
                next_tx_state <= IDLE;

              when 6 =>
                data_out.tvalid <= '0';
                set_chn_reqd <= CLR;
                next_tx_state <= IDLE;

              when others =>
                next_tx_state <= IDLE;
            end case;
            set_timer <= DECR;
            if timer = x"00" then
                next_tx_state <= IDLE;
                set_chn_reqd <= SET;
            end if;

        end case;
end process;

tx_sequential : process (clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            -- reset state variables
            tx_state          <= IDLE;
            tx_count          <= (others => '0');
            tx_mac_chn_reqd   <= '0';
            send_I_have_reg   <= '0';
            send_who_has_reg  <= '0';
            who_has_target    <= (others => '0');
            I_have_target.ip  <= (others => '0');
            I_have_target.mac <= (others => '0');
            target.ip         <= (others => '0');
            target.mac        <= (others => '1');
            timer <= (others => '0');
            
        else
        -- normal (non reset) processing

        -- Next tx_state processing
        tx_state <= next_tx_state;

        -- input request latching
        case set_send_I_have is
          when SET =>
            send_I_have_reg <= '1';
            I_have_target   <= arp_entry;
          when CLR =>
            send_I_have_reg <= '0';
            I_have_target   <= I_have_target;
          when HOLD =>
            send_I_have_reg <= send_I_have_reg;
            I_have_target   <= I_have_target;
        end case;

        case set_send_who_has is
          when SET =>
            send_who_has_reg <= '1';
            who_has_target   <= ip_entry;
          when CLR =>
            send_who_has_reg <= '0';
            who_has_target   <= who_has_target;
          when HOLD =>
            send_who_has_reg <= send_who_has_reg;
            who_has_target   <= who_has_target;
        end case;

        -- tx mode
        if set_tx_mode = '1' then
            tx_mode <= tx_mode_val;
        end if;

        -- target latching
        if set_target = '1' then
            target <= target_val;
        end if;

        -- tx_count processing
        case tx_count_mode is
          when RST =>  tx_count <= "000";
          when INCR => tx_count <= tx_count + 1;
          when HOLD => tx_count <= tx_count;
        end case;

        -- timer processing
        case set_timer is
          when SET =>  timer <= to_unsigned(TIMEOUT_CLKS,8);
          when DECR => 
            if timer /= x"00" then
                timer <= timer - 1;
            end if;
          when HOLD => -- do nothing;
        end case;

        -- control access request to mac tx chn
        case set_chn_reqd is
          when SET  => tx_mac_chn_reqd <= '1';
          when CLR  => tx_mac_chn_reqd <= '0';
          when HOLD => tx_mac_chn_reqd <= tx_mac_chn_reqd;
        end case;

    end if;
end if;
end process;


end Behavioral;

