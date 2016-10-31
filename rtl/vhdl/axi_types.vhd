--
-- Package File Template
--
-- Purpose: This package defines data types for AXI transfers


library IEEE;
use IEEE.STD_LOGIC_1164.all;

package axi_types is

    -- Define 64 bit axi bus with data, valid, last, and keep signals
    type axi4_dvlk64_t is record
        tdata       : std_logic_vector (63 downto 0);
        tvalid      : std_logic;                    -- indicates data_in valid on clock
        tlast       : std_logic;                    -- indicates last data in frame
        tkeep       : std_logic_vector(7 downto 0); -- which of last is valid (bit 0 == 0..7)
    end record;

    type axi_in_t is array (natural range <>) of axi4_dvlk64_t;
 
    function empty_axi4_dvlk64 return axi4_dvlk64_t;

end axi_types;

package body axi_types is

    function empty_axi4_dvlk64 return axi4_dvlk64_t is
        variable axi : axi4_dvlk64_t;
    begin
        axi.tdata := (others => '0');
        axi.tvalid := '0';
        axi.tlast := '0';
        axi.tkeep := (others => '0');
        return axi;
    end empty_axi4_dvlk64;

end axi_types;
