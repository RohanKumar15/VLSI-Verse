class router_wr_agent extends uvm_agent;
`uvm_component_utils(router_wr_agent)

router_wr_drv wr_drv;
router_wr_mon wr_mon;
router_wr_agent_config w_cfg;
router_wr_seqr wr_seqr;



extern function new(string name="router_wr_agent",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass

function router_wr_agent::new(string name="router_wr_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_wr_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_wr_agent_config)::get(this,"","router_wr_agent_config",w_cfg))
		`uvm_fatal("router_wr_agent_config","cannot get config data");
	super.build_phase(phase);
	wr_mon=router_wr_mon::type_id::create("wr_mon",this);
	if(w_cfg.is_active==UVM_ACTIVE)
		begin
		wr_seqr=router_wr_seqr::type_id::create("wr_seqr",this);
		wr_drv=router_wr_drv::type_id::create("wr_drv",this);
		end
endfunction

function void router_wr_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(wr_cfg.is_active==UVM_ACTIVE)
	begin
	wr_drv.seq_item_port.connect(wr_seqr.seq_item_export);
	end
endfunction

