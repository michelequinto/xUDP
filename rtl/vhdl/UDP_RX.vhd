-- Filename            : UDP_TX.vhd
-- Description         : 
-- Author              : Michele Quinto
-- Created On          : Tue Oct 26 11:49:02 2016

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
use work.arp_types.all;
use work.xUDP_Common_pkg.all;
