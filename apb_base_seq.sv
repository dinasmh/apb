class apb_base_seq extends uvm_sequence #(apb_seq_item);
  `uvm_object_utils(apb_base_seq);
  rand bit[3:0]count;
  virtual des_if vif;
  constraint cnt {count==4'd10;/* {[5:10]};*/}
  function new(string name = "apb_base_seq");
    super.new(name);
  endfunction
  virtual task body;
    `uvm_info(get_type_name(),"Running apb_base_seq",UVM_LOW);
    for(int i=0;i<count;i++)begin
      apb_seq_item apb_item = apb_seq_item::type_id::create("APB_ITEM");
      start_item(apb_item);
      //We will test for read commands from the master to the slave
      //So we can see the effect of the waits shown in PREADY signal
      #25ns
      assert(apb_item.randomize()with{apb_item.wr_rd_n == 1'b0;})
        else
          `uvm_fatal(get_type_name(),"Randomization of APB item failed");
      $display("%0d",apb_item.apb_addr);
      
      finish_item(apb_item);
    end
  endtask:body
endclass
