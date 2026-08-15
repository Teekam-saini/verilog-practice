module top_module (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z 
);

    reg [7:0] q;

    // 8-bit shift register with enable
    always @(posedge clk) begin
        if (enable) begin
            q <= {q[6:0], S};
        end
    end

    // 3-input lookup table implemented via multiplexer (selecting based on A, B, C)
    assign Z = q[{A, B, C}];

endmodule