module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output reg start_shifting
);

    // State encoding for recognizing "1101"
    parameter S0   = 3'd0; // Starting state (saw nothing)
    parameter S1   = 3'd1; // Saw "1"
    parameter S11  = 3'd2; // Saw "11"
    parameter S110 = 3'd3; // Saw "110"
    parameter S_OK = 3'd4; // Saw "1101" (target reached)

    reg [2:0] state, next_state;

    // 1. State Transition Logic (Combinational)
    always @(*) begin
        case (state)
            S0:   next_state = data ? S1   : S0;
            S1:   next_state = data ? S11  : S0;
            S11:  next_state = data ? S11  : S110;
            S110: next_state = data ? S_OK : S0;
            S_OK: next_state = S_OK; // Stay locked in S_OK once found
            default: next_state = S0;
        endcase
    end

    // 2. Sequential State Update (Synchronous Reset)
    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // 3. Output Logic (Moore style: depends on current state)
    always @(*) begin
        if (state == S_OK)
            start_shifting = 1'b1;
        else
            start_shifting = 1'b0;
    end

endmodule