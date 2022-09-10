class apb_env extends uvm_env;
  `uvm_component_utils(apb_env);
  apb_agent agt;
  function new(string name = "APB_ENV", uvm_component parent);
    super.new(name,parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    agt = apb_agent::type_id::create("agt",this);
  endfunction
endclass
