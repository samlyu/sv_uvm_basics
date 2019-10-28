`ifndef MY_SEQUENCE__SV
`define MY_SEQUENCE__SV

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "my_transaction.sv"

class my_sequence extends uvm_sequence #(my_transaction);
	my_transaction m_trans;

	function new(string name = "my_sequence");
		super.new(name);   	
	endfunction : new

	virtual task body();
		if(starting_phase != null)
			starting_phase.raise_objection(this);
	   	repeat(4) begin 
	   		`uvm_do(m_trans)
	   	end
	   	#1000;
	   	if(starting_phase != null)
	   		starting_phase.drop_objection(this);
	endtask : body

	`uvm_object_utils(my_sequence)

endclass : my_sequence

`endif