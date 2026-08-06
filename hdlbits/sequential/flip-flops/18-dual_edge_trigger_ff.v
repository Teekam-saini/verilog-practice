module top_module (
    input clk,
    input d,
    output q
);

    reg q1, q2;

    // Positive-edge triggered flip-flop
    always @(posedge clk) begin
        q1 <= d;
    end

    // Negative-edge triggered flip-flop
    always @(negedge clk) begin
        q2 <= d;
    end

    // Multiplexer to select between q1 and q2 based on clock polarity
    assign q = clk ? q1 : q2;

endmodule