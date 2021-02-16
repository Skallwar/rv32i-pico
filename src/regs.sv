module regs(
    input logic clk,
    input logic reset,
    input logic [4:0] reg1_select,
    input logic [4:0] reg_write_select,
    input logic [31:0] reg_write_data,
    output logic [31:0] reg1
);

    logic [31:0] register [31:0];

    assign register[0] = 'b0;

    always_ff @(posedge clk)
    begin
        reg1 <= register[reg1_select];
        register[reg_write_select] <= reg_write_data;
    end


endmodule
