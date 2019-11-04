project open D:/proj/axi_ethernetlite_dut_ex/axi_ethernetlite_dut_ex_w_atg.mpf
project compileall
vsim work.top_tb -novopt
add wave -position end  sim:/top_tb/sys_clk
add wave -position end  sim:/top_tb/arstn
add wave -position end  sim:/top_tb/phy_clk
add wave -position end  sim:/top_tb/done
add wave -position end  sim:/top_tb/status
add wave -position end  sim:/top_tb/atg_stat
add wave -position end  sim:/top_tb/awaddr
add wave -position end  sim:/top_tb/awvalid
add wave -position end  sim:/top_tb/awready
add wave -position end  sim:/top_tb/wdata
add wave -position end  sim:/top_tb/wstrb
add wave -position end  sim:/top_tb/wvalid
add wave -position end  sim:/top_tb/wready
add wave -position end  sim:/top_tb/bresp
add wave -position end  sim:/top_tb/bvalid
add wave -position end  sim:/top_tb/bready
add wave -position end  sim:/top_tb/araddr
add wave -position end  sim:/top_tb/arvalid
add wave -position end  sim:/top_tb/arready
add wave -position end  sim:/top_tb/rdata
add wave -position end  sim:/top_tb/rvalid
add wave -position end  sim:/top_tb/rready
add wave -position end  sim:/top_tb/rresp
run -a