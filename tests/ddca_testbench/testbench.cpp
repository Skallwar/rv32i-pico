#include "Vcpu.h"
#include "Vcpu_cpu.h"
#include "Vcpu_rom.h"
#include "Vcpu_ram.h"
#include "verilated.h"

#include <verilated_vcd_c.h>
#include <iostream>
#include <fstream>
#include <string>
#include <iterator>
#include <stdio.h>

const char* FILE_NAME = "test.bin";

static void state_setup(Vcpu *cpu) {
    FILE *instr_file = fopen(FILE_NAME, "r");
    assert(instr_file);

    size_t i = 0;
    unsigned int instr = 0;
    while (fread(&instr, 4, 1, instr_file)) {
        printf("%x\n", instr);
        cpu->cpu->instruction_fetch->rom_data[i++] = instr;
    }
}

int main(int argc, char** argv, char** env) {
    Verilated::traceEverOn(true);
    Verilated::commandArgs(argc, argv);


    VerilatedVcdC* trace = new VerilatedVcdC;

    Vcpu* cpu = new Vcpu;
    cpu->trace(trace, 100);
    trace->open("dump.vcd");

    bool is_done = false;
    int ret_val = 1;
    vluint64_t main_time = 0;

    state_setup(cpu);

    while (!Verilated::gotFinish()) {
        if ((main_time % 10) == 1) {
            cpu->clk = !cpu->clk;
        }

        if (cpu->cpu->data_memory->write_control == 1) {
            if (cpu->cpu->data_memory->addr == 84 && cpu->cpu->data_memory->write_data == 7)
            {
                ret_val = 0;
                is_done = true;
            }
            else if (cpu->cpu->data_memory->addr != 80) {
                is_done = true;
            }

        }

        if (is_done) {
            // for (size_t i = 0; i != 5; i++) {
            //     printf("I = %lu\n", i);
            //     trace->dump(main_time);
            //     main_time ++;
            //     cpu->eval();
            // }
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
