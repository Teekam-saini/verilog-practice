module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Rule 90: q[i] next = q[i+1] ^ q[i-1]
            // Left boundary cell q[511] has left neighbor 0 -> {q[510:0], 1'b0}
            // Right boundary cell q[0] has right neighbor 0 -> {1'b0, q[511:1]}
            q <= {q[510:0], 1'b0} ^ {1'b0, q[511:1]};
        end
    end

endmodule