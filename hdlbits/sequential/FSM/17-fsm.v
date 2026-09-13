module top_module(
    input clk,
    input in,
    input reset,
    output reg done
);

    parameter IDLE  = 4'd0,
              B0    = 4'd1,
              B1    = 4'd2,
              B2    = 4'd3,
              B3    = 4'd4,
              B4    = 4'd5,
              B5    = 4'd6,
              B6    = 4'd7,
              B7    = 4'd8,
              STOP  = 4'd9,
              ERROR = 4'd10;

    reg [3:0] state, next_state;

    always @(*) begin
        case (state)
            IDLE:  next_state = in ? IDLE : B0;
            B0:    next_state = B1;
            B1:    next_state = B2;
            B2:    next_state = B3;
            B3:    next_state = B4;
            B4:    next_state = B5;
            B5:    next_state = B6;
            B6:    next_state = B7;
            B7:    next_state = STOP;
            STOP:  next_state = in ? IDLE : B0;
            ERROR: next_state = in ? IDLE : ERROR;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        done = (state == STOP) && in;
    end

endmodule