module sign_ext(
    input logic [1:0] control,
    input logic [31:0] instruction,
    output logic [31:0] res
);

    always_comb
        case(control)
            // I-type
            'b00: res = {{20{instruction[31]}}, {instruction[31:20]}};
            // S-type
            'b01: res = {{20{instruction[31]}}, {instruction[31:25]}, {instruction[11:7]}};
            // B-type
            'b10: res = {{19{instruction[31]}}, {instruction[31]}, {instruction[7]}, {instruction[30:25]}, {instruction[11:8]}, 1'b0};
        endcase

endmodule
