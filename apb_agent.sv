class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent);
  apb_driver drv;
  uvm_sequencer#(apb_seq_item) sqr;
  function new(string name = "APB_AGT", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv = apb_driver::type_id::create("drv",this);
    sqr = uvm_sequencer#(apb_seq_item)::type_id::create("sqr",this);
  endfunction:build_phase
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
  
endclass
