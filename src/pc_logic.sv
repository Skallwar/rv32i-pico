module pc_logic(
    input logic clk,
    input logic enable,
    input logic [31:0] pc,
    input logic [31:0] pc_plus_4,
    input logic [31:0] ifid_pc,
    input logic [31:0] sign_ext_out,
    input logic alu_zero,
    input logic is_branch,
    input logic branch_control,
    input logic is_jump,
    output logic [31:0] new_pc
);

    always_comb
        begin
            if (enable && (is_branch || is_jump))
                new_pc = pc_plus_4;
            else if (is_branch)
                if (!(branch_control ^ alu_zero))
                    new_pc = ifid_pc + sign_ext_out;
                else
                        new_pc = ifid_pc + 4;
            else if (is_jump)
                new_pc = ifid_pc + sign_ext_out;
            else
                new_pc = pc_plus_4;

        end

endmodule
