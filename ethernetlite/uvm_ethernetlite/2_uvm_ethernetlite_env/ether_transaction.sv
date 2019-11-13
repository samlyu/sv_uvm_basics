`ifndef ETHER_TRANSACTION__SV
`define ETHER_TRANSACTION__SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class ether_transaction extends uvm_sequence_item;

	`uvm_object_utils(ether_transaction)

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

	function void my_print();
		$display("dmac = %0h", dmac);
		$display("smac = %0h", smac);
		$display("ether_type = %0h", ether_type);
		$display("pload.size = %0h", pload.size());
		$write("pload = ");
		for (int i = 0; i < pload.size(); i++) begin
			// $display("pload[%0d] = %0h", i, pload[i]);
			$write("%0h ", pload[i]);
		end
		$write("\n");
	endfunction : my_print

endclass : ether_transaction

`endif