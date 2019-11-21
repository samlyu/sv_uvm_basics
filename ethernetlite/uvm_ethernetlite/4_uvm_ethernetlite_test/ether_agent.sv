`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_sequencer.sv"
`include "ether_driver.sv"
`include "ether_monitor_axi.sv"
`include "ether_monitor_phy.sv"
`include "ether_transaction.sv"

class ether_agent extends uvm_agent;

	`uvm_component_utils(ether_agent)

	ether_sequencer sqr;
	ether_driver drv;
	ether_monitor_axi mon_axi;
	ether_monitor_phy mon_phy;

	uvm_analysis_port #(ether_transaction) ap;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(is_active == UVM_ACTIVE) begin 
			sqr = ether_sequencer::type_id::create("sqr", this);
			drv = ether_driver::type_id::create("drv", this);
			mon_axi = ether_monitor_axi::type_id::create("mon_axi", this);
		end
		else begin 
			mon_phy = ether_monitor_phy::type_id::create("mon_phy", this);
		end
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(is_active == UVM_ACTIVE) begin 
			drv.seq_item_port.connect(sqr.seq_item_export);
			ap = mon_axi.ap;
		end
		else
			ap = mon_phy.ap;
	endfunction : connect_phase

endclass : ether_agent
