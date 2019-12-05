`ifndef MY_SEQUENCER__SV
`define MY_SEQUENCER__SV
`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "my_transaction.sv"

class my_sequencer extends uvm_sequencer #(my_transaction);
	
	function new(string name, uvm_component parent);
	   	super.new(name, parent);
	endfunction : new

	`uvm_component_utils(my_sequencer)

endclass : my_sequencer

`endif
