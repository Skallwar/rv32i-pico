#include "Vcpu.h"
#include "Vcpu_cpu.h"
#include "Vcpu_rom.h"
#include "Vcpu_ram.h"
#include "verilated.h"

#include <verilated_vcd_c.h>
#include <iostream>
#include <fstream>
#include <string>

const char* FILE_NAME = "test.bin";

static void state_setup(Vcpu *cpu) {
    std::ifstream instr_file (FILE_NAME, std::ios::binary);
    unsigned char i1, i2, i3, i4;
    size_t i = 1;
    while (instr_file >> i1 >> i2 >> i3 >> i4) {
        // printf("%x %x %x %x\n", i4, i3, i2, i1);
        cpu->cpu->instruction_memory->rom_data[i] = (i4 << 24 | i3 << 16 | i2 << 8 | i1);
        i++;
    }
}

int main(int argc, char** argv, char** env) {
    Verilated::traceEverOn(true);
    Verilated::commandArgs(argc, argv);


    VerilatedVcdC* trace = new VerilatedVcdC;

    Vcpu* cpu = new Vcpu;
    cpu->trace(trace, 100);
    trace->open("dump.vcd");

    int ret_val = 1;
    vluint64_t main_time = 0;

    state_setup(cpu);

    while (!Verilated::gotFinish()) {
        if ((main_time % 10) == 1) {
        cpu->clk = !cpu->clk;
        }

        if (main_time / 20 == 20) {
            ret_val = 0;
            break;
        }

        if (cpu->cpu->data_memory->write_control == 1) {
            if (cpu->cpu->data_memory->addr == 84 && cpu->cpu->data_memory->write_data == 7)
            {
                ret_val = 0;
                break;
            }
            break;
        }

        trace->dump(main_time);
        main_time ++;

        cpu->eval();
    }

    delete cpu;
    trace->close();
    exit(ret_val);
}
