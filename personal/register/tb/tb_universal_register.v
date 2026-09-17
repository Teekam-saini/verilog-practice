module tb_universal_register;

    reg clk, en, areset, sil, sir;
    reg [1:0] sel;
    reg [7:0] pi;

    wire [7:0] po;
    wire sol, sor;

    universal_register dut (
        .clk(clk),
        .en(en),
        .areset(areset),
        .sil(sil),
        .sir(sir),
        .sel(sel),
        .pi(pi),
        .po(po),
        .sol(sol),
        .sor(sor)
    );

    integer pass_count;
    integer fail_count;

    initial begin
        $dumpfile("sim/universal_register.vcd");
        $dumpvars(0, tb_universal_register);
    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task check;
        input [7:0] exp_po;
        input exp_sol;
        input exp_sor;
        input [8*30-1:0] test_name;

        begin
            #1;

            if ((po === exp_po) &&
                (sol === exp_sol) &&
                (sor === exp_sor)) begin

                pass_count = pass_count + 1;

                $display(
                    "PASS: %0s | time=%0t | areset=%b | en=%b | sel=%b | sil=%b | sir=%b | pi=%0d | po=%0d | sol=%b | sor=%b",
                    test_name, $time, areset, en, sel,
                    sil, sir, pi, po, sol, sor
                );
            end

            else begin

                fail_count = fail_count + 1;

                $display(
                    "FAIL: %0s | time=%0t | areset=%b | en=%b | sel=%b | sil=%b | sir=%b | pi=%0d | expected_po=%0d | result_po=%0d | expected_sol=%b | result_sol=%b | expected_sor=%b | result_sor=%b",
                    test_name, $time, areset, en, sel,
                    sil, sir, pi,
                    exp_po, po,
                    exp_sol, sol,
                    exp_sor, sor
                );
            end
        end
    endtask

    initial begin
        pass_count = 0;
        fail_count = 0;

        clk    = 0;
        en     = 0;
        areset = 0;
        sil    = 0;
        sir    = 0;
        sel    = 2'b00;
        pi     = 0;

        // ==============================
        // RESET
        // ==============================

        areset = 1;
        #1;
        check(0, 0, 0, "reset");
        #5;

        areset = 0;
        #5;

        // ==============================
        // PARALLEL LOAD 165
        // ==============================

        en  = 1;
        sel = 2'b11;
        pi  = 165;

        @(posedge clk);
        check(165, 1, 1, "parallel load 165");
        #5;

        // ==============================
        // HOLD
        // ==============================

        sel = 2'b00;
        pi  = 255;

        @(posedge clk);
        check(165, 1, 1, "hold 165");
        #5;

        // ==============================
        // LEFT SHIFT
        // ==============================

        sel = 2'b01;
        sil = 1;

        @(posedge clk);
        check(75, 0, 1, "left shift 1");
        #5;

        sil = 0;

        @(posedge clk);
        check(150, 1, 0, "left shift 2");
        #5;

        // ==============================
        // RIGHT SHIFT
        // ==============================

        sel = 2'b10;
        sir = 1;

        @(posedge clk);
        check(203, 1, 1, "right shift 1");
        #5;

        sir = 0;

        @(posedge clk);
        check(101, 0, 1, "right shift 2");
        #5;

        // ==============================
        // ENABLE DISABLED
        // ==============================

        en  = 0;
        sel = 2'b11;
        pi  = 60;

        @(posedge clk);
        check(101, 0, 1, "enable disabled");
        #5;

        // ==============================
        // PARALLEL LOAD 60
        // ==============================

        en  = 1;
        sel = 2'b11;
        pi  = 60;

        @(posedge clk);
        check(60, 0, 0, "parallel load 60");
        #5;

        // ==============================
        // LEFT SHIFT 60
        // ==============================

        sel = 2'b01;
        sil = 1;

        @(posedge clk);
        check(121, 0, 1, "left shift 60");
        #5;

        // ==============================
        // RIGHT SHIFT 121
        // ==============================

        sel = 2'b10;
        sir = 1;

        @(posedge clk);
        check(188, 1, 0, "right shift 121");
        #5;

        // ==============================
        // RESET AGAIN
        // ==============================

        areset = 1;
        #1;
        check(0, 0, 0, "reset again");
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