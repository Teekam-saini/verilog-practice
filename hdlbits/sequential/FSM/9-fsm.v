module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
); 
    reg [2:0] state, next_state;
    
    parameter A  = 3'b000,
              B  = 3'b001,
              B1 = 3'b010,
              C  = 3'b011,
              C1 = 3'b100,
              D  = 3'b101;
    
    always @(*) begin
        case (state) 
            A:  next_state = s[1] ? B : A;
            B:  next_state = s[1] ? (s[2] ? C : B) : A;
            B1: next_state = s[1] ? (s[2] ? C : B1) : A;
            C:  next_state = s[2] ? (s[3] ? D : C) : B1;
            C1: next_state = s[2] ? (s[3] ? D : C1) : B1;
            D:  next_state = s[3] ? D : C1;
            default: next_state = A;
        endcase
    end
    
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end
    
    always @(*) begin
        case (state)
            A:  {fr3, fr2, fr1, dfr} = 4'b1111;
            B:  {fr3, fr2, fr1, dfr} = 4'b0110;
            B1: {fr3, fr2, fr1, dfr} = 4'b0111;
            C:  {fr3, fr2, fr1, dfr} = 4'b0010;
            C1: {fr3, fr2, fr1, dfr} = 4'b0011;
            D:  {fr3, fr2, fr1, dfr} = 4'b0000;
            default: {fr3, fr2, fr1, dfr} = 4'b1111;
        endcase
    end

endmodule