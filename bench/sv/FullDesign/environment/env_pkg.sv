`ifndef ENV_PKG_SV
 `define ENV_PKG_SV

`include <uvm_macros.svh>
`include <mvc_macros.svh>
`include <questa_mvc_svapi.svh>
`include <mvc_pkg.sv>
`include <mgc_ethernet_v1_0_pkg.sv>

package env_pkg;

   localparam string s_env_config_id      = "tb_top_level_config";
   localparam string s_no_config_error_id = "no config error";
   localparam string s_config_type_error  = "config type error";
 
   typedef `DEFINE_VIF_TYPE(ethernet) bfm_type;

   import uvm_pkg::*;
   import mvc_pkg::*;
   import mgc_ethernet_v1_0_pkg::*;

`include "env_config.svh"
`include "ethernet_monitors.svh"
`include "env.svh"

`include "ethernet_udp_ipv4_sequence.sv"

`define USE_UVM_TLM_CLK

endpackage // env_pkg

`endif
