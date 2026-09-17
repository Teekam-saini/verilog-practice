module tb_load_register;

    // ==============================
    // DUT signals
    // ==============================

    reg clk, areset, en;
    reg [1:0] load;
    reg [7:0] pi, q;
    wire [7:0] po;

    // ==============================
    // DUT
    // ==============================

    load_register dut (
        .clk(clk),
        .areset(areset),
        .en(en),
        .load(load),
        .pi(pi),
        .q(q),
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
        $dumpfile("sim/load_register.vcd");
        $dumpvars(0, tb_load_register);
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
                    "PASS: %0s | time=%0t | areset=%b | en=%b | load=%b | pi=%h | q=%h | po=%h",
                    test_name, $time, areset, en, load, pi, q, po
                );
            end
            else begin
                fail_count = fail_count + 1;

                $display(
                    "FAIL: %0s | time=%0t | areset=%b | en=%b | load=%b | pi=%h | q=%h | expected=%h | result=%h",
                    test_name, $time, areset, en, load, pi, q, exp_result, po
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
        load   = 2'b00;
        pi     = 8'h00;
        q      = 8'h00;

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
        // TEST 2: LOAD pi
        // load = 01
        // ==============================

        en   = 1;
        load = 2'b01;
        pi   = 8'hA5;

        @(posedge clk);
        check(8'hA5, "load pi A5");
        #5;

        // ==============================
        // TEST 3: HOLD
        // load = 00
        // ==============================

        load = 2'b00;
        pi   = 8'hFF;

        @(posedge clk);
        check(8'hA5, "hold A5");
        #5;

        // ==============================
        // TEST 4: SHIFT LEFT
        // load = 10
        // ==============================

        load = 2'b10;

        @(posedge clk);
        check(8'h4A, "shift left 1");
        #5;

        @(posedge clk);
        check(8'h94, "shift left 2");
        #5;

        @(posedge clk);
        check(8'h28, "shift left 3");
        #5;

        // ==============================
        // TEST 5: LOAD q
        // load = 11
        // ==============================

        load = 2'b11;
        q    = 8'h3C;

        @(posedge clk);
        check(8'h3C, "load q 3C");
        #5;

        // ==============================
        // TEST 6: ENABLE OFF
        // ==============================

        en   = 0;
        load = 2'b01;
        pi   = 8'h55;

        @(posedge clk);
        check(8'h3C, "enable disabled");
        #5;

        // ==============================
        // TEST 7: ENABLE ON + LOAD
        // ==============================

        en   = 1;
        load = 2'b01;
        pi   = 8'hAA;

        @(posedge clk);
        check(8'hAA, "load pi AA");
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