`ifndef ETHER_SEQUENCER__SV
`define ETHER_SEQUENCER__SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_transaction.sv"

class ether_sequencer extends uvm_sequencer #(ether_transaction);

	`uvm_component_utils(ether_sequencer)
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

endclass : ether_sequencer

`endif
