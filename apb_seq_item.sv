class apb_seq_item extends uvm_sequence_item;
  rand bit[7:0] apb_addr;
  rand bit[7:0] apb_wdata;
  rand bit wr_rd_n;
  rand bit transfer;
  
  constraint trans{transfer == 1'b1;}
  `uvm_object_utils(apb_seq_item);
  function new(string name = "apb_seq");
    super.new(name);
  endfunction
  
  
  
endclass 
