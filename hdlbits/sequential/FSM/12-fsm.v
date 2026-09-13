module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output reg aaah,
    output reg digging ); 
    
    // Parameters for states
    parameter LEFT   = 3'b000,
              RIGHT  = 3'b001,
              FALL_L = 3'b010,
              FALL_R = 3'b011,
              DIG_L  = 3'b100,
              DIG_R  = 3'b101;
              
    reg [2:0] state, next_state;
    
    always @(*) begin
        case (state)
            LEFT: begin
                if (!ground) 
                    next_state = FALL_L;
                else if (dig) 
                    next_state = DIG_L;
                else 
                    next_state = bump_left ? RIGHT : LEFT;
            end
            
            RIGHT: begin
                if (!ground) 
                    next_state = FALL_R;
                else if (dig) 
                    next_state = DIG_R;
                else 
                    next_state = bump_right ? LEFT : RIGHT;
            end
            
            FALL_L: begin
                next_state = ground ? LEFT : FALL_L;
            end
            
            FALL_R: begin
                next_state = ground ? RIGHT : FALL_R;
            end
            
            DIG_L: begin
                next_state = !ground ? FALL_L : DIG_L;
            end
            
            DIG_R: begin
                next_state = !ground ? FALL_R : DIG_R;
            end
            
            default: next_state = LEFT;
        endcase
    end
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= LEFT;
        else
            state <= next_state;
    end
    
    // Outputs
    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    
    always @(*) begin
        aaah    = (state == FALL_L) || (state == FALL_R);
        digging = (state == DIG_L)  || (state == DIG_R);
    end

endmodule