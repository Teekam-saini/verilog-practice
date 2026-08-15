module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] L = {1'b0, q[511:1]};  // Left neighbor with 0 boundary at q[511]
    wire [511:0] R = {q[510:0], 1'b0};  // Right neighbor with 0 boundary at q[0]

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Correct Rule 110 logic expression
            q <= (~L & q) | (q & ~R) | (~q & R);
        end
    end

endmodule