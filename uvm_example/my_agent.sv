`ifndef MY_AGENT__SV
`define MY_AGENT__SV
`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "my_driver.sv"
`include "my_monitor.sv"
`include "my_transaction.sv"
`include "my_sequencer.sv"
// `include "my_sequence.sv"

class my_agent extends uvm_agent;

	my_driver drv;
	my_monitor mon;
	my_sequencer sqr;
	uvm_analysis_port #(my_transaction) ap;

	function new(string name, uvm_component parent);
	   	super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(is_active == UVM_ACTIVE) begin 
			sqr = my_sequencer::type_id::create("sqr", this);
			drv = my_driver::type_id::create("drv", this);
		end
		mon = my_monitor::type_id::create("mon", this);
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(is_active == UVM_ACTIVE) begin 
			drv.seq_item_port.connect(sqr.seq_item_export);
		end
		ap = mon.ap;
	endfunction : connect_phase

	`uvm_component_utils(my_agent)

endclass : my_agent

`endif

