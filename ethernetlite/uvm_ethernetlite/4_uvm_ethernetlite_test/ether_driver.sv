`ifndef ETHER_DRIVER__SV
`define ETHER_DRIVER__SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_if.sv"
`include "ether_transaction.sv"

class ether_driver extends uvm_driver #(ether_transaction);

	`uvm_component_utils(ether_driver)
	
	virtual ether_if_axi vif_axi;
	virtual ether_if_phy vif_phy;

	function new(string name = "ether_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	// AXI4 Lite
	task axi_aw(input [31:0] awaddr_in);
	begin 
		repeat (3) @(posedge vif_axi.sys_clk);
			vif_axi.awaddr = awaddr_in;
			vif_axi.awvalid = 1'b1;
		@(negedge vif_axi.awready)
			vif_axi.awvalid = 1'b0;
	end
	endtask : axi_aw

	task axi_w(input [31:0] wdata_in);
	begin 
		repeat (3) @(posedge vif_axi.sys_clk);
			vif_axi.wdata = wdata_in;
			vif_axi.wstrb = 4'hf;
			vif_axi.wvalid = 1'b1;
		@(negedge vif_axi.wready)
			vif_axi.wvalid = 1'b0;
	end
	endtask : axi_w

	task axi_b();
	begin 
		repeat (3) @(posedge vif_axi.sys_clk);
			vif_axi.bready = 1'b1;
		@(negedge vif_axi.bvalid)
			vif_axi.bready = 1'b0;
	end
	endtask : axi_b

	task axi_ar(input [31:0] araddr_in);
	begin 
		repeat (3) @(posedge vif_axi.sys_clk);
			vif_axi.araddr = araddr_in;
			vif_axi.arvalid = 1'b1;
		@(negedge vif_axi.arready)
			vif_axi.arvalid = 1'b0;
	end
	endtask : axi_ar

	task axi_r();
	begin 
		repeat (3) @(posedge vif_axi.sys_clk);
			vif_axi.rready = 1'b1;
		@(negedge vif_axi.rvalid)
			vif_axi.rready = 1'b0;
	end
	endtask : axi_r

	task axi_init();
	begin 
		vif_axi.awaddr = 32'h0;
		vif_axi.awvalid = 1'b0;

		vif_axi.wdata = 32'h0;
		vif_axi.wstrb = 4'hf;
		vif_axi.wvalid = 1'b0;

		vif_axi.bready = 1'b0;

		vif_axi.araddr = 32'h0;
		vif_axi.arvalid = 1'b0;

		vif_axi.rready = 1'b0;
	end
	endtask : axi_init

	task phy_init();
	begin 
		vif_phy.crs = 1'b0;
		vif_phy.dv = 1'b0;
		vif_phy.rx_data = 4'd0;
		vif_phy.col = 1'b0;
		vif_phy.rx_er = 1'b0;
	end
	endtask : phy_init

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
		if(!uvm_config_db#(virtual ether_if_axi)::get(this, "", "vif_axi", vif_axi))
			`uvm_fatal("ether_driver", "axi virtual interface must be set in driver!")
		if(!uvm_config_db#(virtual ether_if_phy)::get(this, "", "vif_phy", vif_phy))
			`uvm_fatal("ether_driver", "phy virtual interface must be set in driver!")
	endfunction : build_phase

	virtual task main_phase(uvm_phase phase);
	begin 
		// phase.raise_objection(this);
		`uvm_info("ether_driver", "driver main_phase called", UVM_LOW)

		axi_init();
		phy_init();
		@(posedge vif_axi.arstn)

		while(1) begin 
			seq_item_port.get_next_item(req);
			drive_one_pkt(req);
			seq_item_port.item_done();
		end

		// for (int i = 0; i < 5; i++) begin
		// 	req = new("req");
		// 	assert(req.randomize() with {
		// 		pload.size() == ether_type; 
		// 		dmac == 48'hFFFF_FFFF_FFFF; // broadcast
		// 		smac == 48'h0000_5E00_FACE; // default
		// 		}
		// 	);
		// 	drive_one_pkt(req);
		// 	repeat (15) @(posedge vif_axi.sys_clk);
		// end

		// phase.drop_objection(this);
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

		`uvm_info("ether_driver", "write transactions start", UVM_LOW)
		write_transaction(32'h000107F8, 32'h80000000);
		write_transaction(32'h000107F4, tr.ether_type+14);
		for (int i = 0; i < data_q.size(); i++) begin
			write_transaction('h10000+4*i, data_q[i]);
		end
		write_transaction(32'h000107FC, 32'h00000019);
		`uvm_info("ether_driver", "write transactions done", UVM_LOW)

		`uvm_info("ether_driver", "read transactions start", UVM_LOW)
		while(vif_axi.rdata[3] != 1'b1 || vif_axi.rdata[0] != 1'b0)
		begin 
			read_transaction(32'h000107FC);
		end
		while(vif_axi.rdata[0] != 1'b1)
		begin 
			read_transaction(32'h000117FC);
		end
		`uvm_info("ether_driver", "read transactions done", UVM_LOW)
	end
	endtask : drive_one_pkt

endclass : ether_driver

`endif
