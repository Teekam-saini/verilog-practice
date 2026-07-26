// i used if else for this question bcs the case statment would be too long, and if else is better way to use for piorty encoder.
module top_module (
    input [3:0] in,
    output reg [1:0] pos  );
    
    always @(*) begin
        if (in[0])
            pos = 2'h0;
        else if(in[1])
            pos = 2'h1;
        else if(in[2])
            pos = 2'h2;
        else if(in[3])
            pos = 2'h3;
        else
            pos = 2'h0;
    end 
    
    

endmodule
