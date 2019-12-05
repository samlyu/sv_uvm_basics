# do run.tcl case0 / case1
quit -sim
.main clear
project open D:/proj/uvm_ethernetlite/4_uvm_ethernetlite_test/uvm_ethernetlite_test.mpf
project compileall
vsim work.top_tb -novopt +UVM_TESTNAME=$1
add wave -position end  sim:/top_tb/sys_clk
add wave -position end  sim:/top_tb/arstn
add wave -position end  sim:/top_tb/phy_clk
add wave -position end  sim:/top_tb/ip2intc_irpt
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
add wave -position end  sim:/top_tb/if_phy_inst/crs
add wave -position end  sim:/top_tb/if_phy_inst/dv
add wave -position end  sim:/top_tb/if_phy_inst/rx_data
add wave -position end  sim:/top_tb/if_phy_inst/col
add wave -position end  sim:/top_tb/if_phy_inst/rx_er
add wave -position end  sim:/top_tb/if_phy_inst/rst_n
add wave -position end  sim:/top_tb/if_phy_inst/tx_en
add wave -position end  sim:/top_tb/if_phy_inst/tx_data
run -a

