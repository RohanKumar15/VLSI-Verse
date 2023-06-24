#Makefile for AHB-APB
RTL=../RTL/*
INC= +incdir+ ../AHB_agt +incdir+ ../APB_agt +incdir+ ../test +incdir+ ../tb +incdir+ ../src
INC= +incdir+ ../AHB_agt +incdir+ ../APB_agt +incdir+ ../test +incdir+ ../tb +incdir+ ../src +define+WRAPPING_INCR

SVTB= ../tb/top.sv
SVTB1= ../test/AHB_APB_pkg.sv
COVOP= -dbg -coverage sba
work= work

VSIMOPT= +access +r -sva
VSIMBATCH1= -c -acdb_file mem_cov1.acdb -do "log -mem -rec *;run -all; exit" 
VSIMBATCH2= -c -acdb_file mem_cov2.acdb -do "log -mem -rec *;run -all; exit"
VSIMBATCH3= -c -acdb_file mem_cov3.acdb -do "log -mem -rec *;run -all; exit"
VSIMBATCH4= -c -acdb_file mem_cov4.acdb -do "log -mem -rec *;run -all; exit"

lib:
	vlib $(work)
	vmap work $(work)

sv_cmp: 
	clean lib comp0

sv_cmp1: 
	clean lib comp1

gui:
	vsim&

comp0:
	vlog -uvm -work $(work) $(COVOP) $(RTL) $(SVTB1) $(INC) $(SVTB)

comp1:
	vlog -uvm -work $(work) $(COVOP) $(RTL) $(SVTB1) $(INC1) $(SVTB)

run_test: comp0
	vsim $(VSIMBATCH1) $(VSIMOPT) $(VSIMCOV) -sva -sv_seed random -l s.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME = test_1 
	+UVM_VERBOSITY =UVM_MEDIUM #the default verbosity is medium
	vsim -c -do "acdb report -db mem_cov1.acdb -html -o mem_cov1.html"

run_test2: sv_cmp1
	vsim $(VSIMBATCH1) $(VSIMOPT) $(VSIMCOV) -sva -sv_seed random -l s.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME = Incr 
	+UVM_VERBOSITY= UVM_MEDIUM 
	vsim -c -do "acdb report -db mem_cov2.acdb -html -o mem_cov2.html;exit"

run_test3: sv_cmp1
	vsim $(VSIMBATCH1) $(VSIMOPT) $(VSIMCOV) -sva -sv_seed random -l s.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME= Wrapping 
	+UVM_VERBOSITY= UVM_MEDIUM
       	vsim -c -do "acdb report -db mem_cov3.acdb -html -o mem_cov3.html;exit"

run_test4: sv_cmp1
	vsim $(VSIMBATCH1) $(VSIMOPT) $(VSIMCOV) -sva -sv_seed random -l s.log work.top +UVM_OBJECTION_TRACE +UVM_TESTNAME= test4 
	+UVM_VERBOSITY= UVM_MEDIUM
        vsim -c -do "acdb report -db mem_cov4.acdb -html -o mem_cov4.html;exit"

clean:
	rm -rf modelsim.* transcript* *log* work
	vsim.wlf fcover* covhtml* mem_cov*

report: 
	vsim -c -do "acdb merge -cov sbfa -i
	mem_cov1.acdb -i mem_cov2.acdb -i mem_cov3.acdb -i mem_cov4.acdb -o mem_cov_merged.acdb;exit"

rep:
	vsim -c -do "acdb report -db mem_cov_merged.acdb -html -o mem_cov_merged.html;exit"

regress:
	clean run_test1 run_test2 run_test3 run_test4 report rep cov

cov:
	firefox mem_cov_merged.html&

