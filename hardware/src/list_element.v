`timescale 1ns/1ps
`include "iob_lib.vh"

module list_element
  #(
    parameter DATA_W = 32,
              LABEL = 8
    )
   (
    `OUTPUT(Neighbour_info, DATA_W+LABEL),
    `OUTPUT(write_L, 1),
    `INPUT(write_previous, 1),
    `INPUT(Neighbour_previous, DATA_W+LABEL),
    `INPUT(Dist_candidate, `DATA_W),
    `INPUT(label_candidate, `LABEL),
    `INPUT(valid, 1),
    `INPUT(rst, 1),
    `INPUT(start, 1),
    `INPUT(clk, 1)
    );

    `SIGNAL(Write_l, 1)
    `SIGNAL(Reg_out, 40)
    `SIGNAL(Reg_in, 40)

    `COMB begin

    if(write_previous || (Dist_candidate < Reg_out[DATA_W+LABEL-1:LABEL])) Write_l = 1'b1;
    else Write_l = 1'b0;

    if(write_previous == 1) Reg_in = Neighbour_previous;
    else Reg_in = {Dist_candidate , label_candidate};

    end

    `REG_ARE(clk, rst, '1, valid & start & Write_l, Reg_out, Reg_in)

    `SIGNAL2OUT(Neighbour_info, Reg_out)
    `SIGNAL2OUT(write_L, Write_l)

endmodule
