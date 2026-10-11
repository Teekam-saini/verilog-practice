module top_module (
    input clk,
    input reset,   // Synchronous reset
    input x,
    output reg z,
    output reg [2:0] y
);

    // State encoding parameters
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    reg [2:0] next_state;

    // State Transition Logic (Combinational)
    always @(*) begin
        case (y)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S4 : S1;
            S2: next_state = x ? S1 : S2;
            S3: next_state = x ? S2 : S1;
            S4: next_state = x ? S4 : S3;
            default: next_state = S0;
        endcase
    end

    // Sequential State Update (Synchronous reset to 3'b000)
    always @(posedge clk) begin
        if (reset)
            y <= S0;
        else
            y <= next_state;
    end

    // Output Logic (Combinational or registered based on state/input)
    always @(*) begin
        case (y)
            S0, S1, S2: z = 1'b0;
            S3, S4:     z = 1'b1;
            default:    z = 1'b0;
        endcase
    end

endmodule