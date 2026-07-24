module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);
    wire carry;
    wire [15:0] sum1,sum2;
    wire [31:0] x;
    assign x = b ^ {32{sub}};
    add16 inst1(
        .a(a[15:0]),
        .b(x[15:0]),
        .cin(sub),
        .cout(carry),
        .sum(sum1)
    );
    add16 inst2(
        .a(a[31:16]),
        .b(x[31:16]),
        .cin(carry),
        .cout(),
        .sum(sum2)
    );
    assign sum = {sum2,sum1};

endmodule
