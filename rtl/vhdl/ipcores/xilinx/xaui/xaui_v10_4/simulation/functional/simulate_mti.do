vlib work
vmap work work
vcom -work work \
  ../../../xaui_v10_4.vhd \
      ../../example_design/xaui_v10_4_gtx_wrapper.vhd \
  ../../example_design/xaui_v10_4_gtx_wrapper_gtx.vhd \
  ../../example_design/xaui_v10_4_chanbond_monitor.vhd \
  ../../example_design/xaui_v10_4_tx_sync.vhd \
  ../../example_design/xaui_v10_4_example_design.vhd \
  ../../example_design/xaui_v10_4_block.vhd \
  ../demo_tb.vhd

vsim -G/testbench/DUT/xaui_block/tx_sync_i/SIM_TXPMASETPHASE_SPEEDUP=1 -t ps work.testbench -voptargs="+acc"
do wave_mti.do
run -all
