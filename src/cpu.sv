module cpu(input logic clk, input logic reset);

    logic[31:0] pc, pc_plus_4, new_pc, instr, r1, r2, sign_ext_out, alu_out, data_out, reg_write_data, alu_input2;
    logic alu_zero;

    logic reg_write_control, data_memory_write_control, pc_source_control, alu_input2_source_control, is_branch, branch_control, is_jump;
    logic [1:0] sign_ext_control, reg_write_data_source_control;
    logic [3:0] alu_control;

    assign pc_plus_4 = pc + 4;

    initial
        pc = 0;

    rom instruction_memory(clk, pc, instr);

    // Datapath
    controller controller(
        instr[6:0],
        instr[14:12],
        instr[31:25],
        alu_control,
        reg_write_control,
        sign_ext_control,
        alu_input2_source_control,
        data_memory_write_control,
        reg_write_data_source_control,
        is_branch,
        branch_control,
        is_jump
    );

    regs regs(
        clk,
        reset,
        reg_write_control,
        instr[19:15],
        instr[24:20],
        instr[11:7],
        reg_write_data,
        r1,
        r2
    );

    sign_ext sign_ext(sign_ext_control, instr[31:0], sign_ext_out);

    multiplexer2 alu_input2_source(
        alu_input2_source_control,
        sign_ext_out,
        r2,
        alu_input2
    );

    alu alu(alu_control, r1, alu_input2, alu_zero, alu_out);

    ram data_memory(clk, data_memory_write_control, alu_out, r2, data_out);

    multiplexer3 reg_write_data_source_mux(
        reg_write_data_source_control,
        alu_out,
        data_out,
        pc_plus_4,
        reg_write_data
    );

    pc_logic pc_logic(pc, pc_plus_4, sign_ext_out, alu_zero, is_branch, branch_control, is_jump, new_pc);

    always_ff @(posedge clk)
        pc <= new_pc;

endmodule
