module top_module(
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    always @(posedge clk) begin
        if (reset) begin
            ss <= 8'h00;
            mm <= 8'h00;
            hh <= 8'h12; // Resets to 12:00 AM
            pm <= 1'b0;  // 0 for AM
        end 
        else if (ena) begin
            // --- Seconds Counter (00 to 59) ---
            if (ss[3:0] == 4'd9) begin
                ss[3:0] <= 4'd0;
                if (ss[7:4] == 4'd5)
                    ss[7:4] <= 4'd0;
                else
                    ss[7:4] <= ss[7:4] + 4'd1;
            end 
            else begin
                ss[3:0] <= ss[3:0] + 4'd1;
            end

            // --- Minutes Counter ---
            if (ss == 8'h59) begin
                if (mm[3:0] == 4'd9) begin
                    mm[3:0] <= 4'd0;
                    if (mm[7:4] == 4'd5)
                        mm[7:4] <= 4'd0;
                    else
                        mm[7:4] <= mm[7:4] + 4'd1;
                end 
                else begin
                    mm[3:0] <= mm[3:0] + 4'd1;
                end

                // --- Hours Counter ---
                if (mm == 8'h59) begin
                    // Toggle AM/PM when hitting 11:59:59 -> 12:00:00
                    if (hh == 8'h11) begin
                        hh <= 8'h12;
                        pm <= ~pm; 
                    end 
                    else if (hh == 8'h12) begin
                        hh <= 8'h01;
                    end 
                    else if (hh[3:0] == 4'd9) begin
                        hh[3:0] <= 4'd0;
                        hh[7:4] <= hh[7:4] + 4'd1;
                    end 
                    else begin
                        hh[3:0] <= hh[3:0] + 4'd1;
                    end
                end
            end
        end
    end

endmodule