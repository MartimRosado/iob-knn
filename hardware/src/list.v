`timescale 1ns/1ps
`include "iob_lib.vh"

module list
   #(
    parameter DATA_W = 32,
              N_Neighbour = 10,
              LABEL = 8
    )
   (
    `OUTPUT(Neighbour_info, (DATA_W+LABEL)*N_Neighbour),
    `INPUT(Dist_candidate, `DATA_W),
    `INPUT(label_candidate, `LABEL),
    `INPUT(valid, 1),
    `INPUT(rst, 1),
    `INPUT(start, 1),
    `INPUT (clk, 1)
    );

    `SIGNAL(write_previous, N_Neighbour)
    `SIGNAL(write_L, N_Neighbour)
    `SIGNAL(Neighbour_info, (DATA_W+LABEL)*N_Neighbour)

    list_element list0
    (
     .Neighbour_info(Neighbour_info[(DATA_W+LABEL)-1:0]),
     .write_L(write_L[0]),
     .write_previous(write_previous[0]),
     .Neighbour_previous(Neighbour_info[(DATA_W+LABEL)-1:0]),
     .Dist_candidate(Dist_candidate),
     .label_candidate(label_candidate),
     .valid(valid),
     .rst(rst),
     .start(start),
     .clk(clk)
     );

    genvar i;

    generate
      for(i = 1; i < N_Neighbour; i = i + 1) begin
        list_element list
        (
         .Neighbour_info(Neighbour_info[(DATA_W+LABEL)*(i+1)-1:(DATA_W+LABEL)*i]),
         .write_L(write_L[i]),
         .write_previous(write_L[i-1]),
         .Neighbour_previous(Neighbour_info[(DATA_W+LABEL)*i-1:(DATA_W+LABEL)*(i-1)]),
         .Dist_candidate(Dist_candidate),
         .label_candidate(label_candidate),
         .valid(valid),
         .rst(rst),
         .start(start),
         .clk(clk)
         );
      end
    endgenerate

    assign write_previous[0] = 1'b0;

endmodule
