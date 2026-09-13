module top_module(
    input clk,
    input areset,    
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    parameter LEFT = 3'b000, 
              RIGHT = 3'b001, 
              FALL_L = 3'b010, 
              FALL_R = 3'b011, 
              DIG_L = 3'b100, 
              DIG_R = 3'b101,
              SPLATTER = 3'b110;
    
    reg [2:0] state, next_state;
    reg [6:0] fall_count;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            fall_count <= 7'd0;
        end else if (state == FALL_L || state == FALL_R) begin
            fall_count <= fall_count + 7'd1;
        end else begin
            fall_count <= 7'd0;
        end
    end
    
    always @(*) begin
        case (state)
            LEFT: begin
                if (~ground) next_state = FALL_L;
                else if (dig) next_state = DIG_L;
                else if (bump_left) next_state = RIGHT;
                else next_state = LEFT;
            end
            
            RIGHT: begin
                if (~ground) next_state = FALL_R;
                else if (dig) next_state = DIG_R;
                else if (bump_right) next_state = LEFT;
                else next_state = RIGHT;
            end
            
            FALL_L: begin
                if (ground) begin
                    if (fall_count > 7'd20)
                        next_state = SPLATTER;
                    else
                        next_state = LEFT;
                end else begin
                    next_state = FALL_L;
                end
            end
            
            FALL_R: begin
                if (ground) begin
                    if (fall_count > 7'd20)
                        next_state = SPLATTER;
                    else
                        next_state = RIGHT;
                end else begin
                    next_state = FALL_R;
                end
            end
            
            DIG_L: begin
                if (~ground) next_state = FALL_L;
                else next_state = DIG_L;
            end
            
            DIG_R: begin
                if (~ground) next_state = FALL_R;
                else next_state = DIG_R;
            end
            
            SPLATTER: begin
                next_state = SPLATTER;
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
    
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_L || state == FALL_R);
    assign digging = (state == DIG_L || state == DIG_R);

endmodule