class apb_test extends uvm_test;
  
  `uvm_component_utils(apb_test)
  apb_env env;
  virtual des_if vif;
  
  function new (string name="APB_TEST", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);
    if (!uvm_config_db#(virtual des_if)::get(this, "", "des_if", vif)) begin
      `uvm_fatal("TEST", "Virtual handle is not configured");
    end
	// Setting the interface in config db
    uvm_config_db#(virtual des_if)::set(this, "env.agt.*", "des_if", vif);
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_base_seq seq = apb_base_seq::type_id::create("seq");
    phase.raise_objection(this);
    seq.randomize();
    @(posedge vif.reset);
    //@(posedge vif.clk);
    seq.start(env.agt.sqr);
    phase.drop_objection(this);
  endtask
  
endclass
