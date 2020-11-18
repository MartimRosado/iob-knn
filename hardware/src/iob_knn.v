`timescale 1ns/1ps
`include "iob_lib.vh"
`include "interconnect.vh"
`include "iob_knn.vh"

module iob_knn
  #(
    parameter ADDR_W = `KNN_ADDR_W, //NODOC Address width
    parameter DATA_W = `DATA_W, //NODOC Data word width
    parameter LABEL = `LABEL,
    parameter WDATA_W = `KNN_WDATA_W //NODOC Data word width on writes
    )
   (
`include "cpu_nat_s_if.v"
`include "gen_if.v"
    );

//BLOCK Register File & Configuration, control and status registers accessible by the sofware
`include "KNNsw_reg.v"
`include "KNNsw_reg_gen.v"

    //combined hard/soft reset
   `SIGNAL(rst_int, 1)
   `COMB rst_int = rst | KNN_RESET;

   //write signal
   `SIGNAL(write, 1)
   `COMB write = | wstrb;

   //
   //BLOCK 64-bit time counter & Free-running 64-bit counter with enable and soft reset capabilities
   //
   `SIGNAL_OUT(KNN_VALUE, DATA_W)

   knn_core knn0
     (
      .A(KNN_A),
      .B(KNN_B),
      .label(KNN_LABEL),
      .Neighbour_info(),
      .clk(clk),
      .rst(rst_int),
      .valid(valid),
      .start(KNN_ENABLE)
      );


   //ready signal
   `SIGNAL(ready_int, 1)
   `REG_AR(clk, rst, 0, ready_int, valid)

   `SIGNAL2OUT(ready, ready_int)

   //rdata signal
   //`COMB begin
   //end

endmodule
