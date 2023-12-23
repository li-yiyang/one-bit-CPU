module cpu (
             input       clock,  // clock is built clock
             input       reset,  // reset is reset button
             input [3:0] memory, // memory is 4 bit switches
             output clk_led, reg_led, pc_led
            );
   
   // Clock
   wire clk;
   slower_clk #(.SLOW_RATE(20_000_000)) slower_clk (.clk(clock), .slow_clk(clk));   

   // Register
   wire reg_out, pc_out, a, p;
   register reg_a (.clk(clk), .set_p(1), .data(reg_out), .reset(reset), .data_reg(a));
   register pc    (.clk(clk), .set_p(1), .data(pc_out),  .reset(reset), .data_reg(p));

   // ALU
   wire [1:0] code;
   alu alu (.reg_in(a), .pc_in(p), .code(code), .reg_out(reg_out), .pc_out(pc_out));

   // Program
   assign code = p ?
                 memory[3:2] :
                 memory[1:0];

   // Display
   assign clk_led = clk;
   assign reg_led = a;
   assign pc_led  = p;

endmodule : cpu
