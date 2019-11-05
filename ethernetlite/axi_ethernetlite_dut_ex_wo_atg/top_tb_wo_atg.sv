`timescale 1ns/1ps

module top_tb_wo_atg ();

parameter	CLK_CYCLE = 10;

reg	sys_clk;
reg	arstn;
reg	phy_clk;

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

reg	[31:0]	awaddr;
reg	awvalid;
wire	awready;

reg	[31:0]	wdata;
reg	[3:0]	wstrb;
reg	wvalid;
wire	wready;

wire	[1:0]	bresp;
wire	bvalid;
reg	bready;

reg	[31:0]	araddr;
reg	arvalid;
wire	arready;

wire	[31:0]	rdata;
wire	rvalid;
reg	rready;
wire	[1:0]	rresp;

// AXI4 Lite
task axi_aw(input [31:0] awaddr_in);
begin 
	repeat (3) @(posedge sys_clk);
		awaddr = awaddr_in;
		awvalid = 1'b1;
	@(negedge awready)
		awvalid = 1'b0;
end
endtask : axi_aw

task axi_w(input [31:0] wdata_in);
begin 
	repeat (3) @(posedge sys_clk);
		wdata = wdata_in;
		wstrb = 4'hf;
		wvalid = 1'b1;
	@(negedge wready)
		wvalid = 1'b0;
end
endtask : axi_w

task axi_b();
begin 
	repeat (3) @(posedge sys_clk);
		bready = 1'b1;
	@(negedge bvalid)
		bready = 1'b0;
end
endtask : axi_b

task axi_ar(input [31:0] araddr_in);
begin 
	repeat (3) @(posedge sys_clk);
		araddr = araddr_in;
		arvalid = 1'b1;
	@(negedge arready)
		arvalid = 1'b0;
end
endtask : axi_ar

task axi_r();
begin 
	repeat (3) @(posedge sys_clk);
		rready = 1'b1;
	@(posedge rvalid)
		$display("data received = %b", rdata);
	@(negedge rvalid)
		rready = 1'b0;
end
endtask : axi_r

task axi_init();
begin 
	awaddr = 32'h0;
	awvalid = 1'b0;

	wdata = 32'h0;
	wstrb = 4'hf;
	wvalid = 1'b0;

	bready = 1'b0;

	araddr = 32'h0;
	arvalid = 1'b0;

	rready = 1'b0;
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

initial begin 
	axi_init();
	@(posedge arstn)	
	write_transaction(32'h000107F8, 32'h80000000);
	write_transaction(32'h000107F4, 32'h00000014);
	write_transaction(32'h00010000, 32'hFFFFFFFF);
	write_transaction(32'h00010004, 32'h0000FFFF);
	write_transaction(32'h00010008, 32'hECAFE500);
	write_transaction(32'h0001000C, 32'h02010014);
	write_transaction(32'h00010010, 32'h06050403);
	write_transaction(32'h00010014, 32'h0A090807);
	write_transaction(32'h000107FC, 32'h00000019);

	while(rdata[3] != 1'b1 || rdata[0] != 1'b0)
	begin 
		read_transaction(32'h000107FC);
	end

	while(rdata[0] != 1'b1)
	begin 
		read_transaction(32'h000117FC);
	end
	repeat (15) @(posedge sys_clk);
	$finish;
end

axi_ethernetlite_dut DUT (
	.s_axi_aclk(sys_clk),        // input wire s_axi_aclk
	.s_axi_aresetn(arstn),  // input wire s_axi_aresetn
	.ip2intc_irpt(),    // output wire ip2intc_irpt

	.s_axi_awaddr(awaddr[12:0]),    // input wire [12 : 0] s_axi_awaddr
	.s_axi_awvalid(awvalid),  // input wire s_axi_awvalid
	.s_axi_awready(awready),  // output wire s_axi_awready

	.s_axi_wdata(wdata),      // input wire [31 : 0] s_axi_wdata
	.s_axi_wstrb(wstrb),      // input wire [3 : 0] s_axi_wstrb
	.s_axi_wvalid(wvalid),    // input wire s_axi_wvalid
	.s_axi_wready(wready),    // output wire s_axi_wready

	.s_axi_bresp(bresp),      // output wire [1 : 0] s_axi_bresp
	.s_axi_bvalid(bvalid),    // output wire s_axi_bvalid
	.s_axi_bready(bready),    // input wire s_axi_bready

	.s_axi_araddr(araddr[12:0]),    // input wire [12 : 0] s_axi_araddr
	.s_axi_arvalid(arvalid),  // input wire s_axi_arvalid
	.s_axi_arready(arready),  // output wire s_axi_arready

	.s_axi_rdata(rdata),      // output wire [31 : 0] s_axi_rdata
	.s_axi_rresp(rresp),      // output wire [1 : 0] s_axi_rresp
	.s_axi_rvalid(rvalid),    // output wire s_axi_rvalid
	.s_axi_rready(rready),    // input wire s_axi_rready

	.phy_tx_clk(phy_clk),        // input wire phy_tx_clk
	.phy_rx_clk(phy_clk),        // input wire phy_rx_clk
	.phy_crs(1'b0),              // input wire phy_crs
	.phy_dv(1'b0),                // input wire phy_dv
	.phy_rx_data(4'd0),      // input wire [3 : 0] phy_rx_data
	.phy_col(1'b0),              // input wire phy_col
	.phy_rx_er(1'b0),          // input wire phy_rx_er
	.phy_rst_n(),          // output wire phy_rst_n
	.phy_tx_en(),          // output wire phy_tx_en
	.phy_tx_data()      // output wire [3 : 0] phy_tx_data
);

endmodule
