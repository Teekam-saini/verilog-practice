module top_module (
    input clk,
    input j,
    input k,
    output reg Q); 
    reg [1:0] sel;
    assign sel = {j,k};
    always @(posedge clk) begin
        case (sel)
            2'b00 : Q <= Q;
            2'b01 : Q <= 0;
            2'b10 : Q <= 1;
            2'b11 : Q <= ~Q;
        endcase
    end
    

endmodule
