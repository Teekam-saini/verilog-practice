module top_module( 
    input x3,
    input x2,
    input x1,  // three inputs
    output f   // one output
);
    //there are two ways to do this one is SOP and other is POS.
    //i m going to use POS.
    assign f = ((x3 | x2 | x1) &  
                 ( x3 | x2 | ~x1) & 
                 (~x3 | x2 | x1)
                 & ( ~x3 | ~x2 | x1));
    
    

endmodule
