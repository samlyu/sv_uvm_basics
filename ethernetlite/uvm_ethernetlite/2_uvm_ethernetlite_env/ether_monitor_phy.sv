`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_if.sv"
`include "ether_transaction.sv"

class ether_monitor_phy extends uvm_monitor;

	`uvm_component_utils(ether_monitor_phy)

	virtual ether_if_phy vif;
	uvm_analysis_port #(ether_transaction) ap;

	function new(string name = "ether_monitor_phy", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual ether_if_phy)::get(this, "", "vif", vif))
			`uvm_fatal("ether_monitor_phy", "virtual interface must be set in monitor!")

		ap = new("ap", this);
	endfunction : build_phase

	task main_phase(uvm_phase phase);
		ether_transaction tr;
		tr = new("tr");
		collect_one_pkt(tr);
		ap.write(tr);
	endtask : main_phase

	task phy_tx_collect(output [3:0] tx_data_out);
		@(posedge vif.phy_clk)
			tx_data_out = vif.tx_data;
	endtask : phy_tx_collect

	task collect_one_pkt(ether_transaction tr);
		bit [7:0] data_temp, data_q[$];

		`uvm_info("ether_monitor_phy", "start collecting one packet", UVM_LOW)

		@(posedge vif.tx_en);
		while(vif.tx_en)
		begin 
			phy_tx_collect(data_temp[7:4]);
			phy_tx_collect(data_temp[3:0]);
			data_q.push_back(data_temp);
		end

		for (int i = 0; i < 8; i++) begin
			data_temp = data_q.pop_front(); // useless data_temp
		end

		tr.dmac = {data_q[0], data_q[1], data_q[2], data_q[3], data_q[4], data_q[5]};
		tr.smac = {data_q[6], data_q[7], data_q[8], data_q[9], data_q[10], data_q[11]};
		tr.ether_type = {{<<4{data_q[13]}}, {<<4{data_q[12]}}};
		for (int i = 14; i < data_q.size(); i++) begin
			tr.pload.push_back(data_q[i]);
		end
		while (tr.pload.size() > tr.ether_type) begin 
			data_temp = tr.pload.pop_back(); // useless data_temp
		end

		`uvm_info("ether_monitor_phy", "end collecting one packet, print result: ", UVM_LOW)
		tr.print();

		// $write("data_q = ");
		// for (int i = 0; i < data_q.size(); i++) begin
		// 	$write("%0h ", data_q[i]);
		// end
		// $write("\n");

	endtask : collect_one_pkt

endclass : ether_monitor_phy
