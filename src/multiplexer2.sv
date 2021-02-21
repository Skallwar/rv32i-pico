module multiplexer2 #(parameter width=32) (
    input logic control,
    input logic [width-1:0] in1,
    input logic [width-1:0] in2,
    output logic [width-1:0] out
);

    assign out = (control == 0)? in1 : in2; // 0 = in1; 1 = in2

endmodule

