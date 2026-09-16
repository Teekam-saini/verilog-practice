module sipo (
    input wire clk , areset , en ,si , op,
    output reg [7:0] q

); 

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q<=8'h00;
    end
    else if (en) begin
        case (op)
           1'b0 : q<={q[6:0],si};
           1'b1 : q<={si,q[7:1]};
            default: q<=8'h00;
        endcase
        
        
    end
end


    

endmodule