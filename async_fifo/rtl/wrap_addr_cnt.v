module wrap_addr_cnt #(
  parameter ADDR_WIDTH = 7
)(
  // clk and reset
  input  wire                  clk_i,
  input  wire                  rst_n_i,  //low active,asychronous

  input  wire                  cnt_en_i,
  input  wire                  cnt_forbid_i,

  //generate address
  output wire [ADDR_WIDTH-1:0] addr_o,
  output reg  [ADDR_WIDTH:0]   ptr_o
);

always @(posedge clk_i or negedge rst_n_i) begin
  if(~rst_n_i) begin
    ptr_o <= {(ADDR_WIDTH+1){1'b0}};
  end
  else if(cnt_en_i && !cnt_forbid_i) begin
    ptr_o <= ptr_o + 1'b1;
  end
end

assign addr_o = ptr_o[ADDR_WIDTH-1:0];
endmodule
