module rom(input logic clk, input logic [31:0] addr, output logic [31:0] data);

    initial
    begin
        rom_data[0] = '0;
        rom_data[1] = 32'b10101000000000000010010011; // addi x1, x0, 42
        rom_data[2] = 32'b10101000001000000010010011; // addi x1, x1, 42
        rom_data[3] = 32'b0000000_00001_00000_010_00000_0100011; // sw 0(x0), x1
        rom_data[4] = 32'b000000000000_00000_010_00010_0000011; // lw x2, x0
        rom_data[5] = 32'b0_000000_00010_00001_000_0100_0_1100011; // beq x1, x2, 8
        // rom_data[6] is never run because of beq
        rom_data[7] = 32'b000000000000_00000_000_00000_0010011; // addi x0, x0, 0
        rom_data[8] = 32'b0_0000000100_0_00000000_00000_1101111; // jal x0, 8
        // rom_data[9] is never run because of beq
        rom_data[10] = 32'b000000000000_00000_000_00000_0010011; // addi x0, x0, 0

    end

    logic [31:0] rom_data [31:0];

    assign data = rom_data[addr/4];

endmodule;
