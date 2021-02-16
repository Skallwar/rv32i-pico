module sign_ext(
    input logic [11:0] immediate,
    output logic [31:0] sign_extended_immediate
);

    assign sign_extended_immediate = {{20{immediate[11]}}, immediate};

endmodule
