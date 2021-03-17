module idex_register(
    input logic clk,
    input logic enable,
    input logic [31:0] pc_in,
    input logic [31:0] sign_ext_in,
    input logic [31:0] r1_in,
    input logic [31:0] r2_in,
    output logic [31:0] pc_out,
    output logic [31:0] sign_ext_out,
    output logic [31:0] r1_out,
    output logic [31:0] r2_out
);

    always_ff @(posedge clk)
        if (enable)
            begin
                pc_out <= pc_in;
                sign_ext_out <= sign_ext_in;
                r1_out <= r1_in;
                r2_out <= r2_in;
            end

endmodule;
