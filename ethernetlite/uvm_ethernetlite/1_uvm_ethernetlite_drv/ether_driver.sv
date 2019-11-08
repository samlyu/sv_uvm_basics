`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_if.sv"

class ether_driver extends uvm_driver;

	`uvm_component_utils(ether_driver)
	virtual ether_if vif;

	function new(string name = "ether_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	// AXI4 Lite
	task axi_aw(input [31:0] awaddr_in);
	begin 
		repeat (3) @(posedge vif.sys_clk);
			vif.awaddr = awaddr_in;
			vif.awvalid = 1'b1;
		@(negedge vif.awready)
			vif.awvalid = 1'b0;
	end
	endtask : axi_aw

	task axi_w(input [31:0] wdata_in);
	begin 
		repeat (3) @(posedge vif.sys_clk);
			vif.wdata = wdata_in;
			vif.wstrb = 4'hf;
			vif.wvalid = 1'b1;
		@(negedge vif.wready)
			vif.wvalid = 1'b0;
	end
	endtask : axi_w

	task axi_b();
	begin 
		repeat (3) @(posedge vif.sys_clk);
			vif.bready = 1'b1;
		@(negedge vif.bvalid)
			vif.bready = 1'b0;
	end
	endtask : axi_b

	task axi_ar(input [31:0] araddr_in);
	begin 
		repeat (3) @(posedge vif.sys_clk);
			vif.araddr = araddr_in;
			vif.arvalid = 1'b1;
		@(negedge vif.arready)
			vif.arvalid = 1'b0;
	end
	endtask : axi_ar

	task axi_r();
	begin 
		repeat (3) @(posedge vif.sys_clk);
			vif.rready = 1'b1;
		@(posedge vif.rvalid)
			$display("data received = %b", vif.rdata);
		@(negedge vif.rvalid)
			vif.rready = 1'b0;
	end
	endtask : axi_r

	task axi_init();
	begin 
		vif.awaddr = 32'h0;
		vif.awvalid = 1'b0;

		vif.wdata = 32'h0;
		vif.wstrb = 4'hf;
		vif.wvalid = 1'b0;

		vif.bready = 1'b0;

		vif.araddr = 32'h0;
		vif.arvalid = 1'b0;

		vif.rready = 1'b0;
	end
	endtask : axi_init

	task write_transaction(input [31:0] awaddr_in, wdata_in);
	fork
		axi_aw(awaddr_in);
		axi_w(wdata_in);
		axi_b();
	join
	endtask : write_transaction

	task read_transaction(input [31:0] araddr_in);
	fork
		axi_ar(araddr_in);
		axi_r();
	join
	endtask : read_transaction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("ether_driver", "driver build_phase called", UVM_LOW)
		if(!uvm_config_db#(virtual ether_if)::get(this, "", "vif", vif))
			`uvm_fatal("ether_driver", "virtual interface must be set in driver!")
	endfunction : build_phase

	virtual task main_phase(uvm_phase phase);
	begin 
		phase.raise_objection(this);
		`uvm_info("ether_driver", "driver main_phase called", UVM_LOW)

		axi_init();
		@(posedge vif.arstn)	
		write_transaction(32'h000107F8, 32'h80000000);
		write_transaction(32'h000107F4, 32'h00000018);
		write_transaction(32'h00010000, 32'hFFFFFFFF);
		write_transaction(32'h00010004, 32'h0000FFFF);
		write_transaction(32'h00010008, 32'hECAFE500);
		write_transaction(32'h0001000C, 32'h02010018);
		write_transaction(32'h00010010, 32'h06050403);
		write_transaction(32'h00010014, 32'h0A090807);
		write_transaction(32'h000107FC, 32'h00000019);
		`uvm_info("ether_driver", "write transactions done", UVM_LOW)

		while(vif.rdata[3] != 1'b1 || vif.rdata[0] != 1'b0)
		begin 
			read_transaction(32'h000107FC);
		end

		while(vif.rdata[0] != 1'b1)
		begin 
			read_transaction(32'h000117FC);
		end
		`uvm_info("ether_driver", "read transactions done", UVM_LOW)

		repeat (15) @(posedge vif.sys_clk);
		phase.drop_objection(this);
	end
	endtask : main_phase

endclass : ether_driver
