.main clear
quit -sim

set UVM_HOME /home/eda/Mentor/Modelsim/modeltech/verilog_src/uvm-1.1d/
set UVM_DPI_HOME /home/eda/Mentor/Modelsim/modeltech/uvm-1.1d/linux_x86_64/uvm_dpi

vlib work
vlog +incdir+$UVM_HOME/src+$UVM_HOME -f filelist.f -override_timescale 1ns/1ps
vsim -novopt -sv_lib $UVM_DPI_HOME -c top_tb +UVM_TESTNAME=$1
add wave -position end  sim:/top_tb/input_if/clk
add wave -position end  sim:/top_tb/input_if/rst_n
add wave -position end  sim:/top_tb/input_if/data
add wave -position end  sim:/top_tb/input_if/valid
add wave -position end  sim:/top_tb/output_if/data
add wave -position end  sim:/top_tb/output_if/valid
run -a
