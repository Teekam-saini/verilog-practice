// synthesis verilog_input_version verilog_2001
module top_module (
    input [7:0] in,
    output reg [2:0] pos );
    
    always @(*) begin
        casez (in[7:0])
            7'bzzzzzzz1 : pos = 2'h0;
            7'bzzzzzz1z : pos = 2'h1;
            7'bzzzzz1zz : pos = 2'h2;
            7'bzzzz1zzz : pos = 2'h3;
            7'bzzz1zzzz : pos = 2'h4;
            7'bzz1zzzzz : pos = 2'h5;
            7'bz1zzzzzz : pos = 2'h6;
            7'b1zzzzzzz : pos = 2'h7;
        endcase
    end

            

endmodule
