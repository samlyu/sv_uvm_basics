project open D:/proj/axi_ethernetlite_dut_ex/axi_ethernetlite_dut_ex_wo_atg.mpf
project compileall
vsim work.top_tb_wo_atg -novopt
add wave -position end  sim:/top_tb_wo_atg/sys_clk
add wave -position end  sim:/top_tb_wo_atg/arstn
add wave -position end  sim:/top_tb_wo_atg/phy_clk
add wave -position end  sim:/top_tb_wo_atg/awaddr
add wave -position end  sim:/top_tb_wo_atg/awvalid
add wave -position end  sim:/top_tb_wo_atg/awready
add wave -position end  sim:/top_tb_wo_atg/wdata
add wave -position end  sim:/top_tb_wo_atg/wstrb
add wave -position end  sim:/top_tb_wo_atg/wvalid
add wave -position end  sim:/top_tb_wo_atg/wready
add wave -position end  sim:/top_tb_wo_atg/bresp
add wave -position end  sim:/top_tb_wo_atg/bvalid
add wave -position end  sim:/top_tb_wo_atg/bready
add wave -position end  sim:/top_tb_wo_atg/araddr
add wave -position end  sim:/top_tb_wo_atg/arvalid
add wave -position end  sim:/top_tb_wo_atg/arready
add wave -position end  sim:/top_tb_wo_atg/rdata
add wave -position end  sim:/top_tb_wo_atg/rvalid
add wave -position end  sim:/top_tb_wo_atg/rready
add wave -position end  sim:/top_tb_wo_atg/rresp
add wave -position end  sim:/top_tb_wo_atg/DUT/phy_tx_clk
add wave -position end  sim:/top_tb_wo_atg/DUT/phy_rx_clk
add wave -position end  sim:/top_tb_wo_atg/DUT/phy_crs
add wave -position end  sim:/top_tb_wo_atg/DUT/phy_dv
add wave -position end  sim:/top_tb_wo_atg/DUT/phy_rx_data
add wave -position end  sim:/top_tb_wo_atg/DUT/phy_col
add wave -position end  sim:/top_tb_wo_atg/DUT/phy_rx_er
add wave -position end  sim:/top_tb_wo_atg/DUT/phy_rst_n
add wave -position end  sim:/top_tb_wo_atg/DUT/phy_tx_en
add wave -position end  sim:/top_tb_wo_atg/DUT/phy_tx_data
run -a