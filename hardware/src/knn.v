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
    `REG_RE(clk, rst, 0, AxEN & KNN_ENABLE, Ax, KNN_DATA_IN)
    `REG_RE(clk, rst, 0, BxEN & KNN_ENABLE, Bx, KNN_DATA_IN)
    `REG_RE(clk, rst, 0, AyEN & KNN_ENABLE, Ay, KNN_DATA_IN)
    `REG_RE(clk, rst, 0, ByEN & KNN_ENABLE, By, KNN_DATA_IN)

    `REG_RE(clk, rst, 0, KNN_ENABLE, Curr_state, Next_state)
    `SIGNAL(Curr_state, 3)
    `SIGNAL(Next_state, 3)

    `SIGNAL2OUT(KNN_VALUE, DIST_OUT)

    always @ (posedge clk or Curr_state)
    begin
      AxEN = 1'b0;
      BxEN = 1'b0;
      AyEN = 1'b0;
      ByEN = 1'b0;

      case(Curr_state)
        3'd0: begin
          AxEN = 1'b1;
          Next_state = 3'd1;
        end
        3'd1: begin
          BxEN = 1'b1;
          Next_state = 3'd2;
        end
        3'd2: begin
          AyEN = 1'b1;
          Next_state = 3'd3;
        end
        3'd3: begin
          ByEN = 1'b1;
          Next_state = 3'd4;
        end
        default: begin
          Next_state = Curr_state;
        end
      endcase
    end

    dist_core dist1
      (
      .DIST_OUT(DIST_OUT),
      .Ax(Ax),
      .Bx(Bx),
      .Ay(Ay),
      .By(By)
      );


endmodule
