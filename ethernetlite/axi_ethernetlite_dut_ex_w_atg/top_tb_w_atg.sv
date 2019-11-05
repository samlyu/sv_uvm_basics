`timescale 1ns/1ps

module top_tb_w_atg ();

parameter	CLK_CYCLE = 10;

reg	sys_clk;
reg	arstn;
reg	phy_clk;
wire	done;
wire	[1:0]	status;
wire	[31:0]	atg_stat;

assign	status = atg_stat[1:0];

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

// display result
always@(done) begin 
	if(done) begin 
		if(status == 2'b01) begin 
			$display("Packet Received");
			$display("Test Completed Successfully");
		end
		else if(status == 2'b10) begin 
			$display("Recieved AXI Response Error Test Failure");
		end
		else if(status == 2'b11) begin 
			$display("Test Hanged");
		end
	end
end

// finish after done
initial begin 
	@(posedge done)
		#(CLK_CYCLE * 10)	$finish;
end

wire	[31:0]	awaddr;
wire	awvalid;
wire	awready;
wire	[31:0]	wdata;
wire	[3:0]	wstrb;
wire	wvalid;
wire	wready;
wire	[1:0]	bresp;
wire	bvalid;
wire	bready;
wire	[31:0]	araddr;
wire	arvalid;
wire	arready;
wire	[31:0]	rdata;
wire	rvalid;
wire	rready;
wire	[1:0]	rresp;

axi_traffic_gen_0 ATG (
	.s_axi_aclk(sys_clk),                          // input wire s_axi_aclk
	.s_axi_aresetn(arstn),                    // input wire s_axi_aresetn

	.m_axi_lite_ch1_awaddr(awaddr),    // output wire [31 : 0] m_axi_lite_ch1_awaddr
	.m_axi_lite_ch1_awprot(),   // output wire [2 : 0] m_axi_lite_ch1_awprot
	.m_axi_lite_ch1_awvalid(awvalid),  // output wire m_axi_lite_ch1_awvalid
	.m_axi_lite_ch1_awready(awready),  // input wire m_axi_lite_ch1_awready

	.m_axi_lite_ch1_wdata(wdata),      // output wire [31 : 0] m_axi_lite_ch1_wdata
	.m_axi_lite_ch1_wstrb(wstrb),      // output wire [3 : 0] m_axi_lite_ch1_wstrb
	.m_axi_lite_ch1_wvalid(wvalid),    // output wire m_axi_lite_ch1_wvalid
	.m_axi_lite_ch1_wready(wready),    // input wire m_axi_lite_ch1_wready

	.m_axi_lite_ch1_bresp(bresp),      // input wire [1 : 0] m_axi_lite_ch1_bresp
	.m_axi_lite_ch1_bvalid(bvalid),    // input wire m_axi_lite_ch1_bvalid
	.m_axi_lite_ch1_bready(bready),    // output wire m_axi_lite_ch1_bready

	.m_axi_lite_ch1_araddr(araddr),    // output wire [31 : 0] m_axi_lite_ch1_araddr
	.m_axi_lite_ch1_arvalid(arvalid),  // output wire m_axi_lite_ch1_arvalid
	.m_axi_lite_ch1_arready(arready),  // input wire m_axi_lite_ch1_arready

	.m_axi_lite_ch1_rdata(rdata),      // input wire [31 : 0] m_axi_lite_ch1_rdata
	.m_axi_lite_ch1_rvalid(rvalid),    // input wire m_axi_lite_ch1_rvalid
	.m_axi_lite_ch1_rresp(rresp),      // input wire [1 : 0] m_axi_lite_ch1_rresp
	.m_axi_lite_ch1_rready(rready),    // output wire m_axi_lite_ch1_rready

	.done(done),                                      // output wire done
	.status(atg_stat)                                  // output wire [31 : 0] status
);

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
