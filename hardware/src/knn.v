`timescale 1ns/1ps
`include "iob_lib.vh"

module knn_core
  #(
    parameter DATA_W = 32,
    parameter LABEL = 8,
    parameter N_Neighbour = 10
    )
   (
    `INPUT(A, DATA_W),
    `INPUT(B, DATA_W),
    `INPUT(label, LABEL),
    `OUTPUT(Neighbour_info, LABEL*N_Neighbour),
    `INPUT(clk, 1),
    `INPUT(rst, 1),
    `INPUT(valid, 1),
    `INPUT(start, 1),
    `INPUT(en_acc, 1),
    `INPUT(en_reg, 1),
    `INPUT(rst_acc, 1),
    `INPUT(sel_xy, 1)
    );

    `SIGNAL_OUT(DIST_OUT, DATA_W)

    dist_core #(.DATA_W(DATA_W)) dist1
      (
      .DIST_OUT(DIST_OUT),
      .Ax(A[31:16]),
      .Bx(B[31:16]),
      .Ay(A[15:0]),
      .By(B[15:0]),
      .clk(clk),
      .rst_acc(rst_acc),
      .en_acc(en_acc),
      .en(en_reg),
      .SELXY(sel_xy)
      );

    list #(.DATA_W(DATA_W), .N_Neighbour(N_Neighbour), .LABEL(LABEL)) list0
      (
        .Neighbour_info_out(Neighbour_info),
        .Dist_candidate(DIST_OUT),
        .label_candidate(label),
        .valid(valid),
        .rst(rst),
        .start(start),
        .clk(clk)
        );

endmodule
