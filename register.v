module register (
                  input      clk, set_p, data, reset,
                  output reg data_reg
                 );

   initial data_reg = 1'b0;     // reset data_reg

   // At every clock, if set_p, set data_out as data
   always @(posedge clk)
     if (reset == 1'b0)
       data_reg <= 1'b0;        // reset data_reg
     else if (set_p == 1'b1)
       data_reg <= data;        // set data_reg
     else
       data_reg <= data_reg;    // stay unchanged
   
endmodule // register
