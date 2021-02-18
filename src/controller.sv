module controller(
    input logic [6:0] opcode,
    input logic [2:0] func3,
    output logic [2:0] alu_control,
    output logic reg_write_control,
    output logic sign_ext_control,
    output logic data_mem_write_control,
    output logic reg_write_data_source_control
);

    logic [9:0] opcode_func3;
    assign opcode_func3 = {opcode, func3}; // (opcode << 3) | func3

    always_comb
        casez(opcode_func3)
            // Integer Register-Immediate
            'b0010011???:
                begin
                    alu_control = func3; // Forward func3 to ALU
                    reg_write_control = 1; // Write
                    sign_ext_control = 0; // I-type
                    data_mem_write_control = 0; // No write
                    reg_write_data_source_control = 0; // ALU out as source
                end
            // Store
            'b0100011???:
                begin
                    alu_control = 0; // Add
                    reg_write_control = 0; // No write
                    sign_ext_control = 1; // S-type extension
                    data_mem_write_control = 1; // Write to ram
                    reg_write_data_source_control = 0; // Unused
                end
            // Load
            'b0000011???:
                begin
                    alu_control = 0; // Add
                    reg_write_control = 1; // Write
                    sign_ext_control = 0; // I-type extension
                    data_mem_write_control = 0; // No write to ram
                    reg_write_data_source_control = 1; // RAM output as source
                end
            default:
                begin
                    alu_control = 0;
                    reg_write_control = 0;
                    data_mem_write_control = 0;
                    sign_ext_control = 0;
                    reg_write_data_source_control = 0;
                    $display("CONTROLLER: Opcode=0b%0b, Func3=0b%0b; Not handled", opcode, func3);
                end
        endcase

endmodule
