module top_module (
    input clk,
    input slowena,
    input reset,
    output reg [3:0] q);
    
    always @(posedge clk) begin
        if(reset)
            q<=4'h0;
        else if(slowena) begin
            if(q==4'h9)
                q<=4'h0;
            else
                q<=q+1'h1;
        end
    end
        
           

endmodule
