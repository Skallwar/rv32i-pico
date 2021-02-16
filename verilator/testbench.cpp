#include "Vtop.h"
#include "verilated.h"

#include <verilated_vcd_c.h>
#include <iostream>

int main(int argc, char** argv, char** env) {
    Verilated::traceEverOn(true);
    Verilated::commandArgs(argc, argv);


    VerilatedVcdC* trace = new VerilatedVcdC;

    Vtop* top = new Vtop;
    top->trace(trace, 100);
    trace->open("dump.vcd");

    vluint64_t main_time = 0;

    while (!Verilated::gotFinish()) {
        if ((main_time % 10) == 1) {
        top->clk = !top->clk;
        }

        trace->dump(main_time);
        main_time ++;

        top->eval();
    }

    delete top;
    trace->close();
    exit(0);
}
