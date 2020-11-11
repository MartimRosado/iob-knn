`timescale 1ns/1ps
`include "iob_lib.vh"

module knn_core
  #(
    parameter DATA_W = 32
    )
   (
    `INPUT(A, `DATA_W),
    `INPUT(B, `DATA_W),
    `OUTPUT(KNN_VALUE, `DATA_W),
    `INPUT(clk, 1),
    `INPUT(rst, 1)
    );

    `SIGNAL(DIST_OUT, `DATA_W)

    `SIGNAL2OUT(KNN_VALUE, DIST_OUT)

    dist_core dist1
      (
      .DIST_OUT(DIST_OUT),
      .Ax(A[31:16]),
      .Bx(B[31:16]),
      .Ay(A[15:0]),
      .By(B[15:0])
      );


endmodule