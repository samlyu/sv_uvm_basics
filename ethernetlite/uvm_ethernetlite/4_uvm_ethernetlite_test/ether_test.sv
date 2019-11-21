`ifndef ETHER_TEST__SV
`define ETHER_TEST__SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_env.sv"

class ether_test extends uvm_test;

	`uvm_component_utils(ether_test)

	ether_env env;

	function new(string name = "ether_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = ether_env::type_id::create("env", this);
		// uvm_config_db#(uvm_object_wrapper)::set(this, "env.i_agt.sqr.main_phase", "default_sequence", ether_sequence::type_id::get());
	endfunction : build_phase

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction : end_of_elaboration_phase

	virtual function void report_phase(uvm_phase phase);

		uvm_report_server server;
		int error_num;
		
		super.report_phase(phase);

		server = get_report_server();
		error_num = server.get_severity_count(UVM_ERROR);

		if(error_num != 0)
			`uvm_fatal("ether_test", "TEST CASE FAILED")
		else
			`uvm_info("ether_test", "TEST CASE PASSED", UVM_LOW)

	endfunction : report_phase

endclass : ether_test

`endif
