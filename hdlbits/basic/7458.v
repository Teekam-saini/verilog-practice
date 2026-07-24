module top_module ( 
    input p1a, p1b, p1c, p1d, p1e, p1f,
    output p1y,
    input p2a, p2b, p2c, p2d,
    output p2y );
    wire x1,x2,x3,x4;
    
    assign x1 = p1c & p1b & p1a;
    assign x2 = p2a & p2b;
    assign x3 = p2c & p2d;
    assign x4 = p1f & p1e & p1d;
    
    assign p1y = x1 | x4;
    assign p2y = x3 | x2;


endmodule
