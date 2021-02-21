module controller(
    input logic [6:0] opcode,
    input logic [2:0] func3,
    input logic [6:0] func7,
    output logic [3:0] alu_control,
    output logic reg_write_control,
    output logic [1:0] sign_ext_control,
    output logic alu_input2_source_control,
    output logic data_mem_write_control,
    output logic reg_write_data_source_control,
    output logic pc_source_control
);

    logic [9:0] opcode_func3;
    logic [3:0] alu_dec_res;
    assign opcode_func3 = {opcode, func3}; // (opcode << 3) | func3

    // logic [1:0] test;
    // logic test1, test0;
    // assign {test1, test0} = test;

    alu_dec alu_dec(opcode, func3, func7, alu_dec_res);

    assign alu_control = alu_dec_res;

    always_comb
        casez(opcode_func3)
            // Integer Register-Immediate
            'b0010011???:
                begin
                    // alu_control = func3; // Forward func3 to ALU
                    reg_write_control = 1; // Write
                    sign_ext_control = 'b0; // I-type
                    alu_input2_source_control = 0; // Signext
                    data_mem_write_control = 0; // No write
                    reg_write_data_source_control = 0; // ALU out as source
                    pc_source_control = 0; // +4
                end
            // Store
            'b0100011???:
                begin
                    // alu_control = 0; // Add
                    reg_write_control = 0; // No write
                    sign_ext_control = 'b1; // S-type extension
                    alu_input2_source_control = 0; // Signext
                    data_mem_write_control = 1; // Write to ram
                    reg_write_data_source_control = 0; // Unused
                    pc_source_control = 0; // +4
                end
            // Load
            'b0000011???:
                begin
                    // alu_control = 0; // Add
                    reg_write_control = 1; // Write
                    sign_ext_control = 'b0; // I-type
                    alu_input2_source_control = 0; // Signext
                    data_mem_write_control = 0; // No write to ram
                    reg_write_data_source_control = 1; // RAM output as source
                    pc_source_control = 0; // +4
                end
            // BEQ
            'b1100011???:
                begin
                    // alu_control = 1; // Sub
                    reg_write_control = 0; // No write
                    sign_ext_control = 'b10; // B-type
                    alu_input2_source_control = 1; // Reg 2
                    data_mem_write_control = 0; // No write to ram
                    reg_write_data_source_control = 0; // Not used
                    pc_source_control = 1; // Use pc + imm
                end
            default:
                begin
                    // alu_control = 0;
                    reg_write_control = 0;
                    data_mem_write_control = 0;
                    sign_ext_control = 0;
                    alu_input2_source_control = 0;
                    reg_write_data_source_control = 0;
                    pc_source_control = 0; // +4
                    $display("CONTROLLER: Opcode=0b%0b, Func3=0b%0b; Not handled", opcode, func3);
                end
        endcase

endmodule
