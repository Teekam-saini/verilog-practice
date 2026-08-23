module top_module(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    parameter A = 0, B = 1, C = 2, D = 3;

    // State transition logic (derived by inspection for one-hot encoding)
    assign next_state[A] = (state[A] & ~in) | (state[C] & ~in);
    assign next_state[B] = (state[A] & in)  | (state[B] & in)  | (state[D] & in);
    assign next_state[C] = (state[B] & ~in) | (state[D] & ~in);
    assign next_state[D] = (state[C] & in);

    // Output logic: state D outputs 1, others output 0
    assign out = state[D];
    

endmodule
