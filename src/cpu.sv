module cpu(input logic clk, input logic reset);

    logic[31:0] pc, pc_plus_4, new_pc, ifid_pc, instr, r1, r2, sign_ext_out, alu_out, data_out, reg_write_data, alu_input2, instr_fetch;
    // Controler signals
    logic reg_write, ram_write, alu_in2_ctrl, is_branch, branch_ctrl, is_jump;
    logic [3:0] alu_control;
    logic [1:0] sign_ext_ctrl, reg_write_source_ctrl;
    logic alu_zero;
    // Hazard unit signals
    logic ifid_enable, pc_enable;


    assign pc_plus_4 = pc + 4;


    initial
        pc = 0;

    // Datapath control

    controller controller(
        instr[6:0],
        instr[14:12],
        instr[31:25],
        alu_control,
        reg_write,
        sign_ext_ctrl,
        alu_in2_ctrl,
        ram_write,
        reg_write_source_ctrl,
        is_branch,
        branch_ctrl,
        is_jump
    );

    hazard_unit hazard_unit(clk, instr_fetch, instr, idex_instr, pc_enable, ifid_enable, idex_enable);


    // Datapath

    rom instruction_fetch(pc, instr_fetch);

    ifid_register ifid_register(
        clk,
        ifid_enable,
        instr_fetch,
        pc,
        instr,
        ifid_pc
    );

    regs regs(
        clk,
        reset,
        reg_write,
        instr[19:15],
        instr[24:20],
        instr[11:7],
        reg_write_data,
        r1,
        r2
    );

    sign_ext sign_ext(sign_ext_ctrl, instr[31:0], sign_ext_out);

    logic idex_enable;
    logic [31:0] idex_pc, idex_sign_ext, idex_r1, idex_r2, idex_instr;
    idex_register idex_register(
        clk,
        idex_enable,
        ifid_pc,
        instr,
        sign_ext_out,
        r1,
        r2,
        idex_pc,
        idex_instr,
        idex_sign_ext,
        idex_r1,
        idex_r2
    );


    multiplexer2 alu_input2_source(
        alu_in2_ctrl,
        idex_sign_ext,
        idex_r2,
        alu_input2
    );

    alu alu(alu_control, idex_r1, alu_input2, alu_zero, alu_out);

    ram data_memory(clk, ram_write, alu_out, idex_r2, data_out);

    multiplexer3 reg_write_data_source_mux(
        reg_write_source_ctrl,
        alu_out,
        data_out,
        pc_plus_4,
        reg_write_data
    );

    pc_logic pc_logic(
        clk,
        pc_enable,
        pc,
        pc_plus_4,
        idex_pc,
        idex_sign_ext,
        alu_zero,
        is_branch,
        branch_ctrl,
        is_jump,
        new_pc
    );


    always_ff @(posedge clk)
        pc <= new_pc;

endmodule
