module controller(
    input logic [6:0] opcode,
    input logic [2:0] func3,
    input logic [6:0] func7,
    output logic [3:0] alu_control,
    output logic reg_write_control,
    output logic [1:0] sign_ext_control,
    output logic alu_input2_source_control,
    output logic data_mem_write_control,
    output logic [1: 0] reg_write_data_source_control,
    output logic is_branch,
    output logic branch_control,
    output logic is_jump
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
            'b0010011_???:
                begin
                    reg_write_control = 1; // Write
                    sign_ext_control = 2'b00; // I-type
                    alu_input2_source_control = 0; // Signext
                    data_mem_write_control = 0; // No write
                    reg_write_data_source_control = 2'b00; // ALU out as source
                    is_branch = 0; // Not a branch
                    branch_control = 0; // +4
                    is_jump = 0; // Not a jump
                end
            // Store
            'b0100011_???:
                begin
                    reg_write_control = 0; // No write
                    sign_ext_control = 2'b01; // S-type extension
                    alu_input2_source_control = 0; // Signext
                    data_mem_write_control = 1; // Write to ram
                    reg_write_data_source_control = 2'b00; // Unused
                    is_branch = 0; // Not a branch
                    branch_control = 0; // +4
                    is_jump = 0; // Not a jump
                end
            // Load
            'b0000011_???:
                begin
                    reg_write_control = 1; // Write
                    sign_ext_control = 2'b00; // I-type
                    alu_input2_source_control = 0; // Signext
                    data_mem_write_control = 0; // No write to ram
                    reg_write_data_source_control = 2'b01; // RAM output as source
                    is_branch = 0; // Not a branch
                    branch_control = 0; // +4
                    is_jump = 0; // Not a jump
                end
            // BEQ
            'b1100011_???:
                begin
                    reg_write_control = 0; // No write
                    sign_ext_control = 2'b10; // B-type
                    alu_input2_source_control = 1; // Reg 2
                    data_mem_write_control = 0; // No write to ram
                    reg_write_data_source_control = 2'b00; // Not used
                    is_branch = 1; // Is a branch
                    branch_control = 1; // Use pc + imm
                    is_jump = 0; // Not a jump
                end
            // Jal
            'b1101111_???:
                begin
                    reg_write_control = 1; // Write
                    sign_ext_control = 2'b11; // B-type
                    alu_input2_source_control = 1; // Unused
                    data_mem_write_control = 0; // No write to ram
                    reg_write_data_source_control = 2'b10; // PC + 4 as source
                    is_branch = 0; // Not a branch
                    branch_control = 0; // Not used
                    is_jump = 1; // Is a jump
                end
            // R-type
            'b0110011_???:
                begin
                    reg_write_control = 1; // Write
                    sign_ext_control = 2'b00; // Unused
                    alu_input2_source_control = 1; // Register
                    data_mem_write_control = 0; // No write to ram
                    reg_write_data_source_control = 2'b00; // Alu out
                    is_branch = 0; // Not a branch
                    branch_control = 0; // Not used
                    is_jump = 0; // Is a jump
                end
            default:
                begin
                    reg_write_control = 0;
                    data_mem_write_control = 0;
                    sign_ext_control = 0;
                    alu_input2_source_control = 0;
                    reg_write_data_source_control = 0;
                    is_branch = 0;
                    branch_control = 0;
                    $display("CONTROLLER: Opcode=0b%0b, Func3=0b%0b; Not handled", opcode, func3);
                end
        endcase

endmodule
