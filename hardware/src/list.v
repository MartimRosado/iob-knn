`timescale 1ns/1ps
`include "iob_lib.vh"

module list
   #(
    parameter DATA_W = 32,
    parameter N_Neighbour = 10,
    parameter LABEL = 8
    )
   (
    `OUTPUT(Neighbour_info_out, LABEL*N_Neighbour),
    `INPUT(Dist_candidate, DATA_W),
    `INPUT(label_candidate, LABEL),
    `INPUT(valid, 1),
    `INPUT(rst, 1),
    `INPUT(start, 1),
    `INPUT (clk, 1)
    );

    `SIGNAL(write_L, N_Neighbour)
    `SIGNAL(Neighbour_info, (DATA_W+LABEL)*N_Neighbour)
    `SIGNAL(Neighbour_info_LABEL, LABEL*N_Neighbour)

    `SIGNAL2OUT(Neighbour_info_out, Neighbour_info_LABEL)

    genvar i;

    generate
      for (i = N_Neighbour; i > 0; i = i-1) begin
       assign Neighbour_info_LABEL[(i*LABEL)-1:((i-1)*LABEL)] = Neighbour_info[(i*(DATA_W+LABEL))-DATA_W-1:(i-1)*(DATA_W+LABEL)];
      end
    endgenerate

    list_element0 #(.DATA_W(DATA_W), .LABEL(LABEL)) list0
    (
     .Neighbour_info(Neighbour_info[(DATA_W+LABEL)-1:0]),
     .write_L(write_L[0]),
     .Dist_candidate(Dist_candidate),
     .label_candidate(label_candidate),
     .valid(valid),
     .rst(rst),
     .start(start),
     .clk(clk)
     );

    generate
      for(i = 1; i < N_Neighbour; i = i + 1) begin
        list_element #(.DATA_W(DATA_W), .LABEL(LABEL)) list
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

endmodule
