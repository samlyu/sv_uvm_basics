`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_if.sv"
`include "ether_transaction.sv"

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
		ether_transaction tr;
		phase.raise_objection(this);
		`uvm_info("ether_driver", "driver main_phase called", UVM_LOW)

		tr = new("tr");
		assert(tr.randomize() with {
			pload.size() == ether_type; 
			dmac == 48'hFFFF_FFFF_FFFF; // broadcast
			smac == 48'h0000_5E00_FACE; // default
			}
		);
		drive_one_pkt(tr);

		repeat (15) @(posedge vif.sys_clk);
		phase.drop_objection(this);
	end
	endtask : main_phase

	task drive_one_pkt(ether_transaction tr);
	begin 
		bit	[31:0]	data_q[$];

		data_q.push_back(tr.dmac_r[31:0]);
		data_q.push_back({tr.smac_r[15:0], tr.dmac_r[47:32]});
		data_q.push_back(tr.smac_r[47:16]);
		data_q.push_back({tr.pload_r[tr.pload_r.size()-2], tr.pload_r[tr.pload_r.size()-1], tr.ether_type});
		for (int i = tr.pload_r.size()-3; i >= 3; i=i-4) begin
			data_q.push_back({tr.pload_r[i-3], tr.pload_r[i-2], tr.pload_r[i-1], tr.pload_r[i]});
		end
		case ((tr.pload_r.size()-2)%4)
			0:	data_q = data_q;
			1:	data_q.push_back({24'h0, tr.pload_r[0]});
			2:	data_q.push_back({16'h0, tr.pload_r[0], tr.pload_r[1]});
			3:	data_q.push_back({8'h0, tr.pload_r[0], tr.pload_r[1], tr.pload_r[2]});
			default : data_q = data_q;
		endcase

		// $display("dmac: %h", tr.dmac);
		// $display("dmac_r: %h", tr.dmac_r);
		// $display("smac: %h", tr.smac);
		// $display("smac_r: %h", tr.smac_r);
		// $display("type:\t %h", tr.ether_type);
		// $display("pload size:\t %h", tr.pload.size());
		// $display("pload:\t %h",tr.pload);
		// $display("pload_r:\t %h",tr.pload_r);
		// $display("size: ", data_q.size());
		$display("data_q:");
		foreach(data_q[i]) begin
			$display("%h", data_q[i]);
		end

		axi_init();
		@(posedge vif.arstn)
		write_transaction(32'h000107F8, 32'h80000000);
		write_transaction(32'h000107F4, tr.ether_type+14);
		for (int i = 0; i < data_q.size(); i++) begin
			write_transaction('h10000+4*i, data_q[i]);
		end
		// write_transaction(32'h00010000, tr.dmac_r[31:0]);
		// write_transaction(32'h00010004, {tr.smac_r[15:0], tr.dmac_r[47:32]});
		// write_transaction(32'h00010008, tr.smac_r[47:16]);
		// write_transaction(32'h0001000C, {16'h0201, tr.ether_type});
		// write_transaction(32'h00010010, 32'h06050403);
		// write_transaction(32'h00010014, 32'h0A090807);
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
	end
	endtask : drive_one_pkt

endclass : ether_driver
