module top_module(
    input clk,
    input [7:0] in,
    input reset,
    output reg [23:0] out_bytes,
    output reg done
);

    parameter IDLE = 2'b00, 
              B1   = 2'b01, 
              B2   = 2'b10, 
              B3   = 2'b11;
              
    reg [1:0] state, next_state;
    reg [23:0] temp_bytes;

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

    // Sequential state update with synchronous reset & shift register capture
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            temp_bytes <= 24'd0;
            out_bytes <= 24'd0;
        end else begin
            state <= next_state;
            case (next_state)
                IDLE: begin
                    if (in[3]) begin
                        temp_bytes[23:16] <= in;
                    end
                end
                B1: begin
                    temp_bytes[15:8] <= in;
                end
                B2: begin
                    temp_bytes[7:0] <= in;
                end
                B3: begin
                    out_bytes <= {temp_bytes[23:8], in};
                    if (in[3]) begin
                        temp_bytes[23:16] <= in;
                    end
                end
            endcase
        end
    end

    // Output logic for done flag
    always @(*) begin
        done = (state == B3);
    end

endmodule