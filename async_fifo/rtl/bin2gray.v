module bin2gray#(
  parameter   DATA_WIDTH = 4
)(
  input  wire   [DATA_WIDTH-1:0]  bin_i,
  output wire   [DATA_WIDTH-1:0]  gray_o
);
  assign gray_o = {bin_i >> 1} ^ bin_i;
endmodule
