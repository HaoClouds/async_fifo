module tb;

 parameter BUF_SIZE   = 128;
 parameter BUF_WIDTH  = 16;
 parameter CNT_WIDTH  = $clog2(BUF_SIZE);
 
 reg                         clk_wr;
 reg                         clk_rd;
 reg                         rst_n;
 
 reg                         wr_en;
 reg     [BUF_WIDTH-1:0]     wdata;

 reg                         rd_en;
 wire    [BUF_WIDTH-1:0]     rdata;

 wire                        full; 
 wire                        empty;

async_fifo #(
   .DATA_WIDTH(BUF_WIDTH),
   .FIFO_DEPTH(BUF_SIZE),
   .ADDR_WIDTH(CNT_WIDTH)
 ) async_fifo_i(
     .clk_wr_i (clk_wr),
     .clk_rd_i (clk_rd),
     .rst_n_i(rst_n),
     .wr_en_i(wr_en),
     .wr_data_i(wdata),
     .rd_en_i(rd_en),
     .rd_data_o(rdata),
     .wr_full_o(full),
     .rd_empty_o(empty)
 );
always #20 clk_wr= ~clk_wr;
always #10 clk_rd= ~clk_rd;

reg [BUF_WIDTH-1:0] tempdata = 0;
integer i =0;

 initial begin
   clk_wr = 0;
   clk_rd = 0;
   rst_n = 0;
   #15;
   rst_n = 1;
 end

 initial begin
   wr_en = 0;
   rd_en = 0;
   wdata = 0;
   #10;
   @(posedge rst_n);
   push(1);
   fork
     push(2);
     pop(tempdata);
   join
   push(10);
   push(20);
   push(30);
   push(40);
   push(50);
   push(60);
   push(70);
   push(80);
   push(90);
   push(100);
   push(110);
   push(120);
   push(130);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   push(140);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   pop(tempdata);
   push(5);
   pop(tempdata);
   push(10);
   push(20);
   push(30);
   push(40);
   push(50);
   push(60);
   push(70);
   push(80);
   push(90);
   push(100);
   push(110);
   push(120);
   push(130);
   push(140);
   push(150);
   push(160);
   push(170);
   push(180);
   push(190);
   repeat(120) begin
     i++;
     push(190+i*10);
   end
   repeat(130) begin
     pop(tempdata);
   end
   #3000;
   $finish;
 end

 task push(input [BUF_WIDTH-1:0]data);
   if(full) begin
     $display("----FIFO is full,connot push in %d!----",data);
   end
   else begin
     $display("----Push %d",data);
     wr_en = 1;
     wdata = data;
     @(posedge clk_wr);
     #5 wr_en = 0;
   end
 endtask

 task pop(output [BUF_WIDTH-1:0]data);
   if(empty) begin
     $display("----FIFO is empty,connot be read out %d!----",data);
   end
   else begin
     rd_en = 1;
     @(posedge clk_rd);
     #3 rd_en = 0;
     data = rdata;
     $display("%d is poped",data);
   end
 endtask

initial begin
  $fsdbDumpfile("tb.fsdb");
  $fsdbDumpvars(0,"tb");
  $fsdbDumpMDA(0,"tb");
end

endmodule
