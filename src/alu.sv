module alu(
    input logic [3:0] control,
    input logic [31:0] input1,
    input logic [31:0] input2,
    output logic zero,
    output logic [31:0] result
);

    assign zero = result == 0;

    always_comb
        case(control)
            4'b0000: result = input1 & input2;
            4'b0001: result = input1 | input2;
            4'b0010: result = input1 + input2;
            4'b0011: result = {{31{1'0}}, input1 < input2};
            4'b0110: result = input1 - input2;
            default: 
                begin
                    result = 'hCAFE;
                    $display("ALU: Control=0b%0b; Not handled", control);
                end
        endcase

endmodule
