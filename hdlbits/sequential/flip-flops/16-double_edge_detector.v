module top_module (
    input clk,
    input [7:0] in,
    output reg [7:0] anyedge
);

    reg [7:0] in_d;

    always @(posedge clk) begin
        // Store the previous value of 'in'
        in_d    <= in;
        
        // Detect any change (rising or falling edge) using XOR
        anyedge <= in ^ in_d;
    end

endmodule