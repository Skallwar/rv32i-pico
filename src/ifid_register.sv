module ifid_register(
    input logic clk,
    input logic enable,
    input logic [31:0] instr_in,
    input logic [31:0] pc,
    output logic [31:0] instr_out,
    output logic [31:0] ifid_pc
);

    always_ff @(posedge clk)
        if (enable)
            begin
                instr_out <= instr_in;
                ifid_pc <= pc;
            end

endmodule
