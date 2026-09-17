module pipo (
    input wire clk , areset,en,
    input wire [7:0] pi,
    output reg [7:0] po
);
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            po <= 8'h00;
        end
        else if (en) begin
            po<=pi;
            
        end
        
    end
endmodule