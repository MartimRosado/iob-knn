`timescale 1ns/1ps
`include "iob_lib.vh"

module dist_core
  #(
    parameter DATA_W = 16
    )
   (
    `OUTPUT(DIST_OUT, 2*`DATA_W),
    `INPUT(Ax, `DATA_W),
    `INPUT(Bx, `DATA_W),
    `INPUT(Ay, `DATA_W),
    `INPUT(By, `DATA_W)
    );

    `SIGNAL_SIGNED(X_DIFF, `DATA_W)
    `SIGNAL_SIGNED(Y_DIFF, `DATA_W)
    `SIGNAL_SIGNED(X_SQR, 2*`DATA_W)
    `SIGNAL_SIGNED(Y_SQR, 2*`DATA_W)
    `SIGNAL_SIGNED(DIST_VALUE, 2*`DATA_W)

    `COMB begin

    X_DIFF = Ax - Bx;
    X_SQR = X_DIFF * X_DIFF;
    Y_DIFF = Ay - By;
    Y_SQR = Y_DIFF * Y_DIFF;
    DIST_VALUE = X_SQR + Y_SQR;

    end

    `SIGNAL2OUT(DIST_OUT, DIST_VALUE)

endmodule
