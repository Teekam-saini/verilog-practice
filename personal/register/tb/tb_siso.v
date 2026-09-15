module tb_siso;

    

    // ==============================
    // DUT signals
    // ==============================

    reg si , clk, areset,en;

    reg op;
    wire so;

    // ==============================
    // DUT
    // ==============================

    siso dut (
        .si(si), .clk(clk), .areset(areset), . en(en), .so(so) , .op(op)
    );

    // ==============================
    // Test counters
    // ==============================

    integer pass_count;
    integer fail_count;

    // ==============================
    // Waveform
    // ==============================

    initial begin
        $dumpfile("sim/siso.vcd");
        $dumpvars(0, tb_siso);
    end

    initial begin
        clk=0;
        forever #5 clk=~clk;
    end
    // ==============================
    // Check task
    // ==============================

    task check;
        input  exp_result;
        input [8*30-1:0] test_name;

        begin
            #1;

            if (so === exp_result) begin
                pass_count = pass_count + 1;

                $display(
                    "PASS: %0s  | clk=%0t |op=%b | reset =%b | si=%b | en=%b | q=%b",
                    test_name, $time , op , areset , si, en, so
                );
            end
            else begin
                fail_count = fail_count + 1;

                $display(
                    "fail: %0s | clk=%0t |op=%b | reset=%b | si=%b | en=%b | q=%b",
                    test_name, $time , op ,areset , si, en, 
                    exp_result, so
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
        si=0; areset=0; en=0; op=0;

        // Test cases here
        areset=1;

        #5; check(1'b0, "reset");
        areset=0;
        #1;
        en=1; op=0;
        si=1;
        @(posedge clk);
        check(1'b0,"shift left by 1"); #5;
        si=0;
        @(posedge clk);
        check(1'b0,"shift left by 1"); #5;
        si=1;
        @(posedge clk);
        check(1'b0,"shift left by 1"); #5;
        si=0;
        @(posedge clk);
        check(1'b0,"shift left by 0"); #5;
        si=1;
        @(posedge clk);
        check(1'b0,"shift left by 1"); #5;
        si=0;
        @(posedge clk);
        check(1'b0,"shift left by 0"); #5;
        si=1;
        @(posedge clk);
        check(1'b0,"shift left by 1"); #5;
        si=0;
        @(posedge clk);
        check(1'b1,"shift left by 0"); #5;

        en=0; si=1;
        @(posedge clk);
        check(1'b1,"enabled disabled");#5;

        en=1; op=1;
        si=0;
        @(posedge clk);
        check(1'b1,"shift right by 0");#5;

        si=0;
        @(posedge clk);
        check(1'b0,"shift right by 0");#5;
        si=0;
        @(posedge clk);
        check(1'b1,"shift right by 0");#5;
        si=0;
        @(posedge clk);
        check(1'b0,"shift right by 0");#5;
        si=0;
        @(posedge clk);
        check(1'b1,"shift right by 0");#5;
        si=0;
        @(posedge clk);
        check(1'b0,"shift right by 0");#5;
        si=0;
        @(posedge clk);
        check(1'b1,"shift right by 0");#5;
        si=0;
        @(posedge clk);
        check(1'b0,"shift right by 0");#5;

        en=1; si=1;
        @(posedge clk);
        check(1'b0,"enabled disabled");
        



        

        

        // ==============================
        // TEST SUMMARY
        // ==============================

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