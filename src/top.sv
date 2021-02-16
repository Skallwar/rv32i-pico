module top(input logic clk, input logic reset);

    logic[31:0] instr, r1, sign_ext_out, alu_out;

    assign instr = 32'b10101000000000000010010011;

    regs(clk, reset, instr[19:15], r1);
    sign_ext(instr[31:20], sign_ext_out);
    alu(r1, sign_ext_out);

endmodule
