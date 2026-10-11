module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);
    parameter a =1'b0, b=1'b1;
    
    reg state , next;
    
    reg[1:0] count;
    reg[1:0] ones;
    
    always @(*) begin
        case(state)
            a : next = s ? b: a;
            b : next = b;
            default next=a;
        endcase
    end
    always @(posedge clk) begin
        if(reset)begin
            state <=a;
            count <= 1'b0;
            ones <= 1'b0;
            z <= 1'b0;
        end else begin
            state <=next;
            if(state == b)begin
                if(count==2'd2)begin
                    if((ones +w) == 2'd2)begin
                        z <=1'b1;
                    end
                    else
                        z <=1'b0;
                    
                    count <=1'b0;
                    ones <= 1'b0;
                end else begin
                    ones <= ones+w;
                    count <= count + 2'd1;
                    z <=1'b0;
                end
            end
            else begin
                count <= 1'b0;
                ones <= 1'b0;
                z <= 1'b0;
            end
        end
    end
                    
                                  
        
            
    

endmodule
