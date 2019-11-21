`ifndef ETHER_TRANSACTION__SV
`define ETHER_TRANSACTION__SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class ether_transaction extends uvm_sequence_item;

	rand bit [47:0]	dmac;
	rand bit [47:0]	smac;
	rand bit [15:0]	ether_type;
	rand byte		pload[$];

	bit [47:0] dmac_r, smac_r;
	rand byte	pload_r[];

	function new(string name = "ether_transaction");
		super.new(name);
	endfunction : new

	constraint pload_cons {
		pload.size() >= 46;
		pload.size() <= 1500;
	}

	constraint pload_r_cons {
		pload_r.size() == pload.size();
	}

	constraint rand_cons {
		pload.size() == ether_type; 
		dmac == 48'hFFFF_FFFF_FFFF; // broadcast
		smac == 48'h0000_5E00_FACE; // default
	}

	`uvm_object_utils_begin(ether_transaction)
		`uvm_field_int(dmac, UVM_ALL_ON)
		`uvm_field_int(smac, UVM_ALL_ON)
		`uvm_field_int(ether_type, UVM_ALL_ON)
		`uvm_field_queue_int(pload, UVM_ALL_ON)
	`uvm_object_utils_end

	function bit[47:0] dmac_rev();
		return {<<4{dmac}};
	endfunction : dmac_rev

	function bit[47:0] smac_rev();
		return {<<4{smac}};
	endfunction : smac_rev

	function void pload_rev();
		pload_r = {<<4{pload}};
	endfunction : pload_rev

	function void post_randomize();
		dmac_r = dmac_rev;
		smac_r = smac_rev;
		pload_rev();
	endfunction : post_randomize

endclass : ether_transaction

`endif
