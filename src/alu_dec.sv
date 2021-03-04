module alu_dec(
    input logic [6:0] opcode,
    input logic [2:0] func3,
    input logic [6:0] func7,
    output logic [3:0] alu_control
);

    // This module is an implementation of Figure 4.12 in Computer
    // Organization and Design RISCV Edition

    logic [16:0] opcode_func7_func3;

    assign opcode_func7_func3 = {opcode, func7, func3};

    always_comb
        casez(opcode_func7_func3)
            // ld
            17'b0000011_???????_???: alu_control = 4'b0010;
            // sd
            17'b0100011_???????_???: alu_control = 4'b0010;
            // beq
            17'b1100011_???????_000: alu_control = 4'b0110;
            // R-type add
            17'b0110011_0000000_000: alu_control = 4'b0010;
            // R-type sub
            17'b0110011_0100000_000: alu_control = 4'b0110;
            // R-type and
            17'b0110011_0000000_111: alu_control = 4'b0000;
            // R-type or
            17'b0110011_0000000_110: alu_control = 4'b0001;
            // R-typ slt
            17'b0110011_0000000_010: alu_control = 4'b0011;
            // I-type add
            17'b0010011_???????_000: alu_control = 4'b0010;
            // I-type and
            17'b0010011_???????_111: alu_control = 4'b0000;
            // J-type jal:
            17'b1101111_???????_???: alu_control = 4'b0000; // Not used
            default:
                begin
                    alu_control = 4'b1111;
                    $display(
                        "ALUDEC: Opcode=0b%0b, Func3=0b%0b, Func7=0b%0b; Not handled",
                        opcode, func3, func7
                    );
                end
        endcase

endmodule
