class router_scoreboard extends uvm_scoreboard;
`uvm_component_utils(router_scoreboard)

uvm_tlm_analysis_fifo#(write_xtn) af_w;
uvm_tlm_analysis_fifo#(read_xtn) af_r0;
uvm_tlm_analysis_fifo#(read_xtn) af_r1;
uvm_tlm_analysis_fifo#(read_xtn) af_r2;

write_xtn xtnh;
read_xtn xtnh1;

extern function new(string name="router_scoreboard",uvm_component parent);
extern task run_phase(uvm_phase phase);
extern task check(read_xtn xtnh1, write_xtn xtnh);
endclass

function router_scoreboard::new(string name="router_scoreboard",uvm_component parent);
	super.new(name,parent);
	af_w=new("af_w",this);
	af_r0=new("af_r0",this);
	af_r1=new("af_r1",this);
	af_r2=new("af_r2",this);
endfunction

task router_scoreboard::run_phase(uvm_phase phase);
	fork
			begin
			af_w.get(xtnh);
			end

			begin
			fork
			 af_r0.get(xtnh1);
			
			 af_r1.get(xtnh1);
			
			 af_r2.get(xtnh1);
			
			join_any
			disable fork;
			end
	join
endtask

task router_scoreboard::check(read_xtn xtnh1,write_xtn xtnh);
	if(xtnh.header==xtnh1.header)
	begin
	$display("----------header is Success----------");
	end	
		if(xtnh.payload_data==xtnh1.payload_data)
		begin 
		$display("------Payload_data is success--------");
		end
		
			if(xtnh.parity==xtnh1.parity);
			begin
			$display("---------Parity is success-------");
			end
		
endtask
