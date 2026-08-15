module top_module (
    input [2:0] SW,       // R (input data for loading)
    input [1:0] KEY,      // KEY[0] is clock, KEY[1] is L (load control)
    output reg [2:0] LEDR // Q (outputs)
);

    always @(posedge KEY[0]) begin
        if (KEY[1]) begin
            // Synchronous load from switches when L is high
            LEDR <= SW;
        end else begin
            // Shift operations with feedback logic when L is low
            LEDR[0] <= LEDR[2];
            LEDR[1] <= LEDR[0];
            LEDR[2] <= LEDR[1] ^ LEDR[2];
        end
    end

endmodule