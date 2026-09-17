module load_register (
    input wire clk , areset ,en,
    input wire [1:0] load ,
    input wire [7:0] pi,q,
    output reg [7:0] po
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        po<=8'h0;
    end
    else if (en) begin
        case (load)
          2'b00  : po<=po;
          2'b01 : po<=pi;
          2'b10 : po<= po << 1;
          2'b11 : po<=q;
            default: po<=8'h0;
        endcase
        
    end
end
    
endmodule