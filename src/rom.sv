module rom(input logic clk, input logic [31:0] addr, output logic [31:0] data);

    initial
    begin
        rom_data[0] = '0;
        rom_data[1] = 32'b10101000000000000010010011; // addi x1, x0 42
        rom_data[2] = 32'b10101000001000000010010011; // addi x1, x1 42
        rom_data[3] = 32'b0000000_00001_00000_010__00000_0100011; // sw x0, 0(x1)
    end

    logic [31:0] rom_data [31:0];

    assign data = rom_data[addr/4];

endmodule;
