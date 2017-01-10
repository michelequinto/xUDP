//                              -*- Mode: Verilog -*-
// Filename        : genericTest.sv
// Description     : The generic test of the xUDP
// Author          : Adrian Fiergolski
// Created On      : Tue Sep 16 12:37:05 2014
// Last Modified By: Adrian Fiergolski
// Last Modified On: Tue Sep 16 12:37:05 2014
// Update Count    : 0
// Status          : Unknown, Use with caution!

timeunit 1ns;
timeprecision 1ps;

`define USE_UVM_TLM_CLK

import uvm_pkg::*;
`include <uvm_macros.svh>

localparam string s_env_config_id      = "tb_top_level_config";
localparam string s_no_config_error_id = "no config error";
localparam string s_config_type_error  = "config type error";

`include "xUDP_pkg.sv"
`include "FullTest_pkg.sv"

`include "top.sv"

import xUDP_pkg::*;
import FullTest_pkg::*;

//Class: genericTest
//The base class for any specific test of the xUDP
class genericTest extends uvm_test;

   //Variable: env
   //Simulation environment to test the xUDP
   xUDP_env env;
   
   //Variable: cfg
   //Configuration of the environment
   xUDP_config cfg;

   //Group: Configure
   
   //Variable: TCPdump_enable
   protected bit TCPdump_enable = 0;

   //Variable: TCPdump_file
   protected string TCPdump_file = "tcp_dump";

   
   `uvm_component_utils_begin(genericTest)
   `uvm_component_utils_end
   
   //Function: new
   //Creates a new <genericTest> with the given ~name~ and ~parent~.
   function new(string name="", uvm_component parent);
      super.new(name, parent);
   endfunction // new

   //Function: build_phase
   //Create environment and assign configuration.
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      //create environment
      env = xUDP_env::type_id::create("env", this);

      //create configuration
      cfg = xUDP_config::type_id::create("xUDP configuration");

      //configure XAUI's agents
      xaui_sim_config(cfg.xaui_sim_cfg);
      xaui_rtl_config(cfg.xaui_rtl_cfg);

      
      set_config_object( "env*", "xUDP_cfg", cfg, .clone(0) );
      //use testplan
      $set_coverage_db_name( {"../../Testplan/ucdb/", get_type_name(), ".ucdb"} );
   endfunction // build_phase

   //Function: end_of_elaboration
   //
   //Implement UVM end of elaboration phase.
   //Prints topology of the test ans set the sequences.
   virtual function void end_of_elaboration_phase(uvm_phase phase);
      uvm_top.print_topology();
   endfunction // end_of_elaboration_phase

   //Task: run_phase
   //It calls <wait_for_xUDP> and afterwards in parallel:
   //- <start_xUDP_sequence> 
   //- <timeout>.
   virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this, "Start test");
      
      wait_for_xUDP();
      
      start_xUDP_sequence();

      phase.drop_objection(this,"Test done");
   endtask // run_phase

   //Task: wait_for_xUDP
   //Task should wait for the xUDP to become functional (PLL locked, ect.)
   virtual task wait_for_xUDP();
   endtask // wait_for_xUDP

   //Task: start_xUDP_sequence
   //User should spawn in this task <xUDP_seq>s
   virtual task start_xUDP_sequence();
   endtask // start_xUDP_sequence

   //Task: timeout
   //Timeout of the whole test. 
   //By default: 5us.
   virtual task timeout();
      # 1ms;
   endtask // timeout
   
   //Group XAUI configuration

   //Function: xaui_sim_config
   //Configure xaui_sim_agent
   extern virtual function void xaui_sim_config(ethernet_vip_config cfg);

   //Function: xaui_rtl_config
   //Configure xaui_rtl_agent
   extern virtual function void xaui_rtl_config(ethernet_vip_config cfg);
   
endclass // genericTest

function void genericTest::xaui_sim_config(ethernet_vip_config cfg);
   xUDP_pkg::bfm_type bfm = cfg.m_bfm;

   if(!uvm_config_db #( bfm_type )::get( this , "", "xaui_interface" , bfm))
     `uvm_error("Config Error" , "uvm_config_db #( bfm_type )::get cannot find resource ETH_10G_XAUI_IF" );
   cfg.m_bfm = bfm;

   // This configures the QVIP's Tx Agent for the following settings
   // Active                 : 1
   // Tx/Rx                  : 1 (Tx)
   // Interface Type         : ETHERNET_10GBASE_X
   // MDIO Type              : ETHERNET_MDIO_DISABLED
   // Clock                  : Internal 
   // Reset                  : Internal 
   // Coverage               : Tx and Rx coverage disabled
   // Listener               : Enabled for Data and Control Frames
   
   cfg.agent_cfg.is_active               = 1;
   cfg.agent_cfg.is_tx                   = 1;
   cfg.agent_cfg.if_type                 = ETHERNET_10GBASE_X;
   cfg.agent_cfg.mdio_type               = ETHERNET_MDIO_DISABLED;
   cfg.agent_cfg.ext_clock               = 0;
   cfg.agent_cfg.ext_reset               = 0;
   cfg.agent_cfg.en_cvg.tx               = 6'h00;
   cfg.agent_cfg.en_cvg.rx               = 6'h00;
   cfg.agent_cfg.en_txn_ltnr.data_frame  = 1;
   cfg.agent_cfg.en_txn_ltnr.cntrl_frame = 1;

  // Specific configurations setting directly in BFM
  bfm.config_mac_pause_transmission = 0;             // Disabling Pause Feature
  bfm.config_enable_clock_recovery  = 1;             // Enabling Clock Recovery
  bfm.config_enable_differential_signaling = 1;      // Enabling Differential Signaling

endfunction // xaui_sim_config

function void genericTest::xaui_rtl_config(ethernet_vip_config cfg);
   xUDP_pkg::bfm_type bfm = cfg.m_bfm;
   
   if(!uvm_config_db #( bfm_type )::get( this , "", "xaui_interface" , bfm))
     `uvm_error("Config Error" , "uvm_config_db #( bfm_type )::get cannot find resource ETH_10G_XAUI_IF" );
   cfg.m_bfm = bfm;

   // This configures the QVIP's Tx Agent for the following settings
   // Active                 : 0
   // Tx/Rx                  : 0 (Rx)
   // Interface Type         : ETHERNET_10GBASE_X
   // MDIO Type              : ETHERNET_MDIO_DISABLED
   // Clock                  : Internal 
   // Reset                  : Internal 
   // Coverage               : Tx and Rx coverage disabled
   // Listener               : Enabled for Data and Control Frames
   
   cfg.agent_cfg.is_active               = 0;
   cfg.agent_cfg.is_tx                   = 0;
   cfg.agent_cfg.if_type                 = ETHERNET_10GBASE_X;
   cfg.agent_cfg.mdio_type               = ETHERNET_MDIO_DISABLED;
   cfg.agent_cfg.ext_clock               = 0;
   cfg.agent_cfg.ext_reset               = 0;
   cfg.agent_cfg.en_cvg.tx               = 6'h00;
   cfg.agent_cfg.en_cvg.rx               = 6'h00;
   cfg.agent_cfg.en_txn_ltnr.data_frame  = 1;
   cfg.agent_cfg.en_txn_ltnr.cntrl_frame = 1;

endfunction // xaui_rtl_config
