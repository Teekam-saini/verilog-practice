// -----------------------------------------------------------------------------
// Verilog Overview
// -----------------------------------------------------------------------------
//
// A digital design project generally consists of two parts:
//
// 1. Design (RTL)
//    - The hardware module being implemented.
//
// 2. Testbench
//    - A separate module used to verify that the design works correctly.
//
// In the early HDLBits problems, we only write the design module.
// HDLBits already provides the testbench and automatically checks our solution.
//
// Tip:
// You can think of a 'wire' as a physical connection between hardware components.
// It carries signals from one part of the circuit to another, similar to how a
// wire connects electronic components on a PCB.
//
// Problem: wire4
// -----------------------------------------------------------------------------

module top_module(
    input  wire a, b, c,
    output wire w, x, y, z
);

    assign w = a;
    assign x = b;
    assign y = b;
    assign z = c;

endmodule