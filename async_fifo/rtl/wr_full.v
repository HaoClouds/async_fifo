module wr_full #(
  parameter ADDR_WIDTH = 7
)(
  input  wire  [ADDR_WIDTH:0] wr_ptr_gray_i, 
  input  wire  [ADDR_WIDTH:0] rd_ptr_gray_i,

  output wire                 full_o 
);

assign full_o = (wr_ptr_gray_i == {~rd_ptr_gray_i[ADDR_WIDTH:ADDR_WIDTH-1],rd_ptr_gray_i[ADDR_WIDTH-2:0]});

endmodule
