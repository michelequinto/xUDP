-------------------------------------------------------------------------------
-- Copyright (c) 2016 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.7
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : chipscope_vio.vhd
-- /___/   /\     Timestamp  : Fri Nov 04 15:27:14 CET 2016
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY chipscope_vio IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    ASYNC_IN: in std_logic_vector(127 downto 0);
    ASYNC_OUT: out std_logic_vector(127 downto 0));
END chipscope_vio;

ARCHITECTURE chipscope_vio_a OF chipscope_vio IS
BEGIN

END chipscope_vio_a;
