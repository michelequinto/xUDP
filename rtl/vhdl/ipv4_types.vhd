-------------------------------------------------------------------------------
--    Purpose: This package defines types for use in IPv4
------------------------------------------------------------------------------- 
 
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.axi_types.all;
use work.arp_types.all;
 
package ipv4_types is

  constant ETH_MTU                      : unsigned := x"2328";  -- 1500 byte
                                                               -- 9000 byte (x2328)jumboFrame 
  constant UDP_HEADER_LENGTH            : unsigned := x"8";    -- 8 byte units
  constant IP_HEADER_LENGTH             : unsigned := x"14";   -- 20 byte units
  constant MAX_UDP_PAYLOAD_LENGTH       : unsigned := ETH_MTU - UDP_HEADER_LENGTH - IP_HEADER_LENGTH;
  constant MAX_IP_PAYLOAD_LENGTH        : unsigned := ETH_MTU - IP_HEADER_LENGTH;
  constant STD_IP_PAYLOAD_LENGTH        : unsigned := x"5DC" - IP_HEADER_LENGTH;
  constant IPV4_FRAME_TYPE              : std_logic_vector(15 downto 0) := x"0800";
  constant IPV4_JFRAME_TYPE             : std_logic_vector(15 downto 0) := x"0800"; --x"8870";
 
  constant IP_BC_ADDR		        : std_logic_vector (31 downto 0) := x"ffffffff";
  constant MAC_BC_ADDR		        : std_logic_vector (47 downto 0) := x"ffffffffffff";
  
  --------------
  -- IPv4 TX --
  --------------
  
  -- coding for result in tx
  constant IPTX_RESULT_NONE 		: std_logic_vector (1 downto 0) := "00";
  constant IPTX_RESULT_SENDING 	        : std_logic_vector (1 downto 0) := "01";
  constant IPTX_RESULT_ERR 		: std_logic_vector (1 downto 0) := "10";
  constant IPTX_RESULT_SENT 		: std_logic_vector (1 downto 0) := "11";
  
  type ipv4_tx_header_type is record
    protocol				: std_logic_vector (7 downto 0);
    data_length			        : std_logic_vector (15 downto 0);		-- user data size, bytes
    dst_ip_addr 		        : std_logic_vector (31 downto 0);
  end record;
  
  type ipv4_tx_type is record
    hdr				: ipv4_tx_header_type;						-- header to tx
    data			: axi4_dvlk64_t; 						-- tx axi bus
  end record;
  
 
  --------------
  -- IPv4 RX --
  --------------
  
  -- coding for last_error_code in rx hdr
  constant RX_EC_NONE 		: std_logic_vector (3 downto 0) := x"0";
  constant RX_EC_ET_ETH 	: std_logic_vector (3 downto 0) := x"1";        -- early termination in ETH hdr phase
  constant RX_EC_ET_IP 	        : std_logic_vector (3 downto 0) := x"2";        -- early termination in IP hdr phase
  constant RX_EC_ET_USER 	: std_logic_vector (3 downto 0) := x"3";        -- early termination in USER DATA phase
  
  type ipv4_rx_header_type is record
    is_valid				: std_logic;
    protocol				: std_logic_vector (7 downto 0);
    data_length		        	: std_logic_vector (15 downto 0);	-- user data size, bytes
    src_ip_addr 		        : std_logic_vector (31 downto 0);
    num_frame_errors	                : std_logic_vector (7 downto 0);
    last_error_code	                : std_logic_vector (3 downto 0);	-- see RX_EC_xxx constants
    is_broadcast		        : std_logic;				-- set if the msg receivedd is a broadcast
  end record;
 
  type ipv4_rx_type is record
    hdr		                	: ipv4_rx_header_type;			-- header received
    data		        	: axi4_dvlk64_t;			-- rx axi bus
  end record;
 
  type ip_control_type is record
    arp_controls	                : arp_control_type;
  end record;
  
  ------------
  -- UDP TX --
  ------------
  
  -- coding for result in tx
  constant UDPTX_RESULT_NONE 		: std_logic_vector (1 downto 0) := "00";
  constant UDPTX_RESULT_SENDING 	: std_logic_vector (1 downto 0) := "01";
  constant UDPTX_RESULT_ERR 		: std_logic_vector (1 downto 0) := "10";
  constant UDPTX_RESULT_SENT 		: std_logic_vector (1 downto 0) := "11";
  
  type udp_tx_header_type is record
    dst_ip_addr 		        : std_logic_vector (31 downto 0);
    dst_port	 			: std_logic_vector (15 downto 0);
    src_port	 			: std_logic_vector (15 downto 0);
    data_length			        : std_logic_vector (15 downto 0);	-- user data size, bytes
    checksum				: std_logic_vector (15 downto 0);
  end record;
  
  
  type udp_tx_type is record
    hdr				        : udp_tx_header_type;			-- header received
    data				: axi4_dvlk64_t;			-- tx axi bus
  end record;
 
 
  ------------    
  -- UDP RX --
  ------------
  
  type udp_rx_header_type is record
    is_valid				: std_logic;
    src_ip_addr 		        : std_logic_vector (31 downto 0);
    src_port	 			: std_logic_vector (15 downto 0);
    dst_port	 			: std_logic_vector (15 downto 0);
    data_length			        : std_logic_vector (15 downto 0);	-- user data size, bytes
  end record;
  
 
  type udp_rx_type is record
    hdr				        : udp_rx_header_type;			-- header received
    data				: axi4_dvlk64_t;	        	-- rx axi_out_type bus
  end record;
  
  type udp_addr_type is record
    ip_addr 			        : std_logic_vector (31 downto 0);
    port_num	 		        : std_logic_vector (15 downto 0);
  end record;
  
  type udp_control_type is record
    ip_controls	                        : ip_control_type;
  end record;
    
end ipv4_types;
