module top_module(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out); //

    parameter A=0, B=1, C=2, D=3;
    
    always @(*) begin
        case(state)
            2'b00 : next_state = in ? B : A;
            2'b01 : next_state = in ? B : C;
            2'b10 : next_state = in ? D : A;
            2'b11 : next_state = in ? B : C;
            default : next_state = A;
        endcase
    end
    always @(*) begin
        case(state)
             2'b00 : out = 1'b0;
            2'b01 : out =1'b0;
            2'b10 : out = 1'b0;
            2'b11 : out = 1'b1;
            default : out = 1'b0;
            
        endcase
    end
            

            

    
endmodule
