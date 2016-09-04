vsim -voptargs="+acc" -classdebug -uvmcontrol=all -msgmode both -t ps -L unisims_ver -novopt work.top +UVM_TESTNAME=full_test

do wave.do 

run -all