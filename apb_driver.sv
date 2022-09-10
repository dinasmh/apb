class apb_driver extends uvm_driver #(apb_seq_item);
  `uvm_component_utils(apb_driver);
  function new(string name = "apb_driver", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual des_if vif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual des_if)::get(this,"","des_if",vif))
      `uvm_fatal(get_type_name(),"Could not configure vif");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      apb_seq_item apb_item;
      `uvm_info(get_type_name(), "Wait for item from abp_sqr", UVM_LOW);
      seq_item_port.get_next_item(apb_item);
      drive_item(apb_item);
      seq_item_port.item_done();
    end
  endtask
  
  virtual task drive_item(apb_seq_item apb_item);
    @(vif.cb);
    vif.cb.apb_addr<=apb_item.apb_addr;
    vif.cb.apb_wdata<=apb_item.apb_wdata;
    vif.cb.wr_rd_n<=apb_item.wr_rd_n;
    vif.cb.transfer<=apb_item.transfer;
  endtask
  
endclass
