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
    `INPUT(By, `DATA_W/2)
    );

    `SIGNAL_SIGNED(X_DIFF, `DATA_W/2)
    `SIGNAL_SIGNED(Y_DIFF, `DATA_W/2)
    `SIGNAL_SIGNED(X_SQR, `DATA_W)
    `SIGNAL_SIGNED(Y_SQR, `DATA_W)
    `SIGNAL_SIGNED(DIST_VALUE, `DATA_W)

    `COMB begin

    X_DIFF = Ax - Bx;
    X_SQR = X_DIFF * X_DIFF;
    Y_DIFF = Ay - By;
    Y_SQR = Y_DIFF * Y_DIFF;
    DIST_VALUE = X_SQR + Y_SQR;

    end

    `SIGNAL2OUT(DIST_OUT, DIST_VALUE)

endmodule
