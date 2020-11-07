`timescale 1ns/1ps
`include "iob_lib.vh"

module knn_core
  #(
    parameter DATA_W = 16
    )
   (
    `INPUT(KNN_ENABLE, 1),
    `INPUT(KNN_SAMPLE, 1),
    `OUTPUT(KNN_VALUE, `DATA_W),
    `INPUT(KNN_DATA_IN, `DATA_W),
    `INPUT(clk, 1),
    `INPUT(rst, 1)
    );

    `SIGNAL(DIST_OUT, `DATA_W)
    `SIGNAL(Ax, `DATA_W)
    `SIGNAL(Bx, `DATA_W)
    `SIGNAL(Ay, `DATA_W)
    `SIGNAL(By, `DATA_W)
    `SIGNAL(AxEN, 1)
    `SIGNAL(BxEN, 1)
    `SIGNAL(AyEN, 1)
    `SIGNAL(ByEN, 1)
    //Fazer and dos enables com o enable geral
    `REG_E(clk, AxEN, Ax, KNN_DATA_IN)
    `REG_E(clk, BxEN, Bx, KNN_DATA_IN)
    `REG_E(clk, AyEN, Ay, KNN_DATA_IN)
    `REG_E(clk, ByEN, By, KNN_DATA_IN)

    `REG_RE(clk, rst, 0, KNN_ENABLE, Curr_state, Next_state)
    `SIGNAL(Curr_state, 3)
    `SIGNAL(Next_state, 3)

    `SIGNAL2OUT(KNN_VALUE, DIST_OUT)

    always @ (posedge clk, Curr_state)
    begin
      AxEN = 0;
      BxEN = 0;
      AyEN = 0;
      ByEN = 0;

      Next_state = Curr_state + 1;

      if(Curr_state == 0) AxEN = 1'b1;
      else if(Curr_state == 1) BxEN = 1'b1;
      else if(Curr_state == 2) AyEN = 1'b1;
      else if(Curr_state == 3) ByEN = 1'b1;
      else Next_state = Curr_state;
    end

    dist_core dist1
      (
      .DIST_OUT(DIST_OUT),
      .Ax(KNN_DATA_IN), //por os Ax, Bx, Ay, By que saem dos registos
      .Bx(KNN_DATA_IN),
      .Ay(KNN_DATA_IN),
      .By(KNN_DATA_IN)
      );


endmodule
