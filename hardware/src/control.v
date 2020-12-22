`timescale 1ns/1ps
`include "iob_lib.vh"

module control
   (
    `OUTPUT(Data_Loaded, 1),
    `OUTPUT(en_acc, 1),
    `OUTPUT(en_reg, 1),
    `OUTPUT(rst_acc, 1),
    `OUTPUT(sel_xy, 1),
    `INPUT(valid, 1),
    `INPUT(clk, 1),
    `INPUT(enable, 1),
    `INPUT(rst, 1),
    `INPUT(wstrb, 1)
    );

    `SIGNAL(pc, 3)
    `SIGNAL(next_pc, 3)
    `SIGNAL(cont_out, 1)
    `SIGNAL(en_acc_int, 1)
    `SIGNAL(en_reg_int, 1)
    `SIGNAL(rst_acc_int, 1)
    `SIGNAL(sel_xy_int, 1)
    `REG_ARE(clk, rst, 0, enable, pc, next_pc)


    `SIGNAL2OUT(Data_Loaded, cont_out)
    `SIGNAL2OUT(en_acc, en_acc_int)
    `SIGNAL2OUT(en_reg, en_reg_int)
    `SIGNAL2OUT(rst_acc, rst_acc_int)
    `SIGNAL2OUT(sel_xy, sel_xy_int)

    `COMB begin

    next_pc = pc;
    cont_out = 1'b0;
    en_acc_int = 1'b0;
    en_reg_int = 1'b0;
    rst_acc_int = 1'b0;
    sel_xy_int = 1'bX;

    case(pc)
      0: begin
        if(valid && wstrb) next_pc = pc + 1'b1;
      end

      1: begin
        if(valid && wstrb) begin
         next_pc = pc + 1'b1;
         rst_acc_int = 1'b1;
        end
      end

      2: begin
        next_pc = pc + 1'b1;
        sel_xy_int = 1'b0;
        en_reg_int = 1'b1;
      end

      3: begin
        next_pc = pc + 1'b1;
        sel_xy_int = 1'b1;
        en_reg_int = 1'b1;
        en_acc_int = 1'b1;
      end

      4: begin
        next_pc = pc + 1'b1;
        en_acc_int = 1'b1;
      end

      5: begin
        next_pc = 1'b0;
        cont_out = 1'b1;
      end

      default: begin
        next_pc = 1'b0;
        cont_out = 1'b0;
      end

    endcase

    end

endmodule
