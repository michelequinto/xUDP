timeunit 1ns;
timeprecision 1ps;

import uvm_pkg::*;
`include <uvm_macros.svh>

`include "env_pkg.sv"
import env_pkg::*;

`include "top.sv"
`include "clk_reset.sv"

class full_test extends uvm_test;

  `uvm_component_utils( full_test );

  typedef env env_t;
  
  // m_env is a handle to the "top" level of the UVM testbench env. 
  env_t m_env;

  typedef virtual mgc_ethernet bfm_type;

  // Variable: env_config
  // This is the top level configuration object for the testbench.
  // This configuration object is created and populated in the build method.

  typedef env_config env_config_t;

  env_config_t m_config;

  extern function new( string name , uvm_component parent );
  extern function void build_phase(uvm_phase phase);
  extern function void do_tx_config();
  extern task run_phase(uvm_phase phase);
  extern task timeout();

endclass

// ----------------------------------------------------------------------------
function full_test::new( string name , uvm_component parent );
  super.new( name , parent );
endfunction

// ----------------------------------------------------------------------------
// This uses the UVM factory to create the an object of the type env_t
// (the testbench env), and assign m_env to to it.
// The configuration for this verification environment is also performed here.
//
function void full_test::build_phase(uvm_phase phase);

  // Create a new testbench/env object ... m_env will point to it.
  m_env = env_t::type_id::create("m_env", this);

  // Create a new m_config object ...
  m_config = env_config_t::type_id::create("env_config");

  // This new configuration object needs to know about the particular
  // SystemVerilog Interface used, which is the mgc_ethernet typed as
  // ethernet_if and registered under the name "ETH_10G_IF".
  // 
  // This gets the handle to the object with the config_id "ETH_10G_IF" from the
  // global configuration, via the config_db, and assigns m_bfm to point to it.
  // m_bfm is a handle (a virtual Interface) to the SystemVerilog Interface.
  //
  if(!uvm_config_db #( bfm_type )::get( this , "", "ETH_10G_IF" , m_config.tx_cfg.m_bfm ))
     `uvm_error("Config Error" , "uvm_config_db #( bfm_type )::get cannot find resource ETH_10G_IF" );

  //Perform the test specific Tx configuration.
  do_tx_config();

  m_config.tx_cfg.cover_s_vlan_tag_field    = new[3];
  m_config.tx_cfg.cover_s_vlan_tag_field[0] = 1;
  m_config.tx_cfg.cover_s_vlan_tag_field[1] = 3;
  m_config.tx_cfg.cover_s_vlan_tag_field[2] = 9;

  m_config.tx_cfg.cover_vlan_tag_field    = new[3];
  m_config.tx_cfg.cover_type_value_field  = new[2];
  m_config.tx_cfg.cover_vlan_tag_field[0] = 1;
  m_config.tx_cfg.cover_vlan_tag_field[1] = 3;
  m_config.tx_cfg.cover_vlan_tag_field[2] = 9;

  m_config.tx_cfg.cover_type_value_field[0] = 16'h8000;
  m_config.tx_cfg.cover_type_value_field[1] = 16'h8800;

  // Place the configured object in global configuration space.
  // This propagates the configuration items down through the
  // hierarchy (because of the "*")
  uvm_config_db #( env_config_t )::set( this , "*" , s_env_config_id , m_config );

endfunction

// ----------------------------------------------------------------------------
// Function: do_tx_config
//
// This function populates the Tx configuration.

function void full_test::do_tx_config();
  bfm_type bfm = m_config.tx_cfg.m_bfm;

// This configures the QVIP's Tx Agent for the following settings
// Active                 : 1
// Tx/Rx                  : 1 (Tx)
// Interface Type         : ETHERNET_10GBASE_X
// MDIO Type              : ETHERNET_MDIO_DISABLED
// Clock                  : External 
// Reset                  : External 
// Coverage               : Tx and Rx coverage disabled
// Listener               : Enabled for Data and Control Frames

  m_config.tx_cfg.agent_cfg.is_active               = 1;
  m_config.tx_cfg.agent_cfg.is_tx                   = 1;
  m_config.tx_cfg.agent_cfg.if_type                 = ETHERNET_10GBASE_X;
  m_config.tx_cfg.agent_cfg.mdio_type               = ETHERNET_MDIO_DISABLED;
  m_config.tx_cfg.agent_cfg.ext_clock               = 0;
  m_config.tx_cfg.agent_cfg.ext_reset               = 0;
  m_config.tx_cfg.agent_cfg.en_cvg.tx               = 6'h00;
  m_config.tx_cfg.agent_cfg.en_cvg.rx               = 6'h00;
  m_config.tx_cfg.agent_cfg.en_txn_ltnr.data_frame  = 1;
  m_config.tx_cfg.agent_cfg.en_txn_ltnr.cntrl_frame = 1;

  // Specific configurations setting directly in BFM
  bfm.config_mac_pause_transmission = 0;             // Disabling Pause Feature
  bfm.config_enable_clock_recovery  = 1;             // Enabling Clock Recovery
  bfm.config_enable_differential_signaling = 0;      // Enabling Differential Signaling

  // Specific configurations setting directly in BFM
  //bfm.config_mac_type_frame_octet_receive_limit = 32'd100000;  // Setting Jumbo Frame Receive Limit
  //bfm.config_enable_vlan_double_tagged_frame = 1;

endfunction

// ----------------------------------------------------------------------------

task full_test::run_phase(uvm_phase phase);

  // Create a new ethernet_upper_layer_packet_sequence_t type of object test_seq
  // and give it the name "ethernet_upper_layer_packet_sequence". 
  // ethernet_udp_ipv4_sequence test_seq =
  //               ethernet_udp_ipv4_sequence::type_id::create("test_seq");

  ethernet_arp_ipv4_sequence test_seq =
                 ethernet_arp_ipv4_sequence::type_id::create("test_seq");
  // m_sequencer is a handle for the sequencer in the agent. By calling the 
  // sequencer method "start" of test_seq with the handle to the testbench's
  // (m_env) agents' handle, the line below start running the test_seq.
  phase.raise_objection(this);
  fork
    test_seq.start( m_env.tx_agent.m_sequencer);  
    //timeout();
  join_any
  phase.drop_objection(this);

endtask

task full_test::timeout();
`ifdef MODEL_TECH
 #200ms;
`else
 #2ms;
`endif
endtask
