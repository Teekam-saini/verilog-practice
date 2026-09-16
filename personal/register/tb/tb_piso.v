module tb_piso;

    // ==============================
    // DUT signals
    // ==============================

    reg clk, en, areset, op, load;
    reg [7:0] pi;
    wire so;

    // ==============================
    // DUT
    // ==============================

    piso dut (
        .clk(clk),
        .en(en),
        .areset(areset),
        .op(op),
        .load(load),
        .pi(pi),
        .so(so)
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
        $dumpfile("sim/piso.vcd");
        $dumpvars(0, tb_piso);
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
        input exp_result;
        input [8*30-1:0] test_name;

        begin
            #1;

            if (so === exp_result) begin
                pass_count = pass_count + 1;

                $display(
                    "PASS: %0s | time=%0t | areset=%b | en=%b | load=%b | op=%b | pi=%h | so=%b",
                    test_name, $time, areset, en, load, op, pi, so
                );
            end
            else begin
                fail_count = fail_count + 1;

                $display(
                    "FAIL: %0s | time=%0t | areset=%b | en=%b | load=%b | op=%b | pi=%h | expected=%b | result=%b",
                    test_name, $time, areset, en, load, op, pi, exp_result, so
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
        op     = 0;
        load   = 0;
        pi     = 8'h00;

        // ==============================
        // TEST 1: RESET
        // ==============================

        areset = 1;
        #1;
        check(1'b0, "reset");
        #5;

        areset = 0;
        #5;

        // ==============================
        // TEST 2: PARALLEL LOAD A5
        // ==============================

        pi   = 8'hA5;
        load = 1;

        @(posedge clk);
        check(1'b1, "parallel load A5");

        load = 0;
        #5;

        // ==============================
        // TEST 3: LEFT SHIFT
        // ==============================

        en = 1;
        op = 0;

        @(posedge clk);
        check(1'b0, "left shift 1");
        #5;

        @(posedge clk);
        check(1'b1, "left shift 2");
        #5;

        @(posedge clk);
        check(1'b0, "left shift 3");
        #5;

        @(posedge clk);
        check(1'b0, "left shift 4");
        #5;

        // ==============================
        // TEST 4: ENABLE OFF / HOLD
        // ==============================

        en = 0;

        @(posedge clk);
        check(1'b0, "enable disabled");
        #5;

        // ==============================
        // TEST 5: LOAD NEW DATA
        // ==============================

        pi   = 8'h3C;
        load = 1;

        @(posedge clk);
        check(1'b0, "parallel load 3C");

        load = 0;
        #5;

        // ==============================
        // TEST 6: RIGHT SHIFT BY 0
        // ==============================

        en = 1;
        op = 1;

        @(posedge clk);
        check(1'b0, "right shift 0");
        #5;

        @(posedge clk);
        check(1'b0, "right shift 0");
        #5;

        @(posedge clk);
        check(1'b0, "right shift 0");
        #5;

        // ==============================
        // TEST 7: ENABLE OFF / HOLD
        // ==============================

        en = 0;

        @(posedge clk);
        check(1'b0, "right hold");
        #5;

        // ==============================
        // TEST 8: RESET AGAIN
        // ==============================

        areset = 1;
        #1;
        check(1'b0, "reset again");
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