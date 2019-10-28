`ifndef MY_DRIVER__SV
`define MY_DRIVER__SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "my_transaction.sv"
`include "my_sequence.sv"

class my_driver extends uvm_driver #(my_transaction);

	virtual my_if vif;
	`uvm_component_utils(my_driver)

	function new(string name = "my_driver", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("my_driver", "new driver is called", UVM_LOW);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("my_driver", "build_phase is called", UVM_LOW);
		if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
			`uvm_fatal("my_driver", "virtual interface must be set for vif!")    
	endfunction : build_phase

	task main_phase(uvm_phase phase);
		// my_transaction tr;
		// phase.raise_objection(this);
		vif.data <= 8'b0;
		vif.valid <= 1'b0;
		while(!vif.rst_n)
			@(posedge vif.clk);
		while(1) begin 
			// req = new("req");
			// assert(req.randomize() with {pload.size == 200;});
			// drive_one_pkt(req);
			seq_item_port.get_next_item(req);
			drive_one_pkt(req);
			seq_item_port.item_done();
		end
		// repeat(5) @(posedge vif.clk);
		// phase.drop_objection(this);
	endtask : main_phase

	task drive_one_pkt(my_transaction tr);
		byte unsigned	data_q[];
		int	data_size;

		data_size = tr.pack_bytes(data_q) / 8;
		`uvm_info("my_driver", "begin to drive one pkt", UVM_LOW);
		repeat(3) @(posedge vif.clk);
		for(int i=0;i<data_size;i++) begin 
			@(posedge vif.clk);
			vif.valid <= 1'b1;
			vif.data <= data_q[i];
		end

		@(posedge vif.clk);
		vif.valid <= 1'b0;
		`uvm_info("my_driver", "end driving one pkt", UVM_LOW);
	endtask : drive_one_pkt

endclass : my_driver

`endif
