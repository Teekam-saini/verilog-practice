module top_module( 
    input [2:0] in,
    output reg [1:0] out );
    
    integer i;
    
    always @(*) begin 
        out =0;
        for(i=0;i<3;i++)
            out  = out + in[i];
    end
        
    

endmodule
