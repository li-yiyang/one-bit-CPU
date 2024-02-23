`timescale 1ns/1ns
  
module cpu_test ();
   parameter STEP = 10,
             LENGTH = 16;   
   
   // Inputs and Outputs
   wire      reset;   
   reg [3:0] memory;

   assign reset = 1;

   // Clock
   reg clk = 0;
   initial forever #(STEP) clk = ~clk;

   // Register
   wire reg_out, pc_out, a, p;
   register reg_a (.clk(clk), .set_p(1'b1), .data(reg_out), .reset(reset), .data_reg(a));
   register pc    (.clk(clk), .set_p(1'b1), .data(pc_out),  .reset(reset), .data_reg(p));

   // ALU
   wire [1:0] code;
   alu alu (.reg_in(a), .pc_in(p), .code(code), .reg_out(reg_out), .pc_out(pc_out));

   // Program
   assign code = p ?  memory[3:2] : memory[1:0];

   // Memory
   initial begin
      memory = 4'b0000;      
      forever #(LENGTH * STEP) memory = memory + 1;      
   end

   // Simulation Time
   initial #(LENGTH * 16 * STEP) $finish;

   // Simulation Dump
   initial begin
      $dumpfile("cpu_test.vcd");
      $dumpvars(0, clk, alu, reg_a, pc, memory);
   end
endmodule // cpu_test
