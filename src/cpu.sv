module cpu(input logic clk, input logic reset);

    logic[31:0] pc, instr, r1, r2, sign_ext_out, alu_out, data_out, reg_write_data;
    logic alu_zero;

    logic reg_write_control, data_memory_write_control, reg_write_data_source_control, pc_source_control;
    logic [1:0] sign_ext_control;
    logic [2:0] alu_control;

    initial
        pc = 0;

    rom instruction_memory(clk, pc, instr);

    // Datapath
    controller controller(
        instr[6:0],
        instr[14:12],
        alu_control,
        reg_write_control,
        sign_ext_control,
        data_memory_write_control,
        reg_write_data_source_control,
        pc_source_control
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

    alu alu(alu_control, r1, sign_ext_out, alu_zero, alu_out);

    ram data_memory(clk, data_memory_write_control, alu_out, r2, data_out);

    multiplexer2 reg_write_data_source_mux(
        reg_write_data_source_control,
        alu_out,
        data_out,
        reg_write_data
    );

    always_ff @(posedge clk)
        pc <= (pc_source_control == 0)? pc + 4 : pc + sign_ext_out;

endmodule
