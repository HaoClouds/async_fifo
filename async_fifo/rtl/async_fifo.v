module async_fifo#(
  parameter DATA_WIDTH = 16,
  parameter FIFO_DEPTH = 128,
  parameter ADDR_WIDTH  = $clog2(FIFO_DEPTH)
)(

  input  wire                    rst_n_i,
/**************write part***********************/ 
  input  wire                    clk_wr_i,
  input  wire                    wr_en_i,
  input  wire  [DATA_WIDTH-1:0]  wr_data_i, 

//**************read part***********************/
  input  wire                    clk_rd_i,
  input  wire                    rd_en_i,
  output reg   [DATA_WIDTH-1:0]  rd_data_o,

//flags
  output wire                    wr_full_o,
  output wire                    rd_empty_o
);
  wire [ADDR_WIDTH-1:0] wr_addr,rd_addr;
  wire [ADDR_WIDTH:0]   wr_ptr_bin,rd_ptr_bin;
  wire [ADDR_WIDTH:0]   wr_ptr_gray,rd_ptr_gray;
  wire [ADDR_WIDTH:0]   wr_ptr_gray_synced,rd_ptr_gray_synced;

dual_port_mem#(
       .FIFO_DEPTH( FIFO_DEPTH ),
       .DATA_WIDTH( DATA_WIDTH ),
       .ADDR_WIDTH( ADDR_WIDTH )
)dual_port_mem_i(
      .rst_n_i     ( rst_n_i     ),
      //wr IF
      .clk_wr_i    ( clk_wr_i    ),
      .wr_en_i     ( wr_en_i     ),
      .wr_full_i   ( wr_full_o   ),
      .wr_addr_i   ( wr_addr     ),
      .wr_data_i   ( wr_data_i   ),

      //rd IF
      .clk_rd_i     ( clk_rd_i   ),
      .rd_en_i      ( rd_en_i    ),
      .rd_empty_i   ( rd_empty_o ),
      .rd_addr_i    ( rd_addr    ),
      .rd_data_o    ( rd_data_o  )
);

//*************************read clock domain*********************//
wrap_addr_cnt #(
        .ADDR_WIDTH  ( ADDR_WIDTH  )
)wrap_addr_rd_i(
        .clk_i       ( clk_rd_i   ),
        .rst_n_i     ( rst_n_i    ),
        //flags
        .cnt_en_i    ( rd_en_i    ),
        .cnt_forbid_i( rd_empty_o ),

        //generate address
        .addr_o      ( rd_addr    ),
        .ptr_o       ( rd_ptr_bin )
);

bin2gray #(
       .DATA_WIDTH   ( ADDR_WIDTH+1  )
)bin2gray_rd_i(
       .bin_i        ( rd_ptr_bin    ),
       .gray_o       ( rd_ptr_gray   )
);

rd_empty #(
       .ADDR_WIDTH    ( ADDR_WIDTH    )
)rd_empty_i (
       .wr_ptr_gray_i ( wr_ptr_gray_synced ),
       .rd_ptr_gray_i ( rd_ptr_gray        ),

       .empty_o       ( rd_empty_o         )
);

general_syncer #(
       .FIRST_EDGE      (0),
       .LAST_EDGE       (0),
       .MID_STAGE_NUM   (0),
       .DATA_WIDTH      (ADDR_WIDTH+1)
)general_syncer_rd_i(
      .clk_i          ( clk_rd_i           ),
      .rst_n_i        ( rst_n_i            ),
      .data_unsync_i  ( wr_ptr_gray        ),
      .data_synced_o  ( wr_ptr_gray_synced )
);

//*************************write clock domain********************//\
wrap_addr_cnt #(
        .ADDR_WIDTH  ( ADDR_WIDTH  )
)wrap_addr_wr_i(
        .clk_i       ( clk_wr_i   ),
        .rst_n_i     ( rst_n_i    ),
        //flags
        .cnt_en_i    ( wr_en_i    ),
        .cnt_forbid_i( wr_full_o  ),

        //generate address
        .addr_o      ( wr_addr    ),
        .ptr_o       ( wr_ptr_bin )
);

bin2gray #(
       .DATA_WIDTH   ( ADDR_WIDTH+1  )
)bin2gray_wr_i(
       .bin_i        ( wr_ptr_bin    ),
       .gray_o       ( wr_ptr_gray   )
);

wr_full #(
       .ADDR_WIDTH    ( ADDR_WIDTH    )
)wr_full_i (
       .wr_ptr_gray_i ( wr_ptr_gray        ),
       .rd_ptr_gray_i ( rd_ptr_gray_synced ),

       .full_o        ( wr_full_o          )
);

general_syncer #(
       .FIRST_EDGE      (       0          ),
       .LAST_EDGE       (       0          ),
       .MID_STAGE_NUM   (       0          ),
       .DATA_WIDTH      ( ADDR_WIDTH+1     )
)general_syncer_wr_i(
      .clk_i          ( clk_wr_i           ),
      .rst_n_i        ( rst_n_i            ),
      .data_unsync_i  ( rd_ptr_gray        ),
      .data_synced_o  ( rd_ptr_gray_synced )
);


endmodule
