//                              -*- Mode: Verilog -*-
// Filename            : ethernet_arp_ipv4_sequence.sv
// Description         : 
// Author              : Michele Quinto
// Created On          : Wed Nov  2 18:09:34 2016

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

class ethernet_arp_ipv4_sequence extends mvc_sequence;
  
   mvc_config_base m_config;
  `uvm_object_utils( ethernet_arp_ipv4_sequence);
  
   extern function new( string name = "" );
   extern task body();
endclass

function ethernet_arp_ipv4_sequence::new( string name = "" );
    super.new(name);
endfunction

task ethernet_arp_ipv4_sequence::body();

   ethernet_device_arp_rarp_frame arp = ethernet_device_arp_rarp_frame::type_id::create("ethernet_device_arp_rarp_frame");

   m_config = mvc_config_base::get_config(m_sequencer);
   
   //m_config.wait_for_reset();
   //m_config.wait_for_clock();

   repeat(20)
     begin
	`uvm_info("ID", "Starting ARP sequence", UVM_NONE);
	start_item(arp);                                            
	if ( !arp.randomize() with {
				    arp.vlan_mode == ETH_VLAN_UNTAGGED;
				    protocol_type == ETH_TYPE_0800;

				    src_address[0] == 8'h10;
				    dest_address[0] == 8'h10;
				    src_address[1] == 8'h1F;
				    dest_address[1] == 8'h1F;
				    
				    
				    src_address[2] == 8'h74;
				    dest_address[2] == 8'h74;
				    src_address[3] == 8'he6;
				    dest_address[3] == 8'he6;
				    
				    src_address[4] == 8'ha4;
				    dest_address[4] == 8'ha4;
				    src_address[5] == 8'h00;
				    dest_address[5] == 8'h0D;

				    //opcode == 16'h0002;

				    protocol_addr_length == 4;
				    source_protocol_addr[0] == 8'h10;
				    destination_protocol_addr[0] == 8'h10;
				    source_protocol_addr[1] == 8'h00;
				    destination_protocol_addr[1] == 8'h00;
				    source_protocol_addr[2] == 8'h00;
				    destination_protocol_addr[2] == 8'h00;
				    source_protocol_addr[3] == 8'h01;
				    destination_protocol_addr[3] == 8'h03;
				    
				    arp.tx_error == 1'b0 ; 
				    arp.tx_error_on_cycle == 0; }) `uvm_error("ASSERT_FAILURE","Assert statement failure");

	finish_item(arp);  
        `uvm_info("ID", "Finish item ARP", UVM_NONE);
     end  
endtask
