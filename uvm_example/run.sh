#!/bin/bash

vcs -full64 -debug_access+all -kdb -lca -sverilog -f filelist.f \
-ntb_opts uvm-1.1 +incdir+./ -y ./ +libext+.sv+.v -timescale=1ns/1ps \
-P $VERDI_HOME/share/PLI/VCS/LINUXAMD64/novas.tab \
$VERDI_HOME/share/PLI/VCS/LINUXAMD64/pli.a -fsdb

./simv +UVM_TESTNAME=$1 -gui=verdi
