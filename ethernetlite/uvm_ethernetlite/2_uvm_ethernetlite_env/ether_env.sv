`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_driver.sv"
`include "ether_monitor_axi.sv"

class ether_env extends uvm_env;

	`uvm_component_utils(ether_env)
	ether_driver drv;
	ether_monitor_axi mon_axi;

	function new(string name = "ether_env", uvm_component parent);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		drv = ether_driver::type_id::create("drv", this);
		mon_axi = ether_monitor_axi::type_id::create("mon_axi", this);
	endfunction : build_phase

endclass : ether_env
