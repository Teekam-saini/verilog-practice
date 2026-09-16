module tb_sipo;

    // ==============================
    // DUT signals
    // ==============================

    reg clk, en, areset, si;
    reg op;
    wire [7:0] q;

    // ==============================
    // DUT
    // ==============================

    sipo dut (
        .clk(clk),
        .en(en),
        .areset(areset),
        .si(si),
        .op(op),
        .q(q)
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
        $dumpfile("sim/sipo.vcd");
        $dumpvars(0, tb_sipo);
    end

    // ==============================
    // Clock
    // ==============================

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ==============================
    // Check task
    // ==============================

    task check;
        input [7:0] exp_result;
        input [8*30-1:0] test_name;

        begin
            #1;

            if (q === exp_result) begin
                pass_count = pass_count + 1;

                $display(
                    "PASS: %0s | time=%0t | areset=%b | en=%b | op=%b | si=%b | result=%b",
                    test_name, $time, areset, en, op, si, q
                );
            end
            else begin
                fail_count = fail_count + 1;

                $display(
                    "FAIL: %0s | time=%0t | areset=%b | en=%b | op=%b | si=%b | expected=%h | result=%b",
                    test_name, $time, areset, en, op, si, exp_result, q
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
        clk    = 0;
        en     = 0;
        areset = 0;
        si     = 0;
        op     = 0;

        // ==============================
        // TEST 1: RESET
        // ==============================

        areset = 1;
        #1;
        check(8'h0, "reset");
        #5;

        areset = 0;
        #5;

        // ==============================
        // TEST 2: LEFT SHIFT
        // ==============================

        en = 1;
        op = 0;

        si = 1;
        @(posedge clk);
        check(8'h01, "left shift 1");
        #5;

        si = 0;
        @(posedge clk);
        check(8'h02, "left shift 0");
        #5;

        si = 1;
        @(posedge clk);
        check(8'h05, "left shift 1");
        #5;

        si = 0;
        @(posedge clk);
        check(8'h0A, "left shift 0");
        #5;

        si = 1;
        @(posedge clk);
        check(8'h15, "left shift 1");
        #5;

        si = 0;
        @(posedge clk);
        check(8'h2A, "left shift 0");
        #5;

        si = 1;
        @(posedge clk);
        check(8'h55, "left shift 1");
        #5;

        si = 0;
        @(posedge clk);
        check(8'hAA, "left shift 0");
        #5;

        // ==============================
        // TEST 3: HOLD / ENABLE OFF
        // ==============================

        en = 0;
        si = 1;

        @(posedge clk);
        check(8'hAA, "hold");
        #5;

        // ==============================
        // TEST 4: RIGHT SHIFT
        // ==============================

        en = 1;
        op = 1;

        si = 0;
        @(posedge clk);
        check(8'h55, "right shift 0");
        #5;

        si = 1;
        @(posedge clk);
        check(8'hAA, "right shift 1");
        #5;

        si = 0;
        @(posedge clk);
        check(8'h55, "right shift 0");
        #5;

        si = 1;
        @(posedge clk);
        check(8'hAA, "right shift 1");
        #5;

        // ==============================
        // TEST 5: RESET AGAIN
        // ==============================

        areset = 1;
        #1;
        check(8'h0, "reset again");
        #5;

        areset = 0;
        #5;

        // ==============================
        // TEST 6: HOLD AFTER RESET
        // ==============================

        en = 0;
        si = 1;
        op = 0;

        @(posedge clk);
        check(8'h0, "hold after reset");
        #5;

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