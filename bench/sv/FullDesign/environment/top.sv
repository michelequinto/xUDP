//                              -*- Mode: Verilog -*-
// Filename        : top.sv
// Description     : The to module of the testbench.
// Author          : Adrian Fiergolski
// Created On      : Tue Sep 16 10:30:45 2014
// Last Modified By: Adrian Fiergolski
// Last Modified On: Tue Sep 16 10:30:45 2014
// Update Count    : 0
// Status          : Unknown, Use with caution!

module automatic top;

   timeunit 1ns;
   timeprecision 1ps;

   logic reset = 1;
   logic clk100 = 0;
   logic clk156 = 0;
   wire mdio;

   logic [63:0] udp_tx_tdata;
   logic 	udp_tx_tvalid = 0;
   logic 	udp_tx_tlast = 0;
   logic 	udp_tx_tready;
   logic 	udp_tx_start = 0;

   mgc_ethernet xaui( .iclk_0(1'bz), .iclk_1(1'bz), .ireset(1'bz), .iMDC(1'bz), .ian_clk_0(1'bz), .ian_clk_1(1'bz) );
   assign mdio = xaui.MDIO_OUT;
   assign xaui.MDIO_IN = mdio;

   struct {
      logic [3:0] tx;
      logic [3:0] rx; } xaui_lanes;
   
   for (genvar i=0; i<4; i++) begin
      assign xaui.lane_bit[1][i] = xaui_lanes.tx[i];
      assign xaui_lanes.rx[i] = xaui.lane_bit[0][i];
   end
  
   //assign xaui.lane_bit[0] = xaui.lane_bit[1];
   
   
`ifndef USE_UVM_TLM_CLK
   clk_reset clk_rst_inst_xaui( xaui.iclk[0], xaui.iclk[1], xaui.ireset);
`endif

   //FPGA fabric clock
   initial
     forever begin
	#5ns;
	clk100 <= ! clk100;
     end

   //XGMII clock
   initial
     forever begin
	#3.2ns;
	clk156 <= !clk156;
     end 
   
   //FPGA reset
   initial begin
      reset <= 0;
      #15ns reset <= 1;
   end
   
   xUDP  #(.SIM(1)) xudp  ( .BRD_RESET_SW(reset),
			    .BRD_CLK_P(clk100), .BRD_CLK_N(~clk100),
			    .FPGA_LED(), .FPGA_PROG_B(),
			    .DIP_GPIO(),
			    
			    //MDIO
			    .MDIO_PAD(mdio), .MDC(xaui.MDC),
			    //PHY
			    .PHY_RSTN(),
			    .PHY_LASI(), .PHY_INTA(),
			    .PHY10G_RCK_P(clk156), .PHY10G_RCK_N(~clk156),
			    
			    
			    //XAUI
			    .FXTX_P(xaui_lanes.tx), .FXTX_N(),
			    .FXRX_P(xaui_lanes.rx), .FXRX_N(~xaui_lanes.rx) );

   assign xudp.tx_tvalid = udp_tx_tvalid;
   assign xudp.tx_tlast = udp_tx_tlast;
   assign udp_tx_tready = xudp.tx_tready;
   assign xudp.tx_tdata = udp_tx_tdata;
   assign xudp.tx_start = udp_tx_start;

   //drive udp_tx
   initial begin
      udp_tx_start <= 0;
      #2us;
      udp_tx_start <= 1;
      #3.2ns;
      udp_tx_start <= 0;
   end

   
    initial begin
      wait(udp_tx_tready) begin
	 udp_tx_tvalid <= 1;
	 udp_tx_tdata <= 64'ha5a5_a5a5_a5a5_a5a5;
	 udp_tx_tlast <= 0;
	 #19.2ns;
	 udp_tx_tvalid <= 1;
	 udp_tx_tdata <= 64'ha5a5_a5a5_a5a5_a5a5;
	 udp_tx_tlast <= 1;
	 #6.4ns;
	 udp_tx_tvalid <= 0;
	 udp_tx_tlast <= 0;
      end
   end

   initial begin
      uvm_config_db #( env_pkg::bfm_type ) :: set(null, "uvm_test_top", "ETH_10G_IF", xaui );
      run_test();
   end

endmodule // top
