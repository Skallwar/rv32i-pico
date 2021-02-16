module alu(
    input logic [31:0] input1,
    input logic [31:0] input2,
    output logic [31:0] result
);

    assign result = input1 + input2;

endmodule
