`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_agent.sv"
`include "ether_transaction.sv"
`include "ether_scoreboard.sv"
// `include "ether_driver.sv"
// `include "ether_monitor_axi.sv"
// `include "ether_monitor_phy.sv"

class ether_env extends uvm_env;

	`uvm_component_utils(ether_env)
	// ether_driver drv;
	// ether_monitor_axi mon_axi;
	// ether_monitor_phy mon_phy;
	ether_agent i_agt;
	ether_agent o_agt;
	ether_scoreboard scb;

	uvm_tlm_analysis_fifo #(ether_transaction) axi_scb_fifo;
	uvm_tlm_analysis_fifo #(ether_transaction) phy_scb_fifo;

	function new(string name = "ether_env", uvm_component parent);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		// drv = ether_driver::type_id::create("drv", this);
		// mon_axi = ether_monitor_axi::type_id::create("mon_axi", this);
		// mon_phy = ether_monitor_phy::type_id::create("mon_phy", this);
		i_agt = ether_agent::type_id::create("i_agt", this);
		o_agt = ether_agent::type_id::create("o_agt", this);
		i_agt.is_active = UVM_ACTIVE;
		o_agt.is_active = UVM_PASSIVE;
		scb = ether_scoreboard::type_id::create("scb", this);
		axi_scb_fifo = new("axi_scb_fifo", this);
		phy_scb_fifo = new("phy_scb_fifo", this);
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		i_agt.ap.connect(axi_scb_fifo.analysis_export);
		scb.exp_port.connect(axi_scb_fifo.blocking_get_export);

		o_agt.ap.connect(phy_scb_fifo.analysis_export);
		scb.act_port.connect(phy_scb_fifo.blocking_get_export);

	endfunction : connect_phase

endclass : ether_env
