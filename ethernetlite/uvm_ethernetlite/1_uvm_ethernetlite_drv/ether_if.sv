interface ether_if (input sys_clk, input arstn, input phy_clk);

	logic	[31:0]	awaddr;
	logic	awvalid;
	logic	awready;

	logic	[31:0]	wdata;
	logic	[3:0]	wstrb;
	logic	wvalid;
	logic	wready;

	logic	[1:0]	bresp;
	logic	bvalid;
	logic	bready;

	logic	[31:0]	araddr;
	logic	arvalid;
	logic	arready;

	logic	[31:0]	rdata;
	logic	rvalid;
	logic	rready;
	logic	[1:0]	rresp;

endinterface