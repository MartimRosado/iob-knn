`timescale 1ns/1ps
`include "iob_lib.vh"

module knn_core
  #(
    parameter DATA_W = 32,
              LABEL = 8,
              N_Neighbour = 10
    )
   (
    `INPUT(A, `DATA_W),
    `INPUT(B, `DATA_W),
    `INPUT(label, `LABEL),
    `OUTPUT(Neighbour_info, (DATA_W+LABEL)*N_Neighbour),
    `INPUT(clk, 1),
    `INPUT(rst, 1),
    `INPUT(valid, 1),
    `INPUT(start, 1)
    );

    `SIGNAL_OUT(DIST_OUT, DATA_W)

    dist_core dist1
      (
      .DIST_OUT(DIST_OUT),
      .Ax(A[31:16]),
      .Bx(B[31:16]),
      .Ay(A[15:0]),
      .By(B[15:0])
      );

    list list0
      (
        .Neighbour_info(Neighbour_info),
        .Dist_candidate(DIST_OUT),
        .label_candidate(label),
        .valid(valid),
        .rst(rst),
        .start(start),
        .clk(clk)
        );

endmodule
