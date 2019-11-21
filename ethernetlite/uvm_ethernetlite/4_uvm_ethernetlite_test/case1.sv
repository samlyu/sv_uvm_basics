`ifndef CASE1__SV
`define CASE1__SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_transaction.sv"
`include "ether_test.sv"

class case1_sequence extends uvm_sequence #(ether_transaction);

	`uvm_object_utils(case1_sequence)

	ether_transaction tr;

	function new(string name = "case1_sequence");
		super.new(name);
	endfunction : new

	virtual task body();
		
		if(starting_phase != null)
			starting_phase.raise_objection(this);

		repeat(10) begin 
			`uvm_do_with(tr, {tr.ether_type == 100;})
		end
		#1000;

		if(starting_phase != null)
			starting_phase.drop_objection(this);

	endtask : body

endclass : case1_sequence

class case1 extends ether_test;

	`uvm_component_utils(case1)

	function new(string name = "case1", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		
		super.build_phase(phase);

		uvm_config_db#(uvm_object_wrapper)::set(this, "env.i_agt.sqr.main_phase", "default_sequence", case1_sequence::type_id::get());

	endfunction : build_phase

endclass : case1

`endif
