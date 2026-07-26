module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );
    
    wire [99:0] cout1;
    
    bcd_fadd inst0(
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .cout(cout1[0]),
        .sum(sum[3:0]));
    
    genvar i;
    generate
        for(i=1; i<100;i++) begin : bcd
            bcd_fadd inst(
                .a(a[4*i +:4]),
                .b(b[4*i +:4]),
                .cin(cout1[i-1]),
                .cout(cout1[i]),
                .sum(sum[4*i +:4])
            );
        end
    endgenerate
    assign cout = cout1[99];
    


    
    

endmodule
