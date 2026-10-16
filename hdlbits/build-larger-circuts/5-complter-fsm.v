module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

    // State Encoding
    parameter S_IDLE   = 4'd0,
              S_1      = 4'd1,
              S_11     = 4'd2,
              S_110    = 4'd3,
              S_SHIFT1 = 4'd4,
              S_SHIFT2 = 4'd5,
              S_SHIFT3 = 4'd6,
              S_SHIFT4 = 4'd7,
              S_COUNT  = 4'd8,
              S_DONE   = 4'd9;

    reg [3:0] state, next_state;

    // 1. State Transition Logic (Combinational)
    always @(*) begin
        case (state)
            S_IDLE:   next_state = data ? S_1      : S_IDLE;
            S_1:      next_state = data ? S_11     : S_IDLE;
            S_11:     next_state = data ? S_11     : S_110;
            S_110:    next_state = data ? S_SHIFT1 : S_IDLE;
            S_SHIFT1: next_state = S_SHIFT2;
            S_SHIFT2: next_state = S_SHIFT3;
            S_SHIFT3: next_state = S_SHIFT4;
            S_SHIFT4: next_state = S_COUNT;
            S_COUNT:  next_state = done_counting ? S_DONE : S_COUNT;
            S_DONE:   next_state = ack ? S_IDLE : S_DONE;
            default:  next_state = S_IDLE;
        endcase
    end

    // 2. Sequential State Update (Synchronous Reset)
    always @(posedge clk) begin
        if (reset)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // 3. Output Logic (Moore style)
    always @(*) begin
        // Default output values
        shift_ena = 1'b0;
        counting  = 1'b0;
        done      = 1'b0;

        case (state)
            S_SHIFT1, S_SHIFT2, S_SHIFT3, S_SHIFT4: begin
                shift_ena = 1'b1;
            end
            S_COUNT: begin
                counting = 1'b1;
            end
            S_DONE: begin
                done = 1'b1;
            end
            default: ;
        endcase
    end

endmodule