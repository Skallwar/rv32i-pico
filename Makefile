build:
	verilator -I./src -Wall -Wno-UNUSED --cc src/top.sv --exe --build verilator/testbench.cpp --trace

