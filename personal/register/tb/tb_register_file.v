module tb_register_file;

    parameter width = 8;

    // ==============================
    // DUT signals
    // ==============================

    reg clk, areset, enable;
    reg [4:0] raddr1, raddr2, waddr;
    reg [width-1:0] wdata;
    wire [width-1:0] rdata1, rdata2;

    // ==============================
    // DUT
    // ==============================

    register_file #(
        .width(width)
    ) dut (
        .clk(clk),
        .areset(areset),
        .enable(enable),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr(waddr),
        .wdata(wdata),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // ==============================
    // Clock
    // ==============================

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ==============================
    // Test counters
    // ==============================

    integer pass_count;
    integer fail_count;

    // ==============================
    // Waveform
    // ==============================

    initial begin
        $dumpfile("sim/register_file.vcd");
        $dumpvars(0, tb_register_file);
    end

    // ==============================
    // Check task
    // ==============================

    task check;
        input [width-1:0] exp_rdata1;
        input [width-1:0] exp_rdata2;
        input [8*30-1:0] test_name;

        begin
            #1;

            if ((rdata1 === exp_rdata1) &&
                (rdata2 === exp_rdata2)) begin

                pass_count = pass_count + 1;

                $display(
                    "PASS: %0s | raddr1=%0d | raddr2=%0d | rdata1=%0d | rdata2=%0d",
                    test_name,
                    raddr1,
                    raddr2,
                    rdata1,
                    rdata2
                );
            end
            else begin

                fail_count = fail_count + 1;

                $display(
                    "FAIL: %0s | raddr1=%0d | raddr2=%0d | Expected=(%0d,%0d) | Got=(%0d,%0d)",
                    test_name,
                    raddr1,
                    raddr2,
                    exp_rdata1,
                    exp_rdata2,
                    rdata1,
                    rdata2
                );
            end
        end
    endtask

    // ==============================
    // Test cases
    // ==============================

    initial begin

        pass_count = 0;
        fail_count = 0;

        // Initial values
        areset = 1;
        enable = 0;

        raddr1 = 0;
        raddr2 = 0;

        waddr = 0;
        wdata = 0;

        

        #10;

        areset = 0;

        check(8'd0, 8'd0, "R0 after reset");


        

        enable = 1;
        waddr = 5;
        wdata = 8'd55;

        @(posedge clk);
        #1;

        raddr1 = 5;
        raddr2 = 5;

        check(8'd55, 8'd55, "Write and read R5");


        

        waddr = 10;
        wdata = 8'd100;

        @(posedge clk);
        #1;

        raddr1 = 10;
        raddr2 = 10;

        check(8'd100, 8'd100, "Write and read R10");


        

        raddr1 = 5;
        raddr2 = 10;

        check(8'd55, 8'd100, "Dual port read");


        
        enable = 0;

        waddr = 5;
        wdata = 8'd200;

        @(posedge clk);
        #1;

        raddr1 = 5;
        raddr2 = 10;

        check(8'd55, 8'd100, "enable disabled");


        
        enable = 1;

        waddr = 0;
        wdata = 8'd255;

        @(posedge clk);
        #1;

        raddr1 = 0;
        raddr2 = 0;

        check(8'd0, 8'd0, "R0 write blocked");


        
        raddr1 = 5;
        raddr2 = 10;

        check(8'd55, 8'd100, "Registers retained");


        waddr = 1;
        wdata = 8'd99;
        @(posedge clk);
        #1;

        raddr1 = 1;
        raddr2 = 3;

        check(8'd99,8'hxx,"unkown value");

        waddr = 3;
        wdata = 8'd69;
        @(posedge clk);
        #1;

        raddr1 = 1;
        raddr2 = 3;

        check(8'd99 , 8'd69 ,"dual ports");



        $display("");
        $display("==============================");
        $display("       TEST SUMMARY");
        $display("==============================");
        $display("Passed : %0d", pass_count);
        $display("Failed : %0d", fail_count);
        $display("Total  : %0d", pass_count + fail_count);
        $display("==============================");

        $finish;
    end

endmodule
