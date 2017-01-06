------------------------------------------------------------------------------
--$Date: 2011/06/17 08:48:14 $
--$RCSfile: example_design_vhd.ejava,v $
--$Revision: 1.1 $
------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version : 1.05
--  \   \         Application : VIO V1.05a
--  /   /         Filename : example_chipscope_vio.vhd
-- /___/   /\     
-- \   \  /  \ 
--  \___\/\___\
--
-- (c) Copyright 2010 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

library UNISIM;
use UNISIM.vcomponents.all;

--The example module here illustrates how vio core can be instantiated in
--a user design. This helps the user on how various ports selected for the core can be used.

entity example_chipscope_vio is 
end example_chipscope_vio;


architecture vio_arch of example_chipscope_vio is

  component chipscope_vio
    port (
      CONTROL	: inout std_logic_vector(35 downto 0);
      ASYNC_IN	: in  std_logic_vector(127 downto 0);
      ASYNC_OUT	: out std_logic_vector(127 downto 0)
    );
  end component;

  component chipscope_icon
    port (
      CONTROL0 : inout std_logic_vector(35 downto 0)
    );
  end component;
  ---------------------------------------------------------------------
  --  Local Signals
  --------------------------------------------------------------------
  signal clr_async_control	: std_logic;
  signal control_0	: std_logic_vector (35 downto  0);
  signal async_i	: std_logic_vector (127 downto  0);
  signal async_o	: std_logic_vector (127 downto  0);


begin

  clr_async_control <= async_o(0);




  -------------------------------------------------------------------
  --
  --  VIO Pro core instance
  --
  ------------------------------------------------------------------- 
  --When the example design is run on analyzer, shift operation is observed on
  --SYNC_IN port when selected. If SYNC_OUT is selected, SYNC_OUT[0] acts as 
  --load enable for this shift operation. If ASYNC_OUT is selected, ASYNC_OUT[0] 
  --acts as control to the pattern displayed on ASYNC_IN Port.
 

  VIO_inst : chipscope_vio
    port map (
      CONTROL	=> control_0, -- INOUT BUS [35:0]
      ASYNC_IN	=> async_i, -- IN BUS [127:0]
      ASYNC_OUT	=> async_o -- OUT BUS [127:0]
    );


  -------------------------------------------------------------------
  --
  --  ICON Pro core instance
  --
  -------------------------------------------------------------------
  --ICON core is instantiated to connect to vio core

 icon_inst : chipscope_icon  
   port map (
     CONTROL0 => control_0 -- INOUT BUS [35:0]   
   );

  async_i  <= (OTHERS=>'1') when clr_async_control = '0' else (OTHERS=>'0'); 


end vio_arch;
