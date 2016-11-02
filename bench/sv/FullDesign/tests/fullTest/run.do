xml2ucdb -format Excel ETH_10G_XGMII_upper_layer_packets_functional_verification_plan.xml testplan.ucdb;

force sim:/top/xudp/IP/ip_tx_start -deposit 1 2200 ns, 0 {10 ns}
force sim:/top/xudp/IP/ip_tx.hdr.ip_dest_addr 32'h10000001 0
force sim:/top/xudp/IP/ip_tx.hdr.protocol 8'h00 0
force sim:/top/xudp/IP/ip_tx.hdr.data_lenght 16'h0020 0

vcover merge coverage_merge.ucdb testplan.ucdb  ex_coverage.ucdb;
vcover report -all coverage_merge.ucdb -file merged_coverage_results; quit -f

