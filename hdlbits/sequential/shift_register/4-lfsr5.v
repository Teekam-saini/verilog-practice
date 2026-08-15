module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 5'h1
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'h1;
        end 
        else begin
            // Galois LFSR shift operations with taps at positions 5 and 3
            q[0] <= q[1];
            q[1] <= q[2];
            q[2] <= q[3] ^ q[0];
            q[3] <= q[4];
            q[4] <= q[0];
        end
    end

endmodule