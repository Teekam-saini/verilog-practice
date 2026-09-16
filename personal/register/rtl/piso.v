module piso (
    input wire clk,areset,en,op,load,
    input wire [7:0] pi,
    output wire so
);
reg [7:0] q ;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q=8'h0;
        
        
    end
    else if (load) begin
        q<=pi;

        
    end
    else if (en) begin
        case (op)
           1'b0 : q<= q<<1'b1;
           1'b1 :q<= q>>1'b0;

            default: q<=8'b0;
        endcase
        
    end
    
end
    assign so = op? q[0]:q[7];
endmodule