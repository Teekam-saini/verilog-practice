module top_module (input x, input y, output z);
    
    wire o1,o2,o3,o4;
    
    A ia1(x,y,o1);
    B ib1(x,y,o2);
    A ia2(x,y,o3);
    B ib2(x,y,o4);
    
    assign z = (o1|o2) ^ (o3&o4);
endmodule

//we need to create submodules and the submodules are given in pervious 
//in question cn chekc your previous problem gate and use that gate 
//as a submodule here.

module A(
    input x,y,
    output z);
    assign z = (x^y)&x;
endmodule

module B(
    input x,y,
    output z);
    assign z = ~(x^y);
endmodule
