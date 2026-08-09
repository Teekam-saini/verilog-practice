module top_module (
    input clk,
    input reset,        // Synchronous active-high reset
    output reg [3:0] q);
    
    always @(posedge clk) begin
        if(reset)
            q <= 4'h0;
        else begin
            if(q==4'h9)
                q<=4'h0;
            else
            q <= q + 4'h1;
        end
    end

endmodule