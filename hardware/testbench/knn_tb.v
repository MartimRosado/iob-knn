`timescale 1ns/1ps
`include "iob_lib.vh"
`include "interconnect.vh"

module knn_tb;

   localparam PER=10;

   `CLOCK(clk, PER)
   `RESET(rst, 7, 10)

   `SIGNAL(KNN_ENABLE, 1)
   `SIGNAL(valid, 1)
   `SIGNAL_OUT(Neighbour_info, `LABEL*`N_Neighbour)
   `SIGNAL(A, `DATA_W)
   `SIGNAL(B, `DATA_W)
   `SIGNAL(label, `LABEL)

   initial begin
`ifdef VCD
      $dumpfile("knn.vcd");
      $dumpvars();
`endif

      @(negedge rst);
      @(posedge clk) #1 KNN_ENABLE = 0;
      valid = 1'b1;
      A = 32'b00000000000010100000000000001010;
      KNN_ENABLE = 1;
      B = 32'b00000000000010110000000000001011;
      label = 8'b1;
      $write("Ax = 10\nAy = 10\nBx = 11\nBy = 11\n");
      $write("Dist = 2\n");

      @(posedge clk) #1 KNN_ENABLE = 1;
      valid = 1'b1;
      B = 32'b00000000000011110000000000001111;
      label = 8'b10;
      $write("Ax = 10\nAy = 10\nBx = 15\nBy = 15\n");
      $write("Dist = 50\nLABEL = 2\n");

      @(posedge clk);
      valid = 1'b1;
      B = 32'b00000000000011000000000000001100;
      label = 8'b1;
      $write("Ax = 10\nAy = 10\nBx = 12\nBy = 12\n");
      $write("Dist = 8\n");

      @(posedge clk);
      valid = 1'b1;
      B = 32'b00000000000011000000000000001010;
      label = 8'b1;
      $write("Ax = 10\nAy = 10\nBx = 10\nBy = 12\n");
      $write("Dist = 4\n");


      @(posedge clk) #1 KNN_ENABLE = 0;

      if(Neighbour_info[`LABEL-1:0] == 1)
        $display("Test passed");
        else
          $display("Test failed: expecting knn value 1 but got %d", Neighbour_info[`DATA_W-1:`LABEL]);

      if(Neighbour_info[`LABEL-1+(`LABEL):(`LABEL)] == 1)
        $display("Test passed");
        else
          $display("Test failed: expecting knn value 1 but got %d", Neighbour_info[`LABEL-1+(`DATA_W+`LABEL):(`DATA_W+`LABEL)]);

      if(Neighbour_info[`LABEL-1+2*(`LABEL):2*(`LABEL)] == 1)
        $display("Test passed");
        else
          $display("Test failed: expecting knn value 1 but got %d", Neighbour_info[`DATA_W-1+2*(`DATA_W+`LABEL):`LABEL+2*(`DATA_W+`LABEL)]);

      if(Neighbour_info[`LABEL-1+3*(`LABEL):3*(`LABEL)] == 2)
        $display("Test passed");
        else
          $display("Test failed: expecting knn value 2 but got %d", Neighbour_info[`DATA_W-1+3*(`DATA_W+`LABEL):`LABEL+3*(`DATA_W+`LABEL)]);
      #(1000*PER) @(posedge clk) #1 valid = 0;

      /*if( KNN_VALUE == 1)
        $display("Test passed");
      else
        $display("Test failed: expecting knn value 1 but got %d", KNN_VALUE);*/
      //#(1000*PER) @(posedge clk) #1 KNN_SAMPLE = 1;

      $finish;
   end

   //instantiate knn core
   knn_core knn0
     (
     .A(A),
     .B(B),
     .label(label),
     .Neighbour_info(Neighbour_info),
     .clk(clk),
     .rst(rst),
     .valid(valid),
     .start(KNN_ENABLE)
      );

endmodule
