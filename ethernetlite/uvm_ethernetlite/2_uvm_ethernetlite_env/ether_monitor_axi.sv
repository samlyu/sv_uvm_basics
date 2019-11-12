`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_if_axi.sv"
`include "ether_transaction.sv"

class ether_monitor_axi extends uvm_monitor;

	`uvm_component_utils(ether_monitor_axi)
	virtual ether_if_axi vif;

	function new(string name = "ether_monitor_axi", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual ether_if_axi)::get(this, "", "vif", vif))
			`uvm_fatal("ether_monitor_axi", "virtual interface must be set in monitor!")
	endfunction : build_phase

	task main_phase(uvm_phase phase);
		ether_transaction tr;
		tr = new("tr");
		collect_one_pkt(tr);
	endtask : main_phase

	task collect_one_pkt(ether_transaction tr);
		`uvm_info("ether_monitor_axi", "start collecting one packet", UVM_LOW)
		`uvm_info("ether_monitor_axi", "end collecting one packet, print result:", UVM_LOW)
		tr.my_print();
	endtask : collect_one_pkt

endclass : ether_monitor_axi
