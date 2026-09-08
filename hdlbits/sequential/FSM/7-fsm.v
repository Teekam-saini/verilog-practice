module top_module(
    input clk,
    input in,
    input areset,
    output out); //
    
    parameter a = 2'b00,
    b = 2'b01,
    c = 2'b10,
    d = 2'b11;
    
    reg [1:0] state,next_state;
    
    always @(*) begin
        case (state)
            a : next_state = in ? b : a;
            b : next_state = in ? b : c;
            c : next_state = in ? d : a;
            d : next_state = in ? b : c;
            default : next_state = a;
        endcase
    end
    
    always @(posedge clk or posedge areset) begin
        if(areset)
            state <=a;
        else
            state<=next_state;
    end
    
    assign out = (state==d);
    
        
    
    

    // State transition logic

    // State flip-flops with asynchronous reset

    // Output logic

endmodule
