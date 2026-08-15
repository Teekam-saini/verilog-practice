module top_module (
    input clk,
    input resetn, // synchronous active-low reset
    input in,
    output out
);

    reg [3:0] q;

    // Output is taken from the last stage of the shift register
    assign out = q[0];

    always @(posedge clk) begin
        if (!resetn) begin
            q <= 4'b0;
        end 
        else begin
            // Shift in the new bit from 'in' and pass the rest down
            q <= {in, q[3:1]};
        end
    end

endmodule