module fadd(
    input  a,b,cin,
    output  cout,sum);
    assign sum = a^b^cin;
    assign cout = (a&b) | (a&cin) | (b&cin);
endmodule

module top_module( 
    input [99:0] a, b,
    input cin,
    output [99:0] cout,
    output [99:0] sum );
    
    fadd inst0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .cout(cout[0]),
        .sum(sum[0])
    );
    
    genvar i;
    generate        
        for(i=1;i<100;i++) begin : ripple_carry
            
            fadd inst(
                .a(a[i]),
                .b(b[i]),
                .cin(cout[i-1]),
                .cout(cout[i]),
                .sum(sum[i])
            );
        end
        endgenerate
    
                
            
            
    
    
    

endmodule
