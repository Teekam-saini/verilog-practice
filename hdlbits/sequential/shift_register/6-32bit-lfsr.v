module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 32'h1
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end 
        else begin
            // Galois LFSR shift operations with taps at positions 32, 22, 2, and 1
            // Bit indices map as follows: 32 -> q[31], 22 -> q[21], 2 -> q[1], 1 -> q[0]
            q <= { 1'b0 ^ q[0], 
                   q[31:23], 
                   q[22] ^ q[0], 
                   q[21:3], 
                   q[2] ^ q[0], 
                   q[1] ^ q[0] };
        end
    end

endmodule