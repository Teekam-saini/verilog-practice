module top_module(
    input clk,
    input [7:0] in,
    input reset,
    output reg done
);

    parameter IDLE = 2'b00, 
              B1   = 2'b01, 
              B2   = 2'b10, 
              B3   = 2'b11;
              
    reg [1:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE: next_state = in[3] ? B1 : IDLE;
            B1:   next_state = B2;
            B2:   next_state = B3;
            B3:   next_state = in[3] ? B1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output logic
    always @(*) begin
        done = (state == B3);
    end

endmodule