module top(input logic clk, input logic reset);

    logic[31:0] instr, r1, sign_ext_out, alu_out;

    assign instr = 32'b10101000000000000010010011;

    regs regs(clk, reset, instr[19:15], instr[11:7], alu_out, r1);
    sign_ext sign_ext(instr[31:20], sign_ext_out);
    alu alu(r1, sign_ext_out, alu_out);

endmodule
