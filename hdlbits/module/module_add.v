module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
    wire [15:0] a1,a2;
    wire carry;
    add16 add1(
        .a(a[15:0]),
        .b(b[15:0]),
        .cin(1'b0),
        .sum(a1),
        .cout(carry)
    );
    add16 add2(
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(carry),
        .cout(),
        .sum(a2)
    );
    
    assign sum = {a2,a1};//it will {a2,a1} a2 is frst becase it has upper bits

endmodule
