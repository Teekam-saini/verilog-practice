module top_module ( input x, input y, output z );
    
    // make a t.t of this digram
    
    // x = 0 (0-200ns)| y = 0 (0 -200ns) | z =1
    // x = 1 (200-400ns)| y=0 (0-400ns) | z=0
    // x =  0 (400ns -600ns)| y= 1(400-600ns) | z =0
    // x = 1 ( 600 - 800ns)| y=1(600-800ns) | z =1
    
    // so as we can see this makes a x-nor truth table
    
    assign z = ~(x^y);

endmodule
