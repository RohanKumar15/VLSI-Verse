class router_wr_seq extends uvm_sequence #(write_xtn);
`uvm_object_utils(router_wr_seq)

extern function new(string name="router_wr_seq");
endclass

function router_wr_seq::new(string name="router_wr_seq");
	super.new(name);
endfunction

	


class router_wr_seq_1 extends router_wr_seq;
`uvm_object_utils(router_wr_seq_1)
bit [1:0] addr;
extern function new(string name="router_wr_seq_1");
extern task body();
endclass

function router_wr_seq_1::new(string name ="router_wr_seq_1");
	super.new(name);
endfunction



task router_wr_seq_1::body();
if (!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal(get_type_name(),"wr_seq cannot get the addr")
	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {header[7:2]==14 &&
					header [1:0]==addr;});
	finish_item(req);
endtask

//class router_wr_seq_2 extends router_wr_seq;
//`uvm_object_utils(router_wr_seq_c2)
//extern function new(string name="wr_seq_2");
//extern task body();
//endclass

//function router_wr_seq_2::new(string name="wr_seq_2");
//	super.new(name);
//endfunction

//task router_wr_seq_c2::body();
//if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
//	`uvm_fatal(get_type_name(),"wr_seq","cannot get addr")
//	req2=write_xtn::type_id::create("req2");
//	start_item(req2);
//	assert (req2.randomize with {header [7:2]==50 &&
//					header [1:0]==addr;});
//	finish_item(req2);
//endtas
