module top_module (
    input clk,
    input reset,    // Synchronous reset to state B
    input in,
    output reg out
);

    // State declarations
    parameter A = 1'b0;
    parameter B = 1'b1;

    reg present_state, next_state;

    // 1. State transition logic (Combinational)
    always @(*) begin
        case (present_state)
            A: next_state = in ? A : B;
            B: next_state = in ? B : A;
            default: next_state = B;
        endcase
    end

    // 2. State flip-flops with synchronous reset (Sequential)
    always @(posedge clk) begin
        if (reset) begin
            present_state <= B; // Synchronous reset to state B
        end else begin
            present_state <= next_state;
        end
    end

    // 3. Output logic (Combinational or based on state)
    // State B outputs 1, State A outputs 0 (per fsm1 specifications)
    always @(*) begin
        case (present_state)
            A: out = 1'b0;
            B: out = 1'b1;
            default: out = 1'b1;
        endcase
    end

endmodule