#include "Vcpu.h"
#include "verilated.h"

#include <verilated_vcd_c.h>
#include <iostream>

int main(int argc, char** argv, char** env) {
    Verilated::traceEverOn(true);
    Verilated::commandArgs(argc, argv);


    VerilatedVcdC* trace = new VerilatedVcdC;

    Vcpu* cpu = new Vcpu;
    cpu->trace(trace, 100);
    trace->open("dump.vcd");

    vluint64_t main_time = 0;

    while (!Verilated::gotFinish()) {
        if ((main_time % 10) == 1) {
        cpu->clk = !cpu->clk;
        }

        if (main_time / 20 == 5) {
            break;
        }

        trace->dump(main_time);
        main_time ++;

        cpu->eval();
    }

    delete cpu;
    trace->close();
    exit(0);
}
