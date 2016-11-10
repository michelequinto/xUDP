vsim -voptargs="+acc" -classdebug -uvmcontrol=all -msgmode both -t ps -L unisims_ver -novopt work.top +UVM_TESTNAME=full_test

#force sim:/top/xudp/IP/ip_tx_start -deposit 1 3000 ns, 0 {3010 ns}
#force sim:/top/xudp/IP/ip_tx.hdr.dst_ip_addr 32'h10000001 0
#force sim:/top/xudp/IP/ip_tx.hdr.protocol 8'h00 0
#force sim:/top/xudp/IP/ip_tx.hdr.data_length 16'h0020 0

do wave.do 

run -all