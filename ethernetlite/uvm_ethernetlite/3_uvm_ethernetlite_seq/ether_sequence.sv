`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_transaction.sv"

class ether_sequence extends uvm_sequence #(ether_transaction);

	`uvm_object_utils(ether_sequence)

	ether_transaction tr;

	function new(string name = "ether_sequence");
		super.new(name);
	endfunction : new

	virtual task body();
	
		if(starting_phase != null)
			starting_phase.raise_objection(this);

		repeat(5) begin 
			`uvm_do(tr)
		end
		#1000;

		if(starting_phase != null)
			starting_phase.drop_objection(this);

	endtask : body

endclass : ether_sequence
