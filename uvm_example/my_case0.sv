`ifndef MY_CASE0__SV
`define MY_CASE0__SV
`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "base_test.sv"
`include "my_transaction.sv"

class case0_sequence extends uvm_sequence #(my_transaction);

	my_transaction m_trans;

	function new(string name = "case0_sequence");
	   	super.new(name);
	endfunction : new

	virtual task body();
	   	if(starting_phase != null)
	   		starting_phase.raise_objection(this);
	   	repeat(4) begin 
	   		`uvm_do(m_trans)
	   	end
	   	#100;
	   	if(starting_phase != null)
	   		starting_phase.drop_objection(this);
	endtask : body

	`uvm_object_utils(case0_sequence)

endclass : case0_sequence

class my_case0 extends base_test;

	function new(string name = "my_case0", uvm_component parent = null);
	   	super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
	   	super.build_phase(phase);
	   	uvm_config_db#(uvm_object_wrapper)::set(this, "env.i_agt.sqr.main_phase", "default_sequence", case0_sequence::type_id::get());
	endfunction : build_phase

	`uvm_component_utils(my_case0)

endclass : my_case0

`endif

