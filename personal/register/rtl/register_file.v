    module register_file #(
        parameter width = 8
    )(
        input wire clk,areset,enable,
        input wire [4:0] raddr1,raddr2,waddr,
        input wire [width-1:0]  wdata,
        output wire [width-1:0] rdata1,rdata2
    );

    reg [width-1:0] r[0:31];
    always @(posedge clk or posedge areset) begin
        if (areset) begin
        r[0] <= {width{1'b0}};

        end
        else if (enable) begin
            if (waddr !=5'h0) begin
                r[waddr]<=wdata;                
            end
            
        end
        
    end
    assign rdata1 = r[raddr1];
    assign rdata2 = r[raddr2];
    
        
    endmodule
