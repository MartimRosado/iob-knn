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
    `OUTPUT(Neighbour_info, `LABEL*`N_Neighbour),
    `INPUT(clk, 1),
    `INPUT(rst, 1),
    `INPUT(valid, 1),
    `INPUT(start, 1),
    `INPUT(wstrb, 1)
    );

    `SIGNAL_OUT(DIST_OUT, `DATA_W)
    `SIGNAL(valid_control, 1)

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
        .Neighbour_info_out(Neighbour_info),
        .Dist_candidate(DIST_OUT),
        .label_candidate(label),
        .valid(valid_control),
        .rst(rst),
        .start(start),
        .clk(clk)
        );

    control FSM
       (
        .Data_Loaded(valid_control),
        .valid(valid),
        .clk(clk),
        .enable(start),
        .rst(rst),
        .wstrb(wstrb)
       );

endmodule
