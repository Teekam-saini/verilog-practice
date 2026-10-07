module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding parameters
    parameter IDLE   = 3'b000;
    parameter RECEIVE = 3'b001;
    parameter CHECK  = 3'b010;
    parameter DONE   = 3'b011;
    parameter WAIT   = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] data_reg;

    // FSM State Transition Logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = in ? IDLE : RECEIVE;
            end
            RECEIVE: begin
                next_state = (bit_count == 3'd7) ? CHECK : RECEIVE;
            end
            CHECK: begin
                next_state = in ? DONE : WAIT;
            end
            DONE: begin
                next_state = in ? IDLE : RECEIVE;
            end
            WAIT: begin
                next_state = in ? IDLE : WAIT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential State Update & Datapath Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            
            // Default outputs per cycle
            done <= 1'b0;

            case (next_state)
                IDLE: begin
                    bit_count <= 3'd0;
                end
                RECEIVE: begin
                    if (state == IDLE)
                        bit_count <= 3'd0;
                    else
                        bit_count <= bit_count + 3'd1;
                    
                    // Shift in data bits LSB first
                    data_reg <= {in, data_reg[7:1]};
                end
                CHECK: begin
                    // Evaluate stop bit
                end
                DONE: begin
                    done <= 1'b1;
                    out_byte <= data_reg;
                    bit_count <= 3'd0;
                end
                WAIT: begin
                    bit_count <= 3'd0;
                end
            endcase
        end
    end

endmodule