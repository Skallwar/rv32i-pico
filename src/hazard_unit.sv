module hazard_unit(
    input logic clk,
    input logic [31:0] instr,
    output logic pc_enable,
    output logic ifid_enable
);

    logic pc_enable_new;
    logic ifid_enable_new;

    initial
        begin
            pc_enable = 1;
            ifid_enable = 1;
        end

    always_comb
        if (instr[6:0] == 7'b1100011 || instr[6:0] == 7'b1101111)
            begin
                pc_enable_new = 0;
                ifid_enable_new = 0;
            end
        else
            begin
                pc_enable_new = 1;
                ifid_enable_new = 1;
            end

    always_ff @(posedge clk)
        begin
            ifid_enable <= ifid_enable_new;
        end

    always_ff @(posedge clk)
        begin
            pc_enable <= pc_enable_new;
        end


endmodule
