module add1(
        input a,b,cin,
        output cout,sum);
        
        assign sum = a^b^cin;
        assign cout = (a&b) | (a&cin) | (b&cin);
   
endmodule
    
module top_module (
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    
    wire carry;
    wire [15:0] sum1,sum2;

    add16 inst1(
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),
        .cout(carry),
        .sum(sum1)
    );
    add16 inst2(
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(carry),
        .cout(),
        .sum(sum2)
    );
    assign sum = {sum2,sum1};
    
    

endmodule
