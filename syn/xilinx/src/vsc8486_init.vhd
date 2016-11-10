----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:05:31 08/13/2012 
-- Design Name: 
-- Module Name:    vsc8486_init - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vsc8486_init is
    Port ( reset : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           phy_reset : out  STD_LOGIC;
           init_done : out  STD_LOGIC;
           cmd_read : out  STD_LOGIC;
           cmd_write : out  STD_LOGIC;
           cmd_write_data_valid : in  STD_LOGIC;
           cmd_prtdev_address : out  STD_LOGIC_VECTOR (9 downto 0);
           cmd_address : out  STD_LOGIC_VECTOR (15 downto 0);
           cmd_data : out  STD_LOGIC_VECTOR (15 downto 0));
end vsc8486_init;

architecture Behavioral of vsc8486_init is

	type state_type is (stRESET, stWAIT0, stWRsetup, stWRwait0, stWRwait1, stDONE);
	signal state : state_type;
	signal counter : std_logic_vector(15 downto 0);
	
	-- number of registers to write during initialisation
	constant mem_depth : integer := 2;
	
	type phy_reg_item is record
		addr : std_logic_vector(23 downto 0);	-- register address (including device address)
		data : std_logic_vector(15 downto 0);	-- register value
	end record;
	type init_rom_type is array (0 to mem_depth-1) of phy_reg_item;
	
	-- initialization rom containing register address (including device address) and value 
	signal init_rom : init_rom_type := 
	(
		(x"018000", x"B55F"),	-- invert TX (critical)
		(x"01E901", x"283A")		-- set activity LEDs (non-critical)
	);
	
	alias cmd_dev_address : std_logic_vector(4 downto 0) is cmd_prtdev_address(4 downto 0);
	alias cmd_prt_address : std_logic_vector(4 downto 0) is cmd_prtdev_address(9 downto 5);
	
begin

	init_done <= '1' when state = stDONE else '0';
--	cmd_prtdev_address <= "0000000001";
	cmd_prt_address <= "00000";
	cmd_read <= '0';
	
	phy_reset <= '1' when state = stRESET else '0';
	
	process(clk, reset)
	begin
		if reset = '1' then
			cmd_write <= '0';
			cmd_address <= x"0000";
			cmd_data <= x"0000";
			cmd_dev_address <= (others => '0');
		elsif clk'event and clk = '1' then
			cmd_write <= '0';
			if state = stWRsetup then
				if counter < mem_depth then
					cmd_dev_address	<= init_rom(conv_integer(counter)).addr(20 downto 16);
					cmd_address 		<= init_rom(conv_integer(counter)).addr(15 downto 0);
					cmd_data 			<= init_rom(conv_integer(counter)).data;
					cmd_write 			<= '1';
				end if;
			end if;
		end if;
	end process;
			

	process(clk, reset)
	begin
		if reset = '1' then
			state <= stRESET;
			counter <= (others => '0');
		elsif clk'event and clk = '1' then
			case state is
				when stRESET =>
					--! stay 100ms in reset
					if counter >= 1000 then 
						state <= stWAIT0;
						counter <= (others => '0');
					else
						counter <= counter + 1;
					end if;
				when stWAIT0 =>
					--! wait 200ms after reset
					if counter >= 2000 then 
						state <= stWRsetup;
						counter <= (others => '0');
					else
						counter <= counter + 1;
					end if;
				when stWRsetup => 
					counter <= counter + 1;
					state <= stWRwait0;
				when stWRwait0 =>
					if cmd_write_data_valid = '1' then
						state <= stWRwait1;
					end if;
				when stWRwait1 =>
					if cmd_write_data_valid = '0' then
						if counter >= mem_depth then
							state <= stDONE;
						else
							state <= stWRsetup;
						end if;
					end if;
				when stDONE =>
					state <= stDONE;
				when others =>
					state <= stRESET;
			end case;
		end if;
	end process;
					
	


end Behavioral;

