module hazard_unit(
    input logic clk,
    input logic [31:0] instr,
    input logic [31:0] ifid_instr,
    input logic [31:0] idex_instr,
    output logic pc_enable,
    output logic ifid_enable,
    output logic idex_enable
);

    logic pc_enable_new;
    logic ifid_enable_new;
    // logic idex_enable_new;

    initial
        begin
            pc_enable = 1;
            ifid_enable = 1;
            // idex_enable = 1;
        end


    always_comb
        if ((instr[6:0] == 7'b1100011 || instr[6:0] == 7'b1101111) && pc_enable == 1)
            begin
                pc_enable_new = 0;
                // ifid_enable_new = 0;
                // idex_enable_new = 1;
            end
        else if (ifid_instr[6:0] == 7'b1100011 || ifid_instr[6:0] == 7'b1101111)
            begin
                pc_enable_new = 0;
                // ifid_enable_new = 0;
            end
        else if (idex_instr[6:0] == 7'b1100011 || idex_instr[6:0] == 7'b1101111)
            begin
                pc_enable_new = 1;
                // ifid_enable_new = 0;
            end
        else
            begin
                pc_enable_new = 1;
                // ifid_enable_new = 1;
                // idex_enable_new = 1;
            end

    always_ff @(posedge clk)
        begin
            pc_enable <= pc_enable_new;
            ifid_enable <= pc_enable;
            idex_enable <= ifid_enable;
        end

endmodule
