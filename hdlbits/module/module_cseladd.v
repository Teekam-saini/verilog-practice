module top_module(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] sum
);
    reg carry;
    reg [15:0] sum1,sum2,sum3;
    add16 inst1(
        .a(a[15:0]),
        .b(b[15:0]),
        .cout(carry),
        .cin(1'b0),
        .sum(sum1),
    );
    add16 inst2(
        .a(a[31:16]),
        .b(b[31:16]),
        .cout(),
        .cin(1'b0),
        .sum(sum2)
    );
    add16 inst3(
        .a(a[31:16]),
        .b(b[31:16]),
        .cin(1'b1),
        .cout(),
        .sum(sum3)
    );
    
    always @(*)begin 
        case (carry)
            1'b0 : sum = {sum2,sum1};
            1'b1 : sum = {sum3,sum1};
            default : sum = 1'b0;
        endcase
    end
        
    
    
        
    

endmodule
