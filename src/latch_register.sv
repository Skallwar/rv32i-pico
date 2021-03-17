module latch_register #(parameter width=32) (
    input logic clock,
    input logic enable,
    input logic [width-1:0] in,
    output logic [width-1:0] out
);

    always_ff @(posedge clock)
        if (enable)
            out <= in;

endmodule
