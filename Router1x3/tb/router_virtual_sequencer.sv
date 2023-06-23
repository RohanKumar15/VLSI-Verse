class router_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
`uvm_component_utils(router_virtual_sequencer)

router_wr_seqr wr_seqr[];
router_env_config cfg;
router_rd_seqr rd_seqr[];
extern function new(string name="router_virtual_sequencer",uvm_component parent);
extern function void build_phase (uvm_phase phase);
endclass

function router_virtual_sequencer::new(string name="router_virtual_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_virtual_sequencer::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",cfg))
		`uvm_fatal("CONFIG","cannot get config data");
	super.build_phase(phase);
	wr_seqr=new[cfg.no_of_wr];
	rd_seqr=new[cfg.no_of_rd];
endfunction



