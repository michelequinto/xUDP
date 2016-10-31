//                              -*- Mode: Verilog -*-
// Filename            : ethernet_udp_ipv4_sequence.sv
// Description         : 
// Author              : Michele Quinto
// Created On          : Sun Aug 21 19:38:20 2016

// $LastChangedBy$
// $LastChangedRevision$
// $LastChangedDate$
// $URL$

//----------------------------------------------------------------

// Copyright 2016 Michele Quinto

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>
//----------------------------------------------------------------

class ethernet_udp_ipv4_sequence extends mvc_sequence;
  
   mvc_config_base m_config;
  `uvm_object_utils( ethernet_udp_ipv4_sequence);
  
   extern function new( string name = "" );
   extern task body();
endclass

function ethernet_udp_ipv4_sequence::new( string name = "" );
    super.new(name);
endfunction

task ethernet_udp_ipv4_sequence::body();

   ethernet_udp_ipv4_packet udp = ethernet_udp_ipv4_packet::type_id::create("ethernet_udp_ipv4_packet");

   m_config = mvc_config_base::get_config(m_sequencer);
   
   //m_config.wait_for_reset();
   //m_config.wait_for_clock();

   repeat(10)
     begin
	`uvm_info("ID", "Starting UDP sequence", UVM_NONE);
	start_item(udp);                                            
	if ( !udp.randomize() with {
				    udp.type_mode == ETH_TYPE_0800;
				    udp.vlan_mode == ETH_VLAN_UNTAGGED;
				    udp.hlen == 5;
				    udp.flag == 0;
				    udp.identification == 0;
				    udp.fragmentation_offset == 0;
				    udp.time_to_live == 0;
				    udp.header_checksum == 16'hBAC1;
				    //mac
				    
				    //src_address[0] == 8'hFF;
				    //dest_address[0] == 8'h11;
				    src_address[1] == 8'h02;
				    //dest_address[1] == 8'h00;
				    
				    
				    src_address[2] == 8'h03;
				    dest_address[2] == 8'h01;
				    src_address[3] == 8'h04;
				    dest_address[3] == 8'h01;
				    
				    src_address[4] == 8'h05;
				    dest_address[4] == 8'h01;
				    src_address[5] == 8'h06;
				    dest_address[5] == 8'h01;
				    
				    //ip address
				    udp.source_ip_address == 32'h10_00_00_01;
				    udp.destination_ip_address == 32'h10_00_00_03;
				    //port
				    udp.destination_port_address == 16'ha5a5;
				    udp.source_port_address == 16'hfcfc;
				    
				    udp.tx_error == 1'b0 ; 
				    udp.tx_error_on_cycle == 0 ;
				    udp.length == 16'h00_20; }) `uvm_error("ASSERT_FAILURE","Assert statement failure");

	finish_item(udp);  
        `uvm_info("ID", "Finish item UDP", UVM_NONE);
     end  
endtask
