class router_virtual_sequence extends uvm_sequence #(uvm_sequence_item);
`uvm_object_utils(router_virtual_sequence)
router_virtual_sequencer v_seqr;
router_wr_seqr wr_seqr[];
router_rd_seqr rd_seqr[];
router_env_config cfg;

router_wr_seq_1 wr_seq1;
router_rd_seqs_1 rd_seqs1;

extern function new(string name="router_virtual_sequence");
extern task body();
endclass

function router_virtual_sequence::new(string name="router_virtual_sequence");
	super.new(name);
endfunction

task router_virtual_sequence::body();
	if(!uvm_config_db#(router_env_config) ::get(null,get_full_name(),"router_env_config",cfg))
		`uvm_fatal("virtual_sequence","cannot get cfg");
      	assert($cast(v_seqr,m_sequencer));
	wr_seqr=new[cfg.no_of_wr];
	rd_seqr=new[cfg.no_of_rd];
	begin
	`uvm_error("virtual_sequence","cannot get m_sequence to v_seqr");
	end
	foreach(wr_seqr[i])
		wr_seqr[i]=v_seqr.wr_seqr[i];
	foreach(rd_seqr[i])
		rd_seqr[i]=v_seqr.rd_seqr[i];
endtask

class router_virtual_sequence_1 extends router_virtual_sequence;
`uvm_object_utils(router_virtual_sequence_1);

extern function new(string name="router_virtual_sequence_1");
extern task body();

endclass

function router_virtual_sequence_1::new(string name="router_virtual_sequence_1");
	super.new(name);
endfunction

task router_virtual_sequence_1::body();
bit [1:0] addr;
	uvm_config_db #(bit [1:0])::get(null,get_full_name(),"bit[1:0]",addr);
	super.body();
	
	wr_seq1=router_wr_seq_1::type_id::create("wr_seq1");
	rd_seqs1=router_rd_seqs_1::type_id::create("rd_seqs1");
	fork
		begin
		wr_seq1.start(wr_seqr[0]);
		end
		begin
		if (addr==2'b00)
		rd_seqs1.start(rd_seqr[0]);
		if (addr==2'b01)
		rd_seqs1.start(rd_seqr[1]);
		if (addr==2'b10)
		rd_seqs1.start(rd_seqr[2]);
		end
	join
endtask

