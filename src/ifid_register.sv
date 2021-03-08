module ifid_register(
    input logic clk,
    input logic enable,
    input logic [31:0] instr_in,
    output logic [31:0] instr_out
);

    always_ff @(posedge clk)
        if (enable)
            instr_out <= instr_in;

endmodule
