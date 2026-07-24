module top_module( 
    input [7:0] in,
    output [7:0] out
);
    integer i;
    always @(*)
        for(i=0; i<8; i++)
            out[i] = in[8-i-1];
    

endmodule
