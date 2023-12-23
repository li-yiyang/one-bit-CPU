module slower_clk (
                    input      clk,
                    output reg slow_clk
                   );

   parameter SLOW_RATE = 1_000_000,
             COUNTER_SIZE = $clog2(SLOW_RATE) - 1;

   reg [COUNTER_SIZE:0] counter;

   initial slow_clk = 1'b0;   
   
   always @(posedge clk)
     if (counter == SLOW_RATE) begin
        counter <= 0;
        slow_clk <= ~slow_clk;        
     end else
       counter <= counter + 1;   

endmodule : slower_clk
