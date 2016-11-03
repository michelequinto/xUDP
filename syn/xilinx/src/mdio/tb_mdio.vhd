--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:43:02 08/02/2012
-- Design Name:   
-- Module Name:   D:/Documents/Local/opencores/xge_mac/other/tb_mdio.vhd
-- Project Name:  xge_mac
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mdio
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_mdio IS
END tb_mdio;
 
ARCHITECTURE behavior OF tb_mdio IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mdio
    PORT(
         mgmt_clk : IN  std_logic;
         reset : IN  std_logic;
         mdc : OUT  std_logic;
         mdio_t : OUT  std_logic;
         mdio_i : IN  std_logic;
         mdio_o : OUT  std_logic;
         mdio_opcode : IN  std_logic_vector(1 downto 0);
         mdio_in_valid : OUT  std_logic;
         mdio_data_in : OUT  std_logic_vector(15 downto 0);
         mdio_out_valid : IN  std_logic;
         mdio_data_out : IN  std_logic_vector(25 downto 0);
         mgmt_config : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal mgmt_clk : std_logic := '0';
   signal reset : std_logic := '1';
   signal mdio_i : std_logic := '0';
   signal mdio_opcode : std_logic_vector(1 downto 0) := (others => '0');
   signal mdio_out_valid : std_logic := '0';
   signal mdio_data_out : std_logic_vector(25 downto 0) := (others => '0');
   signal mgmt_config : std_logic_vector(31 downto 0) := x"00000306";

 	--Outputs
   signal mdc : std_logic;
   signal mdio_t : std_logic;
   signal mdio_o : std_logic;
   signal mdio_in_valid : std_logic;
   signal mdio_data_in : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant mgmt_clk_period : time := 10 ns;
	
	signal mdio_pad : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mdio PORT MAP (
          mgmt_clk => mgmt_clk,
          reset => reset,
          mdc => mdc,
          mdio_t => mdio_t,
          mdio_i => mdio_i,
          mdio_o => mdio_o,
          mdio_opcode => mdio_opcode,
          mdio_in_valid => mdio_in_valid,
          mdio_data_in => mdio_data_in,
          mdio_out_valid => mdio_out_valid,
          mdio_data_out => mdio_data_out,
          mgmt_config => mgmt_config
        );
		  
	mdio_pad <= mdio_o when mdio_t = '0' else 'Z';

   -- Clock process definitions
   mgmt_clk_process :process
   begin
		mgmt_clk <= '0';
		wait for mgmt_clk_period/2;
		mgmt_clk <= '1';
		wait for mgmt_clk_period/2;
   end process;
   -- Clock process definitions
   mdio_i_clk_process :process
   begin
		mdio_i <= '0';
		wait for mgmt_clk_period*32/2;
		mdio_i <= '1';
		wait for mgmt_clk_period*32/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
			
		reset <= '0';

      wait for mgmt_clk_period*20;
		mdio_opcode <= "00";
		mdio_data_out <= "00" & x"34AA55";
		mdio_out_valid <= '1';
      wait for mgmt_clk_period;
		mdio_out_valid <= '0';
		
      wait for mgmt_clk_period*1600;
		mdio_opcode <= "01";
		mdio_data_out <= "00" & x"34abcd";
		mdio_out_valid <= '1';
      wait for mgmt_clk_period;
		mdio_out_valid <= '0';

      wait for mgmt_clk_period*1600;
		mdio_opcode <= "10";
		mdio_data_out <= "00" & x"3437d4";
		mdio_out_valid <= '1';
      wait for mgmt_clk_period;
		mdio_out_valid <= '0';

      wait for mgmt_clk_period*1600;
		mdio_opcode <= "11";
		mdio_data_out <= "00" & x"34ff00";
		mdio_out_valid <= '1';
      wait for mgmt_clk_period;
		mdio_out_valid <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
