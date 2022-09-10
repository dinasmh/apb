package apb_pkg;
`include "uvm_macros.svh"

import uvm_pkg::*;

	`include "apb_seq_item.sv"
	`include "apb_base_seq.sv"
	`include "apb_driver.sv"
	`include "apb_agent.sv"
	`include "apb_env.sv"
	`include "apb_test.sv"
endpackage

`include "uvm_macros.svh"

import uvm_pkg::*;
import apb_pkg::*;
`include "des_if.sv"

module top ();
  
  logic		clk;
  logic		reset;
  
  initial clk = 1'b0;
  always #5 clk = ~clk;
  
  initial begin
    reset = 1'b1;
    @(posedge clk);
    reset = 1'b0;
    @(posedge clk);
    reset = 1'b1;
  end
  
  
  
  apb_master dut (.PRESETn (reset),
                  .PCLK    (clk),
                  .Wr_RdN  (apb_if.wr_rd_n),
                 .transfer(apb_if.transfer),
        
                  .addr (apb_if.apb_addr),
                 .wr_data (apb_if.apb_wdata)
                 );
  // Physical interface
  des_if apb_if (clk, reset);
  
  initial begin
    // Set the interface handle
    uvm_config_db#(virtual des_if)::set(null, "*", "des_if", apb_if);
    run_test ("apb_test");
    repeat(50)@(posedge clk);
    $finish();
  end
  
  initial begin
    $dumpfile ("test.vcd");
    $dumpvars ();
  end
  
endmodule
