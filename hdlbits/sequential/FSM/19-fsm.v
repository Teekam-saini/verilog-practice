module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output reg [7:0] out_byte,
    output reg done
);

    // State encoding parameters
    parameter IDLE    = 3'b000;
    parameter RECEIVE = 3'b001;
    parameter CHECK   = 3'b010;
    parameter DONE    = 3'b011;
    parameter WAIT    = 3'b100;

    reg [2:0] state, next_state;
    reg [3:0] bit_count;   // Needs to count up to 9 bits (8 data + 1 parity)
    reg [7:0] data_reg;

    // Parity checking signals
    reg parity_reset;
    wire odd;
    
    // Instantiate the provided parity module
    parity u_parity (
        .clk(clk),
        .reset(parity_reset),
        .in(in),
        .odd(odd)
    );

    // FSM State Transition Logic
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = in ? IDLE : RECEIVE;
            end
            RECEIVE: begin
                // Count 9 bits total: 8 data bits (0 to 7) + 1 parity bit (8)
                next_state = (bit_count == 4'd8) ? CHECK : RECEIVE;
            end
            CHECK: begin
                // Check stop bit (in == 1) and whether odd parity passed (odd == 1)
                if (in && odd)
                    next_state = DONE;
                else
                    next_state = WAIT;
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
            bit_count <= 4'd0;
            data_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
            parity_reset <= 1'b1;
        end else begin
            state <= next_state;
            
            // Default outputs per cycle
            done <= 1'b0;
            parity_reset <= 1'b0;

            case (next_state)
                IDLE: begin
                    bit_count <= 4'd0;
                    parity_reset <= 1'b1; // Reset parity counter in IDLE
                end
                RECEIVE: begin
                    if (state == IDLE) begin
                        bit_count <= 4'd0;
                        parity_reset <= 1'b1;
                    end else begin
                        bit_count <= bit_count + 4'd1;
                        parity_reset <= 1'b0;
                    end
                    
                    // Only shift the first 8 bits into data_reg (the 9th bit is parity)
                    if (bit_count < 4'd8) begin
                        data_reg <= {in, data_reg[7:1]};
                    end
                end
                CHECK: begin
                    // Evaluation happens in state transition
                end
                DONE: begin
                    done <= 1'b1;
                    out_byte <= data_reg;
                    bit_count <= 4'd0;
                    parity_reset <= 1'b1;
                end
                WAIT: begin
                    bit_count <= 4'd0;
                    parity_reset <= 1'b1;
                end
            endcase
        end
    end

endmodule