module regs(
    input logic clk,
    input logic reset,
    input logic reg_write_control,
    input logic [4:0] reg1_select,
    input logic [4:0] reg2_select,
    input logic [4:0] reg_write_select,
    input logic [31:0] reg_write_data,
    output logic [31:0] reg1,
    output logic [31:0] reg2
);

    logic [31:0] registers [31:1];

    assign reg1 = (reg1_select != 0) ? registers[reg1_select] : 0;
    assign reg2 = (reg2_select != 0) ? registers[reg2_select] : 0;

    always @(posedge clk)
    begin
        if (reg_write_control) registers[reg_write_select] <= reg_write_data;
    end

endmodule
