module universal_register (
    input wire clk,en,areset,sil,sir,
    input wire [1:0] sel,
    input wire [7:0] pi,
    output reg [7:0] po,
    output wire sol,sor
);

always @(posedge clk or posedge areset) begin
    if (areset ) begin
        po<=8'h00;
    end
    else if (en) begin
        case (sel)
           2'b00 : po<=po;                    
           2'b01 : po<={po[6:0],sil};
           2'b10 : po<= {sir,po[7:1]};
           2'b11 : po<= pi;
            default: po<=8'h00;
        endcase
    end

    
end
assign sol = po[7];
assign sor = po[0];
    
endmodule