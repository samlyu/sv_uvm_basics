`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ether_if.sv"
`include "ether_env.sv"

module top_tb ();

parameter	CLK_CYCLE = 10;
logic	sys_clk;
logic	arstn;
logic	phy_clk;
ether_if_axi	if_axi_inst(sys_clk, arstn, phy_clk, ip2intc_irpt);
ether_if_phy	if_phy_inst(sys_clk, arstn, phy_clk, ip2intc_irpt);

// sys_clk: 100MHz
initial begin
	sys_clk = 0;
	forever	#(CLK_CYCLE/2)	sys_clk = ~sys_clk;
end

// phy_clk: 25MHz
initial begin 
	phy_clk = 0;
	forever #(CLK_CYCLE * 4/2)	phy_clk = ~phy_clk;
end

// arstn: active low
initial begin 
	arstn = 1'b0;
	#(CLK_CYCLE * 5/2)	arstn <= 1'b0;
	#(CLK_CYCLE * 7)	arstn <= 1'b1;
end

initial begin 
	run_test("ether_env");
end

initial begin 
	uvm_config_db#(virtual ether_if_axi)::set(null, "uvm_test_top.drv", "vif_axi", if_axi_inst);
	uvm_config_db#(virtual ether_if_phy)::set(null, "uvm_test_top.drv", "vif_phy", if_phy_inst);
	uvm_config_db#(virtual ether_if_axi)::set(null, "uvm_test_top.mon_axi", "vif", if_axi_inst);
end

axi_ethernetlite_dut DUT (
	.s_axi_aclk(sys_clk),        // input wire s_axi_aclk
	.s_axi_aresetn(arstn),  // input wire s_axi_aresetn
	.ip2intc_irpt(ip2intc_irpt),    // output wire ip2intc_irpt

	.s_axi_awaddr(if_axi_inst.awaddr[12:0]),    // input wire [12 : 0] s_axi_awaddr
	.s_axi_awvalid(if_axi_inst.awvalid),  // input wire s_axi_awvalid
	.s_axi_awready(if_axi_inst.awready),  // output wire s_axi_awready

	.s_axi_wdata(if_axi_inst.wdata),      // input wire [31 : 0] s_axi_wdata
	.s_axi_wstrb(if_axi_inst.wstrb),      // input wire [3 : 0] s_axi_wstrb
	.s_axi_wvalid(if_axi_inst.wvalid),    // input wire s_axi_wvalid
	.s_axi_wready(if_axi_inst.wready),    // output wire s_axi_wready

	.s_axi_bresp(if_axi_inst.bresp),      // output wire [1 : 0] s_axi_bresp
	.s_axi_bvalid(if_axi_inst.bvalid),    // output wire s_axi_bvalid
	.s_axi_bready(if_axi_inst.bready),    // input wire s_axi_bready

	.s_axi_araddr(if_axi_inst.araddr[12:0]),    // input wire [12 : 0] s_axi_araddr
	.s_axi_arvalid(if_axi_inst.arvalid),  // input wire s_axi_arvalid
	.s_axi_arready(if_axi_inst.arready),  // output wire s_axi_arready

	.s_axi_rdata(if_axi_inst.rdata),      // output wire [31 : 0] s_axi_rdata
	.s_axi_rresp(if_axi_inst.rresp),      // output wire [1 : 0] s_axi_rresp
	.s_axi_rvalid(if_axi_inst.rvalid),    // output wire s_axi_rvalid
	.s_axi_rready(if_axi_inst.rready),    // input wire s_axi_rready

	.phy_tx_clk(phy_clk),        // input wire phy_tx_clk
	.phy_rx_clk(phy_clk),        // input wire phy_rx_clk
	.phy_crs(if_phy_inst.crs),              // input wire phy_crs
	.phy_dv(if_phy_inst.dv),                // input wire phy_dv
	.phy_rx_data(if_phy_inst.rx_data),      // input wire [3 : 0] phy_rx_data
	.phy_col(if_phy_inst.col),              // input wire phy_col
	.phy_rx_er(if_phy_inst.rx_er),          // input wire phy_rx_er
	.phy_rst_n(if_phy_inst.rst_n),          // output wire phy_rst_n
	.phy_tx_en(if_phy_inst.tx_en),          // output wire phy_tx_en
	.phy_tx_data(if_phy_inst.tx_data)       // output wire [3 : 0] phy_tx_data
);

endmodule
