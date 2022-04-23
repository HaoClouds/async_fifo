module dual_port_mem#(
  parameter DATA_WIDTH = 16,
  parameter FIFO_DEPTH = 128,
  parameter ADDR_WIDTH  = $clog2(FIFO_DEPTH)
)(

  input  wire                    rst_n_i,
/**************write part***********************/ 
  input  wire                    clk_wr_i,

  //enable signals
  input  wire                    wr_en_i,
  input  wire                    wr_full_i,

  //write data
  input  wire  [DATA_WIDTH-1:0]  wr_data_i, 
  input  wire  [ADDR_WIDTH-1:0]  wr_addr_i, 

//**************read part***********************/
  input  wire                    clk_rd_i,

  //enable signals
  input  wire                    rd_en_i,
  input  wire                    rd_empty_i,

  //write data
  output reg   [DATA_WIDTH-1:0]  rd_data_o, 
  input  wire  [ADDR_WIDTH-1:0]  rd_addr_i 

);

reg [DATA_WIDTH-1:0] fifo_array [0:FIFO_DEPTH-1];
reg [ADDR_WIDTH:0] i;

/*******************READ OPERATION***************************/

always @(posedge clk_rd_i or negedge rst_n_i) begin
  if(!rst_n_i) begin
    rd_data_o <= {DATA_WIDTH{1'b0}};
  end
  else if(!rd_empty_i &&rd_en_i) begin
    rd_data_o <= fifo_array[rd_addr_i];
  end
end

/*******************WRITE OPERATION***************************/

always @(posedge clk_wr_i or negedge rst_n_i) begin
  if(!rst_n_i) begin
    for(i=0;i<FIFO_DEPTH;i=i+1) begin
      fifo_array[i] <= {DATA_WIDTH{1'b0}};
    end
  end
  else if(!wr_full_i &&wr_en_i) begin
    fifo_array[wr_addr_i] <= wr_data_i;
  end
end


endmodule
