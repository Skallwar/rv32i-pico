module ram(
    input logic clk,
    input logic write_control,
    input logic [31:0] addr,
    input logic [31:0] write_data,
    output logic [31:0] out
);

    logic [31:0] ram_data [31:0];

    assign out = ram_data[addr/4];

    always_ff @(posedge clk)
        if (write_control) ram_data[addr/4] <= write_data;

endmodule;
