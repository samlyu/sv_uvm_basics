project open D:/proj/uvm_ethernetlite/1_uvm_ethernetlite_drv/uvm_ethernetlite_drv.mpf
project compileall
vsim work.top_tb -novopt
add wave -position end  sim:/top_tb/sys_clk
add wave -position end  sim:/top_tb/arstn
add wave -position end  sim:/top_tb/phy_clk
add wave -position end  sim:/top_tb/if_inst/awaddr
add wave -position end  sim:/top_tb/if_inst/awvalid
add wave -position end  sim:/top_tb/if_inst/awready
add wave -position end  sim:/top_tb/if_inst/wdata
add wave -position end  sim:/top_tb/if_inst/wstrb
add wave -position end  sim:/top_tb/if_inst/wvalid
add wave -position end  sim:/top_tb/if_inst/wready
add wave -position end  sim:/top_tb/if_inst/bresp
add wave -position end  sim:/top_tb/if_inst/bvalid
add wave -position end  sim:/top_tb/if_inst/bready
add wave -position end  sim:/top_tb/if_inst/araddr
add wave -position end  sim:/top_tb/if_inst/arvalid
add wave -position end  sim:/top_tb/if_inst/arready
add wave -position end  sim:/top_tb/if_inst/rdata
add wave -position end  sim:/top_tb/if_inst/rvalid
add wave -position end  sim:/top_tb/if_inst/rready
add wave -position end  sim:/top_tb/if_inst/rresp
add wave -position end  sim:/top_tb/DUT/ip2intc_irpt
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