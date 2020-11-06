`timescale 1ns/1ps
`include "iob_lib.vh"

module knn_core
  #(
    parameter DATA_W = 32
    )
   (
    `INPUT(KNN_ENABLE, 1),
    `INPUT(KNN_SAMPLE, 1),
    `OUTPUT(KNN_VALUE, 2*`DATA_W),
    `INPUT(clk, 1),
    `INPUT(rst, 1)
    );



endmodule
