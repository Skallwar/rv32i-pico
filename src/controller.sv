module controller(
    input logic [6:0] opcode,
    input logic [2:0] func3,
    output logic [2:0] alu_control
);

    logic [9:0] opcode_func3;
    assign opcode_func3 = {opcode, func3}; // (opcode << 3) | func3

    always_comb
        casez(opcode_func3)
            // Addi
            'b0010011???: alu_control = func3;
            default: $display("CONTROLLER: Opcode=0b%0b, Func3=0b%0b; Not handled", opcode, func3);
        endcase

endmodule
