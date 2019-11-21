`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_transaction.sv"

class ether_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(ether_scoreboard)

	ether_transaction exp_queue[$];
	uvm_blocking_get_port #(ether_transaction) exp_port;
	uvm_blocking_get_port #(ether_transaction) act_port;

	function new(string name, uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		exp_port = new("exp_port", this);
		act_port = new("act_port", this);
	endfunction : build_phase

	virtual task main_phase(uvm_phase phase);
		ether_transaction tr_expect, tr_actual, tr_temp;
		bit result;

		super.main_phase(phase);

		fork
			while(1) begin 
				exp_port.get(tr_expect);
				exp_queue.push_back(tr_expect);
			end

			while(1) begin 
				act_port.get(tr_actual);
				if(exp_queue.size() > 0) begin 
					tr_temp = exp_queue.pop_front();
					result = tr_actual.compare(tr_temp);
					if(result) begin 
						`uvm_info("ether_scoreboard", "COMPARISON PASSED", UVM_LOW)
					end
					else begin 
						`uvm_error("ether_scoreboard", "COMPARISON FAILED")
						$display("Expected packet: ");
						tr_temp.print();
						$display("Actual packet: ");
						tr_actual.print();
					end
				end
				else begin 
					`uvm_error("ether_scoreboard", "QUEUE EMPTY");
					$display("Unexpected packet: ");
					tr_actual.print();
				end
			end
		join
		
	endtask : main_phase

endclass : ether_scoreboard
