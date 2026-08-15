module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q
);

    
    wire e0 = 1'b1;
    wire e1, e2, e3;

  
    bcd_count counter0 (
        .clk(clk),
        .slowena(e0),
        .reset(reset),
        .q(q[3:0])
    );

 
    bcd_count counter1 (
        .clk(clk),
        .slowena(e1),
        .reset(reset),
        .q(q[7:4])
    );

  
    bcd_count counter2 (
        .clk(clk),
        .slowena(e2),
        .reset(reset),
        .q(q[11:8])
    );


    bcd_count counter3 (
        .clk(clk),
        .slowena(e3),
        .reset(reset),
        .q(q[15:12])
    );

    assign e1 = (q[3:0] == 4'd9);
    assign e2 = (q[7:4] == 4'd9) && e1;
    assign e3 = (q[11:8] == 4'd9) && e2;

    
    assign ena[1] = e1;
    assign ena[2] = e2;
    assign ena[3] = e3;

endmodule

// Helper module for a single BCD decade counter (0 to 9)
module bcd_count (
    input clk,
    input slowena,
    input reset,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'd0;
        end else if (slowena) begin
            if (q == 4'd9)
                q <= 4'd0;
            else
                q <= q + 4'd1;
        end
    end
endmodule