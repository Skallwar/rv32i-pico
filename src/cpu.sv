module cpu(input logic clk, input logic reset);

    logic[31:0] pc, instr, r1, r2, sign_ext_out, alu_out, data_out;
    logic [2:0] alu_control;
    logic reg_write_control, sign_ext_control, data_memory_write_control;

    // assign instr = 32'b10101000000000000010010011;
    initial
        pc = 0;

    rom instruction_memory(clk, pc, instr);
    controller controller(instr[6:0], instr[14:12], alu_control, reg_write_control, sign_ext_control, data_memory_write_control);
    regs regs(clk, reset, instr[19:15], instr[24:20], instr[11:7], alu_out, reg_write_control, r1, r2);
    sign_ext sign_ext(sign_ext_control, instr[31:0], sign_ext_out);
    alu alu(r1, sign_ext_out, alu_control, alu_out);
    ram data_memory(clk, data_memory_write_control, alu_out, r2, data_out);

    always_ff @(posedge clk)
        pc <= pc + 4;

endmodule
