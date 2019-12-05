`ifndef MY_ENV__SV
`define MY_ENV__SV
`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "my_driver.sv"
`include "my_monitor.sv"
`include "my_agent.sv"
`include "my_model.sv"
`include "my_scoreboard.sv"
// `include "my_sequence.sv"

class my_env extends uvm_env;

	my_agent i_agt;
	my_agent o_agt;
	my_model mdl;
	my_scoreboard scb;

	uvm_tlm_analysis_fifo #(my_transaction) agt_mdl_fifo;
	uvm_tlm_analysis_fifo #(my_transaction) agt_scb_fifo;
	uvm_tlm_analysis_fifo #(my_transaction) mdl_scb_fifo;

	function new(string name = "my_env", uvm_component parent);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		i_agt = my_agent::type_id::create("i_agt", this);
		o_agt = my_agent::type_id::create("o_agt", this);
		i_agt.is_active = UVM_ACTIVE;
		o_agt.is_active = UVM_PASSIVE;
		mdl = my_model::type_id::create("mdl", this);
		scb = my_scoreboard::type_id::create("scb", this);
		agt_mdl_fifo = new("agt_mdl_fifo", this);
		agt_scb_fifo = new("agt_scb_fifo", this);
		mdl_scb_fifo = new("mdl_scb_fifo", this);
		// uvm_config_db#(uvm_object_wrapper)::set(this, "i_agt.sqr.main_phase", "default_sequence", my_sequence::type_id::get());
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		i_agt.ap.connect(agt_mdl_fifo.analysis_export);
		mdl.port.connect(agt_mdl_fifo.blocking_get_export);
		mdl.ap.connect(mdl_scb_fifo.analysis_export);
		scb.exp_port.connect(mdl_scb_fifo.blocking_get_export);
		o_agt.ap.connect(agt_scb_fifo.analysis_export);
		scb.act_port.connect(agt_scb_fifo.blocking_get_export);
	endfunction : connect_phase

	// virtual task main_phase(uvm_phase phase);
	//    	my_sequence seq;
	//    	phase.raise_objection(this);
	//    	seq = my_sequence::type_id::create("seq");
	//    	seq.start(i_agt.sqr);
	//    	phase.drop_objection(this);
	// endtask : main_phase

	`uvm_component_utils(my_env)

endclass : my_env

`endif

