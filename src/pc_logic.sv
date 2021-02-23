module pc_logic(
    input logic [31:0] pc,
    input logic [31:0] pc_plus_4,
    input logic [31:0] sign_ext_out,
    input logic alu_zero,
    input logic is_branch,
    input logic branch_control,
    input logic is_jump,
    output logic [31:0] new_pc
);

    always_comb
        begin
            if (is_branch && !(branch_control ^ alu_zero))
                new_pc = pc + sign_ext_out;
            else if (is_jump)
                new_pc = pc + sign_ext_out;
            else
                new_pc = pc_plus_4;
        end

endmodule
