module top_module (
    input clk,
    input reset,
    output reg [3:0] q);
    always @(posedge clk) begin
        if(reset)
            q<=4'h1;
        else begin
            if(q==4'ha)
                q<=4'h1;
            else
                q<=q+1'h1;
        end
    end

endmodule
