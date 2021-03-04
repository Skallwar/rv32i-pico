build:
	verilator -I./src -Wall -Wno-UNUSED --cc src/cpu.sv --exe --build verilator/testbench.cpp --trace -j $(shell nproc)

run: build
	./obj_dir/Vcpu

test:
	./tests/test.sh

clean:
	rm -rf $(shell find -name "*obj_dir*") $(shell find -name "*.elf" -o -name "*.bin")
