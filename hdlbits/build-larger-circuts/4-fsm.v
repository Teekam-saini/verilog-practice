module top_module (
    input clk,
    input reset,      // Synchronous reset
    output reg shift_ena
);

    // State encoding to count through 4 clock cycles
    parameter S0 = 3'd0; // Cycle 1 of shift
    parameter S1 = 3'd1; // Cycle 2 of shift
    parameter S2 = 3'd2; // Cycle 3 of shift
    parameter S3 = 3'd3; // Cycle 4 of shift
    parameter IDLE = 3'd4; // Done shifting (0 forever)

    reg [2:0] state, next_state;

    // 1. State Transition Logic (Combinational)
    always @(*) begin
        case (state)
            S0:   next_state = S1;
            S1:   next_state = S2;
            S2:   next_state = S3;
            S3:   next_state = IDLE;
            IDLE: next_state = IDLE;
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

    // 3. Output Logic (Moore style: assert shift_ena during the 4 active states)
    always @(*) begin
        if (state == IDLE)
            shift_ena = 1'b0;
        else
            shift_ena = 1'b1;
    end

endmodule