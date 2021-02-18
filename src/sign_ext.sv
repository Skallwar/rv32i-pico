module sign_ext(
    input logic control,
    input logic [31:0] instruction,
    output logic [31:0] res
);

    always_comb
        case(control)
            // I-type
            0'b0: res = {{20{instruction[31]}}, {instruction[31:20]}};
            // S-type
            1'b1: res = {{20{instruction[31]}}, {instruction[31:25]}, {instruction[11:7]}};
        endcase

endmodule
