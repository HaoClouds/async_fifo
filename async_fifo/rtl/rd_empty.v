module rd_empty #(
  parameter ADDR_WIDTH = 7
)(
  input  wire  [ADDR_WIDTH:0] wr_ptr_gray_i, 
  input  wire  [ADDR_WIDTH:0] rd_ptr_gray_i,

  output wire                 empty_o
);

assign empty_o = (wr_ptr_gray_i == rd_ptr_gray_i);

endmodule
