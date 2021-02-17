build:
	verilator -I./src -Wall -Wno-UNUSED --cc src/cpu.sv --exe --build verilator/testbench.cpp --trace

run: build
	./obj_dir/Vcpu


