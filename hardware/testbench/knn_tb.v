`timescale 1ns/1ps
`include "iob_lib.vh"
`include "interconnect.vh"

module knn_tb;

   localparam PER=10;

   `CLOCK(clk, PER)
   `RESET(rst, 7, 10)

   `SIGNAL(KNN_ENABLE, 1)
   `SIGNAL(KNN_SAMPLE, 1)
   `SIGNAL_OUT(KNN_VALUE, `DATA_W)
   `SIGNAL(KNN_DATA_IN, `DATA_W)

   initial begin
`ifdef VCD
      $dumpfile("knn.vcd");
      $dumpvars();
`endif
      KNN_ENABLE = 0;
      KNN_SAMPLE = 0;

      @(posedge rst);
      @(negedge rst);
      @(posedge clk) #1 KNN_ENABLE = 1;
      @(posedge clk) #1 KNN_DATA_IN = 4;
      @(posedge clk) #1 KNN_DATA_IN = 3;
      @(posedge clk) #1 KNN_DATA_IN = 2;
      @(posedge clk) #1 KNN_DATA_IN = 1;

      $write("Ax = 4\nBx = 3\nAy = 2\nBy = 1\n");
      #(1000*PER) @(posedge clk) #1 KNN_SAMPLE = 1;
      @(posedge clk) #1 KNN_SAMPLE = 0;
      $write("Current time: %d; Square Distance %d\n", $time, KNN_VALUE);

      if( KNN_VALUE == 0)
        $display("Test passed");
      else
        $display("Test failed: expecting knn value 0 but got %d", KNN_VALUE);

      $finish;
   end

   //instantiate knn core
   knn_core knn0
     (
      .KNN_ENABLE(KNN_ENABLE),
      .KNN_SAMPLE(KNN_SAMPLE),
      .KNN_VALUE(KNN_VALUE),
      .KNN_DATA_IN(KNN_DATA_IN),
      .clk(clk),
      .rst(rst)
      );

endmodule
