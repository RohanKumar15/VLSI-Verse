# Makefile for fifo verilog testbench 
RTL= ../duv_tb/fifo.sv 
TB = ../duv_tb/tb_fifo.sv
work= work
VSIMOPT= -vopt -voptargs=+acc=a
VSIMCOV= -coverage -sva 
VSIMBATCH = -c -do "log -r /* ; atv log -enable -r /*; coverage save -onexit fifo_cov; run -all;exit"
VSIMBATCH1= -l test.log 

lib:
	vlib $(work)
	vmap work $(work) 

sv_cmp: clean lib comp0 
         
run_sim: 
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH) $(VSIMBATCH1) work.tb_fifo
	vcover report  -cvg -details -codeAll -assert -directive  -html fifo_cov

gui:
	 vsim -view wave_file.wlf
 
comp0:
	vlog -work $(work) $(RTL) $(TB)
	
run_test: clean lib comp0 run_sim

clean:
	rm -rf modelsim.* transcript* *log* work *.wlf fcover* covhtml* fifo_cov* 
	clear

help:
	@echo ===============================================================================
	@echo " USAGE   	--  make target                             				"
	@echo " clean   	=>  clean the earlier log and intermediate files.       	"
	@echo " sv_cmp    	=>  Create library and compile the code.                   	"
	@echo " run_sim     =>  run the simulation in batch mode.                   	"
	@echo " run_test	=>  clean, compile & run the simulation in batch mode.		" 
	@echo ===============================================================================


