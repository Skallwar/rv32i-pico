module multiplexer3 #(parameter width=32) (
    input logic [1:0] control,
    input logic [width-1:0] in1,
    input logic [width-1:0] in2,
    input logic [width-1:0] in3,
    output logic [width-1:0] out
);

    // assign out = (control == 0)? in1 : in2; // 0 = in1; 1 = in2
    always_comb
        case(control)
            2'b00: out = in1;
            2'b01: out = in2;
            2'b10: out = in3;
            default:
                begin
                    out = 'hCAFE;
                    $display("MULTIPLEXER 3: 0b%0b; Not handled", control);
                end
        endcase

endmodule

