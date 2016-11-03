----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:26:30 08/06/2012 
-- Design Name: 
-- Module Name:    mdio_ctrl - Behavioral 
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mdio_ctrl is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           cmd_read : in  STD_LOGIC;
           cmd_write : in  STD_LOGIC;
           prtdev_address : in  STD_LOGIC_VECTOR (9 downto 0);
           address : in  STD_LOGIC_VECTOR (15 downto 0);
           data : in  STD_LOGIC_VECTOR (15 downto 0);
           read_data_valid : out  STD_LOGIC;
           write_data_valid : out  STD_LOGIC;
           mdio_busy : in  STD_LOGIC;
           mdio_opcode : out  STD_LOGIC_VECTOR (1 downto 0);
           mdio_out_valid : out  STD_LOGIC;
           mdio_data_out : out  STD_LOGIC_VECTOR (25 downto 0));
end mdio_ctrl;

architecture Behavioral of mdio_ctrl is
type state_type is (stIDLE, stADDRESS0, stADDRESS1, stOP0, stOP1);
signal state : state_type;

signal wr: std_logic;

begin

	process(clk, reset)
	begin
		if reset = '1' then
			read_data_valid <= '0';
			write_data_valid <= '0';
			mdio_out_valid <= '0';
			wr <= '0';
			mdio_opcode <= (others => '0');
			mdio_data_out <= (others => '0');
			state <= stIDLE;
		elsif clk'event and clk  = '1' then
			case state is
				when stIDLE =>
					write_data_valid <= '0';
					read_data_valid <= '0';
					wr <= '0';
					if mdio_busy = '0' and ((cmd_write or cmd_read)= '1') then
						write_data_valid <= '1';
						mdio_data_out <= prtdev_address & address;
						mdio_opcode <= "00";
						mdio_out_valid <= '1';
						state <= stAddress0;
						if cmd_write = '1' then
							wr <= '1';
						else
							wr <= '0';
						end if;
					end if;
				when stAddress0 =>
					if mdio_busy = '1' then
						state <= stADDRESS1;
						mdio_out_valid <= '0';
					end if;
				when stADDRESS1 =>
					mdio_out_valid <= '0';
					if mdio_busy = '0' then
						if wr = '1' then
							mdio_opcode <= "01";
							mdio_data_out <= prtdev_address & data;
						else
							mdio_opcode <= "11";
							mdio_data_out <= prtdev_address & x"FFFF";
						end if;
						mdio_out_valid <= '1';
						state <= stOP0;
					end if;
				when stOP0 =>
					if  mdio_busy = '1' then
						state <= stOP1;
						mdio_out_valid <= '0';
					end if;
				when stOP1 =>
					mdio_out_valid <= '0';
					if mdio_busy = '0' then
						if wr = '0' then
							read_data_valid <= '1';
						end if;
						state <= stIDLE;
					end if;
				when others =>
					state <= stIDLE;
			end case;
		end if;
	end process;
			

end Behavioral;

