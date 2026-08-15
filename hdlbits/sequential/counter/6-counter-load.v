module top_module (
    input clk,
    input reset,
    input enable,
    output reg [3:0] Q,
    output reg c_enable,
    output reg c_load,
    output reg [3:0] c_d
);

    count4 the_counter (
        .clk(clk),
        .enable(c_enable),
        .load(c_load),
        .d(c_d),
        .Q(Q)
    );

    always @(*) begin
        c_enable = 1'b0;
        c_load   = 1'b0;
        c_d      = 4'd0;

        if (reset) begin
            c_load = 1'b1;
            c_d    = 4'd1;
        end
        else if (enable) begin
            if (Q == 4'd12) begin
                c_load = 1'b1;
                c_d    = 4'd1;
            end
            else begin
                c_enable = 1'b1;
            end
        end
    end

endmodule