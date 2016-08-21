//                              -*- Mode: Verilog -*-
// Filename        : FullTest_pkg.sv
// Description     : The package contains the available custom sequences
// Author          : Adrian Fiergolski
// Created On      : Tue Sep 16 15:02:33 2014
// Last Modified By: Adrian Fiergolski
// Last Modified On: Tue Sep 16 15:02:33 2014
// Update Count    : 0
// Status          : Unknown, Use with caution!

`ifndef FULLTEST_PKG_SV
 `define FULLTEST_PKG_SV

//Title: FullTest_pkg

//Package: FullTest_pkg
//The package contains sequences available for full tests.
package FullTest_pkg;

   import uvm_pkg::*;
 `include <uvm_macros.svh>

   import QUESTA_MVC::*;

   import mvc_pkg::*;
   export mvc_pkg::mvc_item_listener;
   export mvc_pkg::mvc_sequence;
   export mvc_pkg::mvc_sequence_item_base;
   export mvc_pkg::mvc_config_base;
   

endpackage // FullTest_pkg

`endif

