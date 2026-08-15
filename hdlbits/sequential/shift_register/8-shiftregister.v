module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR 
);

    // Instantiate 4 copies of MUXDFF, chained together as a shift register with parallel load
    // KEY[0]: clk
    // KEY[1]: E (enable)
    // KEY[2]: L (load)
    // KEY[3]: w (shift input)
    
    MUXDFF dff3 (
        .clk(KEY[0]),
        .enable(KEY[1]),
        .load(KEY[2]),
        .in(KEY[3]),
        .sw(SW[3]),
        .q(LEDR[3])
    );

    MUXDFF dff2 (
        .clk(KEY[0]),
        .enable(KEY[1]),
        .load(KEY[2]),
        .in(LEDR[3]),
        .sw(SW[2]),
        .q(LEDR[2])
    );

    MUXDFF dff1 (
        .clk(KEY[0]),
        .enable(KEY[1]),
        .load(KEY[2]),
        .in(LEDR[2]),
        .sw(SW[1]),
        .q(LEDR[1])
    );

    MUXDFF dff0 (
        .clk(KEY[0]),
        .enable(KEY[1]),
        .load(KEY[2]),
        .in(LEDR[1]),
        .sw(SW[0]),
        .q(LEDR[0])
    );

endmodule

// Submodule MUXDFF (from the preceding exam question parts if needed)
module MUXDFF (
    input clk,
    input enable,
    input load,
    input in,
    input sw,
    output reg q
);
    always @(posedge clk) begin
        if (load)
            q <= sw;
        else if (enable)
            q <= in;
    end
endmodule