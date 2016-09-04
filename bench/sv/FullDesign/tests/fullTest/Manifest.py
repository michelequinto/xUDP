action = "simulation"
include_dirs = [ "../../environment/", "../../sequences/", "../genericTest/src/"]

vlog_opt = '+incdir+' + \
__import__('os').environ.get('QUESTA_MVC_HOME') + '/questa_mvc_src/sv+' + \
__import__('os').environ.get('QUESTA_MVC_HOME') + '/questa_mvc_src/sv/mvc_base+' + \
__import__('os').environ.get('QUESTA_MVC_HOME') + '/include+' + \
__import__('os').environ.get('QUESTA_MVC_HOME') + '/examples/ethernet/common+' + \
__import__('os').environ.get('QUESTA_MVC_HOME') + '/questa_mvc_src/sv/ethernet/ '

top_module = "top"
sim_tool = "modelsim"

files = ["full_test.sv"]

modules = { "local" : [ "../../../../../syn/xilinx/src",
                        "../../../../../rtl/vhdl/ipcores/xilinx/xaui",
                        "../../../../../rtl/verilog/ipcores/xge_mac" ] }
