module top_module (
    input in1,
    input in2,
    input in3,
    output out);
    wire x1;
    
    assign x1 = ~(in1^in2);
    assign out = x1 ^in3;

endmodule
