interface des_if (
  input		logic		clk,
  input		logic		reset
);
  logic [7:0]	apb_addr;
  logic			transfer;
  logic [7:0]	apb_wdata;
  logic         wr_rd_n;
  
  
  clocking cb @(posedge clk);
    inout 		apb_addr;
    inout		transfer;
  	inout	    apb_wdata;
    inout       wr_rd_n;
  endclocking
endinterface
