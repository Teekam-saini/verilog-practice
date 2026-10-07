module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 
    
    parameter s0 = 2'b00, s1 = 2'b01, s10 = 2'b10; // Fixed with commas
    
    reg [1:0] current_state, next_state;
    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            current_state <= s0;
        else
            current_state <= next_state;
    end
    
    always @(*) begin
        case (current_state)
            s0:  next_state = x ? s1  : s0;  
            s1:  next_state = x ? s1  : s10; // 
            s10: next_state = x ? s1  : s0;  // 
            default: next_state = s0;        //
        endcase
    end
            
    assign z = (current_state == s10 && x == 1);

endmodule