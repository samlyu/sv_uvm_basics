#!/bin/bash

export UVM_HOME=/home/eda/Synopsys/VCS2016/etc/uvm-1.1/
vcs -full64 -debug_access+all -kdb -lca -sverilog -f filelist.f -ntb_opts uvm-1.1 +incdir+./ -y ./ +libext+.sv+.v -timescale=1ns/1ps -P $VERDI_HOME/share/PLI/VCS/LINUXAMD64/novas.tab $VERDI_HOME/share/PLI/VCS/LINUXAMD64/pli.a +vcs+dumpvars
./simv +UVM_TESTNAME=$1 -gui=verdi
