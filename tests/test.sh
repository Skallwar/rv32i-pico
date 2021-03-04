#!/bin/sh

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

GREEN="\e[32m"
RED="\e[31m"
RESET="\e[39m"

cd $SCRIPTPATH

test_list=$(find * -type d ! -name "obj_dir")
for test_folder in $test_list; do
    cd $test_folder
    riscv64-elf-as -march=rv32i test.S -o test.elf
    riscv64-elf-objcopy -O binary test.elf test.bin
    verilator -I../../src -Wall -Wno-UNUSED --cc ../../src/cpu.sv --exe --build testbench.cpp --trace -j $(nproc)
    cd ..
    echo ""
done

echo "" > log.tmp # Clear log.tmp
for test_folder in $test_list; do
    cd $test_folder
    echo "------ Running $test_folder ------" >> ../log.tmp
    ./obj_dir/Vcpu >> ../log.tmp
    res=$?
    echo "-------------------------------" >> ../log.tmp
    cd ..


    echo -n "Running $test_folder... "
    if [ "$res" = "0" ]; then
        echo -e "[${GREEN}OK${RESET}]"
    else
        echo -e "[${RED}KO${RESET}]"
        cat log.tmp
        exit 1
    fi
done
