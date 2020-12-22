`timescale 1ns/1ps
`include "iob_lib.vh"

module dist_core
  #(
    parameter DATA_W = 32
    )
   (
    `OUTPUT(DIST_OUT, `DATA_W),
    `INPUT(Ax, `DATA_W/2),
    `INPUT(Bx, `DATA_W/2),
    `INPUT(Ay, `DATA_W/2),
    `INPUT(By, `DATA_W/2),
    `INPUT(clk, 1),
    `INPUT(rst_acc, 1),
    `INPUT(en_acc, 1),
    `INPUT(en, 1),
    `INPUT(SELXY, 1) //x --> 0, y --> 1
    );

    `SIGNAL_SIGNED(OPA, `DATA_W/2)
    `SIGNAL_SIGNED(OPB, `DATA_W/2)
    `SIGNAL_SIGNED(SUB, `DATA_W/2)
    `SIGNAL_SIGNED(MULT, `DATA_W)
    `SIGNAL_SIGNED(MULT_P, `DATA_W)
    `SIGNAL_SIGNED(DIST_VALUE, `DATA_W)

    `ACC_RE(clk, rst_acc, 0, en_acc, DIST_VALUE, MULT)
    `REG_RE(clk, rst_acc, 0, en, MULT, MULT_P)

    `COMB begin

    if(SELXY == 0) begin
      OPA = Ax;
      OPB = Bx;
    end
    else begin
      OPA = Ay;
      OPB = By;
    end

    SUB = OPA - OPB;
    MULT_P = SUB * SUB;

    end

    `SIGNAL2OUT(DIST_OUT, DIST_VALUE)

endmodule
