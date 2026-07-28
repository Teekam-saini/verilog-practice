module top_module (
    input ring,
    input vibrate_mode,
    output reg ringer,       // Make sound
    output reg motor         // Vibrate
);
    always @(*) begin
        ringer = 1'b0; motor = 1'b0;
        if (ring) begin
            ringer = 1'b1;
            if(ring && vibrate_mode)begin
                motor = 1'b1;
                ringer = 1'b0;
            end          
         
        end
        else begin 
            ringer = 1'b0;
            motor = 1'b0;
        end
    end
    
                
    

endmodule

