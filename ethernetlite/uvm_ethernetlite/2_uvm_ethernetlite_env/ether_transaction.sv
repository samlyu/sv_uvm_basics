`include "uvm_macros.svh"
import uvm_pkg::*;

class ether_transaction extends uvm_sequence_item;

	`uvm_object_utils(ether_transaction)

	rand bit [47:0]	dmac;
	rand bit [47:0]	smac;
	rand bit [15:0]	ether_type;
	rand byte		pload[];

	bit [47:0] dmac_r, smac_r;
	rand byte	pload_r[];

	constraint pload_cons {
		pload.size() >= 46;
		pload.size() <= 1500;
	}

	constraint pload_r_cons {
		pload_r.size() == pload.size();
	}

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

	function new(string name = "ether_transaction");
		super.new(name);
	endfunction : new

endclass : ether_transaction
