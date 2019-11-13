`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_if.sv"
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

	task axi_aw_collect(output [31:0] awaddr_out);
		@(posedge vif.awready) 
			if(vif.awvalid)
				awaddr_out = vif.awaddr;
	endtask : axi_aw_collect

	task axi_w_collect(output [31:0] wdata_out);
		@(posedge vif.wready)
			if(vif.wvalid)
				wdata_out = vif.wdata;
	endtask : axi_w_collect

	task axi_ar_collect(output [31:0] araddr_out);
		@(posedge vif.arready)
			if(vif.arvalid)
				araddr_out = vif.araddr;
	endtask : axi_ar_collect

	task axi_r_collect(output [31:0] rdata_out);
		@(negedge vif.rvalid)
			rdata_out = vif.rdata;
	endtask : axi_r_collect

	task write_collect(output [31:0] awaddr_out, wdata_out);
	fork
		axi_aw_collect(awaddr_out);
		axi_w_collect(wdata_out);
	join
	endtask : write_collect

	task read_collect(output [31:0] araddr_out, rdata_out);
	fork
		axi_ar_collect(araddr_out);
		axi_r_collect(rdata_out);
	join
	endtask : read_collect

	task collect_one_pkt(ether_transaction tr);
		bit [31:0] addr_temp, addr_q[$], data_temp, data_q[$], data_q_r[$];

		`uvm_info("ether_monitor_axi", "start collecting one packet", UVM_LOW)

		write_collect(addr_temp, data_temp);
		while(addr_temp != 32'h000107FC)
		begin 
			addr_q.push_back(addr_temp);
			data_q.push_back(data_temp);
			write_collect(addr_temp, data_temp);
		end
		// addr_q.push_back(addr_temp);
		// data_q.push_back(data_temp);
		assert(data_q.pop_front());
		assert(data_q.pop_front());
		// $display("data_q_collected:");
		// foreach(data_q[i]) begin
		// 	$display("%h", data_q[i]);
		// end
		for (int i = 0; i < data_q.size(); i++) begin
			data_q_r[i] = {<<4{data_q[i]}};
		end
		// foreach(data_q_r[i]) begin
		// 	$display("%h", data_q_r[i]);
		// end
		tr.dmac = {data_q_r[0], data_q_r[1][31:16]};
		tr.smac = {data_q_r[1][15:0], data_q_r[2]};
		tr.ether_type = {<<4{data_q_r[3][31:16]}};
		tr.pload.push_back(data_q_r[3][15:8]);
		tr.pload.push_back(data_q_r[3][7:0]);
		for (int i = 4; i < data_q_r.size(); i++) begin
			tr.pload.push_back(data_q_r[i][31:24]);
			tr.pload.push_back(data_q_r[i][23:16]);
			tr.pload.push_back(data_q_r[i][15:8]);
			tr.pload.push_back(data_q_r[i][7:0]);
		end
		while (tr.pload.size() > tr.ether_type) begin
			assert(tr.pload.pop_back());
		end

		`uvm_info("ether_monitor_axi", "end collecting one packet, print result:", UVM_LOW)
		tr.my_print();
	endtask : collect_one_pkt

endclass : ether_monitor_axi
