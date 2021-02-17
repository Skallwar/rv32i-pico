module alu(
    input logic [31:0] input1,
    input logic [31:0] input2,
    input logic [2:0] control,
    output logic [31:0] result
);

    always_comb
        case(control)
            'b000: result = input1 + input2;
            'b111: result = input1 & input2;
            default: $display("ALU: Control=0b%0b; Not handled", control);
        endcase

endmodule
