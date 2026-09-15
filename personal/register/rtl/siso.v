module siso (
    input wire clk , areset , en,
    input wire si,
    output wire  so,
    input wire op

);
    reg [7:0] q;

    always @(posedge clk or posedge areset) begin

        if (areset) begin
            q<=8'h0;

        
        end
        else if (en) begin
            case (op)
               1'b0 : q<= {q[6:0], si};
               1'b1 : q<= {si,q[7:1]};

                default: q<=8'h00;
            endcase
            
        end
        
    end

    assign so = op ? q[0] : q[7];



endmodule