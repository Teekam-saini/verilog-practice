module top_module (
    input clk,
    input resetn, // active-low synchronous reset
    input [3:1] r, // request
    output reg [3:1] g // grant
);

    // State encoding parameters
    parameter A  = 2'b00; // IDLE state
    parameter G1 = 2'b01; // Grant device 1
    parameter G2 = 2'b10; // Grant device 2
    parameter G3 = 2'b11; // Grant device 3

    reg [1:0] state, next_state;

    // 1. State Table (Combinational Next-State Logic)
    always @(*) begin
        case (state)
            A: begin
                if (r[1]) 
                    next_state = G1;
                else if (r[2]) 
                    next_state = G2;
                else if (r[3]) 
                    next_state = G3;
                else 
                    next_state = A;
            end
            
            G1: begin
                if (r[1]) 
                    next_state = G1;
                else 
                    next_state = A;
            end
            
            G2: begin
                if (r[2]) 
                    next_state = G2;
                else 
                    next_state = A;
            end
            
            G3: begin
                if (r[3]) 
                    next_state = G3;
                else 
                    next_state = A;
            end
            
            default: next_state = A;
        endcase
    end

    // 2. State Flip-Flops (Sequential Logic with Active-Low Synchronous Reset)
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // 3. Output Logic (Combinational Grant generation)
    always @(*) begin
        g = 3'b000;
        case (state)
            G1: g[1] = 1'b1;
            G2: g[2] = 1'b1;
            G3: g[3] = 1'b1;
            default: g = 3'b000;
        endcase
    end

endmodule