project open D:/proj/uvm_ethernetlite/2_uvm_ethernetlite_env/uvm_ethernetlite_env.mpf
project compileall
vsim work.top_tb -novopt
add wave -position end  sim:/top_tb/if_axi_inst/sys_clk
add wave -position end  sim:/top_tb/if_axi_inst/arstn
add wave -position end  sim:/top_tb/if_axi_inst/phy_clk
add wave -position end  sim:/top_tb/if_axi_inst/ip2intc_irpt
add wave -position end  sim:/top_tb/if_axi_inst/awaddr
add wave -position end  sim:/top_tb/if_axi_inst/awvalid
add wave -position end  sim:/top_tb/if_axi_inst/awready
add wave -position end  sim:/top_tb/if_axi_inst/wdata
add wave -position end  sim:/top_tb/if_axi_inst/wstrb
add wave -position end  sim:/top_tb/if_axi_inst/wvalid
add wave -position end  sim:/top_tb/if_axi_inst/wready
add wave -position end  sim:/top_tb/if_axi_inst/bresp
add wave -position end  sim:/top_tb/if_axi_inst/bvalid
add wave -position end  sim:/top_tb/if_axi_inst/bready
add wave -position end  sim:/top_tb/if_axi_inst/araddr
add wave -position end  sim:/top_tb/if_axi_inst/arvalid
add wave -position end  sim:/top_tb/if_axi_inst/arready
add wave -position end  sim:/top_tb/if_axi_inst/rdata
add wave -position end  sim:/top_tb/if_axi_inst/rvalid
add wave -position end  sim:/top_tb/if_axi_inst/rready
add wave -position end  sim:/top_tb/if_axi_inst/rresp
add wave -position end  sim:/top_tb/DUT/phy_tx_clk
add wave -position end  sim:/top_tb/DUT/phy_rx_clk
add wave -position end  sim:/top_tb/DUT/phy_crs
add wave -position end  sim:/top_tb/DUT/phy_dv
add wave -position end  sim:/top_tb/DUT/phy_rx_data
add wave -position end  sim:/top_tb/DUT/phy_col
add wave -position end  sim:/top_tb/DUT/phy_rx_er
add wave -position end  sim:/top_tb/DUT/phy_rst_n
add wave -position end  sim:/top_tb/DUT/phy_tx_en
add wave -position end  sim:/top_tb/DUT/phy_tx_data
run -a