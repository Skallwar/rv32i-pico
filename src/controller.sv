module controller(
    input logic [6:0] opcode,
    input logic [2:0] func3,
    output logic [2:0] alu_control,
    output logic reg_write_control
);

    logic [9:0] opcode_func3;
    assign opcode_func3 = {opcode, func3}; // (opcode << 3) | func3

    always_comb
        casez(opcode_func3)
            // Addi
            'b0010011???:
                begin
                    alu_control = func3;
                    reg_write_control = 1;
                end
            default:
                begin
                    alu_control = 0;
                    reg_write_control = 0;
                    $display("CONTROLLER: Opcode=0b%0b, Func3=0b%0b; Not handled", opcode, func3);
                end
        endcase

endmodule
