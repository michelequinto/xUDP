-------------------------------------------------------------------------------
-- Copyright (c) 2016 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.7
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : chipscope_icon.vhd
-- /___/   /\     Timestamp  : Fri Nov 04 15:25:51 CET 2016
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY chipscope_icon IS
  port (
    CONTROL0: inout std_logic_vector(35 downto 0));
END chipscope_icon;

ARCHITECTURE chipscope_icon_a OF chipscope_icon IS
BEGIN

END chipscope_icon_a;
