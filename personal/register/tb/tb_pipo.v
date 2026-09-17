module tb_pipo;

  

    reg clk, areset, en;
    reg [7:0] pi;
    wire [7:0] po;

   

    pipo dut (
        .clk(clk),
        .areset(areset),
        .en(en),
        .pi(pi),
        .po(po)
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
        $dumpfile("sim/pipo.vcd");
        $dumpvars(0, tb_pipo);
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

            if (po === exp_result) begin
                pass_count = pass_count + 1;

                $display(
                    "PASS: %0s | time=%0t | areset=%b | en=%b | pi=%h | po=%h",
                    test_name, $time, areset, en, pi, po
                );
            end
            else begin
                fail_count = fail_count + 1;

                $display(
                    "FAIL: %0s | time=%0t | areset=%b | en=%b | pi=%h | expected=%h | result=%h",
                    test_name, $time, areset, en, pi, exp_result, po
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
        areset = 0;
        en     = 0;
        pi     = 8'h00;

        // ==============================
        // TEST 1: RESET
        // ==============================

        areset = 1;
        #1;
        check(8'h00, "reset");
        #5;

        areset = 0;
        #5;

        // ==============================
        // TEST 2: LOAD A5
        // ==============================

        pi = 8'hA5;
        en = 1;

        @(posedge clk);
        check(8'hA5, "parallel load A5");
        #5;

        // ==============================
        // TEST 3: LOAD 3C
        // ==============================

        pi = 8'h3C;

        @(posedge clk);
        check(8'h3C, "parallel load 3C");
        #5;

        // ==============================
        // TEST 4: ENABLE OFF / HOLD
        // ==============================

        en = 0;
        pi = 8'hF0;

        @(posedge clk);
        check(8'h3C, "enable disabled");
        #5;

        // ==============================
        // TEST 5: LOAD 55
        // ==============================

        en = 1;
        pi = 8'h55;

        @(posedge clk);
        check(8'h55, "parallel load 55");
        #5;

        // ==============================
        // TEST 6: LOAD AA
        // ==============================

        pi = 8'hAA;

        @(posedge clk);
        check(8'hAA, "parallel load AA");
        #5;

        // ==============================
        // TEST 7: ENABLE OFF / HOLD
        // ==============================

        en = 0;
        pi = 8'hFF;

        @(posedge clk);
        check(8'hAA, "hold AA");
        #5;

        // ==============================
        // TEST 8: RESET AGAIN
        // ==============================

        areset = 1;
        #1;
        check(8'h00, "reset again");
        #5;

        areset = 0;
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