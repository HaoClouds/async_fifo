module general_syncer #(
  parameter FIRST_EDGE     = 0,
  parameter LAST_EDGE      = 0,
  parameter MID_STAGE_NUM  = 0,
  parameter DATA_WIDTH     = 1
)(
  input  wire                               clk_i,
  input  wire                               rst_n_i,
  input  wire  [DATA_WIDTH-1:0]             data_unsync_i,
  output reg   [DATA_WIDTH-1:0]             data_synced_o
);
  reg  [DATA_WIDTH-1:0]                     first_reg;
  reg  [DATA_WIDTH*MID_STAGE_NUM-1:0]       mid_reg;

  wire [DATA_WIDTH-1:0]                     mid_data_bus;

/************************** input layer *****************************/
generate 
  if(FIRST_EDGE == 0) begin
    always @(posedge clk_i or negedge rst_n_i) begin
      if(~rst_n_i) begin
        first_reg <= {DATA_WIDTH{1'b0}};
      end
      else begin
        first_reg <= data_unsync_i;
      end
    end
  end
  else begin
    always @(negedge clk_i or negedge rst_n_i) begin
      if(~rst_n_i) begin
        first_reg <= {DATA_WIDTH{1'b0}};
      end
      else begin
        first_reg <= data_unsync_i;
      end
    end
  end
endgenerate

/**************************middle layer**************************/
generate 
  if(MID_STAGE_NUM == 0) begin
    assign mid_data_bus = first_reg;
  end
  else if(MID_STAGE_NUM == 1) begin
    always @(posedge clk_i or negedge rst_n_i) begin
      if(~rst_n_i) begin
        mid_reg <= {DATA_WIDTH{1'b0}};
      end
      else begin
        mid_reg <= first_reg;
      end
    end
    assign mid_data_bus = mid_reg;
  end
  else begin
    always @(posedge clk_i or negedge rst_n_i) begin
      if(~rst_n_i) begin
        mid_reg <= {DATA_WIDTH*MID_STAGE_NUM{1'b0}};
      end
      else begin
        mid_reg <= {first_reg,mid_reg[DATA_WIDTH*MID_STAGE_NUM-1:DATA_WIDTH]};
      end
    end
    assign mid_data_bus = mid_reg[DATA_WIDTH-1:0];    
  end
endgenerate

/********************************last stage********************************/
generate
  if(LAST_EDGE == 0) begin
    always@(posedge clk_i or negedge rst_n_i) begin
      if(~rst_n_i) begin
        data_synced_o <= {DATA_WIDTH{1'b0}};
      end
      else begin
        data_synced_o <= mid_data_bus;
      end
    end
  end
  else begin
    always@(negedge clk_i or negedge rst_n_i) begin
      if(~rst_n_i) begin
        data_synced_o <= {DATA_WIDTH{1'b0}};
      end
      else begin
        data_synced_o <= mid_data_bus;
      end
    end
  end
endgenerate
endmodule
