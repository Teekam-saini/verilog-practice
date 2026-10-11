module top_module (
    input clk,
    input areset,
    input x,
    output reg z
); 
    parameter a = 1'b0 , b =1'b1;
    
    reg state , next_state;
    
    always @(*) begin
        case(state)
            a : next_state = x? b : a;
            b : next_state = x ? b : b;
            default next_state = a;
        endcase
    end
    
    always @(posedge clk or posedge areset) begin
        if(areset)
            state<=1'b0;
        else
            state<= next_state;
    end
    
    always @(*) begin
        
        case(state)
            a:z=x;
            b:z=~x;
            default z = 1'b0;
        endcase
    end    

endmodule