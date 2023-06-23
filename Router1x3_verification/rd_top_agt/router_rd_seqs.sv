class router_rd_seqs  extends uvm_sequence #(read_xtn);
`uvm_object_utils(router_rd_seqs)

extern function new(string name="router_rd_seqs");
endclass

function router_rd_seqs::new(string name="router_rd_seqs");
	super.new(name);
endfunction

class router_rd_seqs_1  extends router_rd_seqs;
`uvm_object_utils(router_rd_seqs_1);
extern function new(string name="router_rd_seqs_1");
extern task body();
endclass

function router_rd_seqs_1::new(string name="router_rd_seqs_1");
	super.new(name);
endfunction


task router_rd_seqs_1::body();
	req=read_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {xtn_delay==30;});
	finish_item(req);
endtask

//class router_rd_seqs_2 extends router_rd_seqs;
//`uvm_object_utils (router_rd_seqs_2);
//extern function new(string name="rd_seqs_2");
//extern task body();
//endclass

//function router_rd_seqs_2::new(string name="rd_seqs_2");
//	super.new(name);
//endfunction

//task router_rd_seqs_c2::body();
//	req2=read_xtn::type_id::create("req2");
//	start_item(req2);
//	assert(req2.randomize with {xtn_delay<0 && xtn_delay>30;});
//	finish_item(req2);
//endtask
