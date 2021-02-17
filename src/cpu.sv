module cpu(input logic clk, input logic reset);

    logic[31:0] pc, instr, r1, sign_ext_out, alu_out;
    logic [2:0] alu_control;

    // assign instr = 32'b10101000000000000010010011;
    initial
        pc = 0;

    rom instruction_rom(clk, pc, instr);
    controller controller(instr[6:0], instr[14:12], alu_control);
    regs regs(clk, reset, instr[19:15], instr[11:7], alu_out, r1);
    sign_ext sign_ext(instr[31:20], sign_ext_out);
    alu alu(r1, sign_ext_out, alu_control, alu_out);

    always_ff @(posedge clk)
        pc <= pc + 4;

endmodule
