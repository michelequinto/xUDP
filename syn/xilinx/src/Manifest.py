files = [ "xUDP_top.vhd",
          "xaui_init.vhd",
          "mdio/mdio.v",
          "mdio/mdio_ctrl.vhd",
          "vsc8486_init.vhd",
	  "clk_wiz_v3_3_0.vhd",
          __import__('os').path.relpath( __import__('os').environ.get('XILINX') ) + "/verilog/src/glbl.v" ]

modules = { "local" : [ "../../../rtl/vhdl/ipcores/xilinx/xaui"]}
#                        "../../../rtl/verilog/ipcores/xge_mac" ]}
                        
