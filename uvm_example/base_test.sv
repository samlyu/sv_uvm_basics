`ifndef BASE_TEST__SV
`define BASE_TEST__SV
`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "uvm_macros.svh"

`include "my_env.sv"

class base_test extends uvm_test;

	my_env env;

	function new(string name = "base_test", uvm_component parent = null);
	   	super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = my_env::type_id::create("env", this);
		// uvm_config_db#(uvm_object_wrapper)::set(this, "env.i_agt.sqr.main_phase", "default_sequence", my_sequence::type_id::get());	   	
	endfunction : build_phase

	virtual function void report_phase(uvm_phase phase);
	   	uvm_report_server server;
	   	int err_num;
	   	super.report_phase(phase);

	   	server = get_report_server();
	   	err_num = server.get_severity_count(UVM_ERROR);

	   	if(err_num != 0) begin 
	   		$display("TEST CASE FAILED");
	   	end
	   	else begin 
	   		$display("TEST CASE PASSED");
	   	end
	endfunction : report_phase

	`uvm_component_utils(base_test)

endclass : base_test

`endif
