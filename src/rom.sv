module rom(input logic [31:0] addr, output logic [31:0] data);

    logic [31:0] rom_data [31:0] /* verilator public */;

    assign data = rom_data[addr/4];

endmodule;
