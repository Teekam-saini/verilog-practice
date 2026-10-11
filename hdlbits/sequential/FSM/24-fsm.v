module top_module (
    input [3:1] y,
    input w,
    output Y2
);
    
    parameter a = 3'b000,
              b = 3'b001,
              c = 3'b010, 
              d = 3'b011, 
              e = 3'b100, 
              f = 3'b101;
    
    reg [3:1] next;
    
    always @(*) begin
        case(y)
            a: next = w ? a : b;
            b: next = w ? d : c;
            c: next = w ? d : e;
            d: next = w ? a : f;
            e: next = w ? d : e;
            f: next = w ? d : c;
            default: next = a; 
        endcase
    end
    

    assign Y2 = next[2];

endmodule