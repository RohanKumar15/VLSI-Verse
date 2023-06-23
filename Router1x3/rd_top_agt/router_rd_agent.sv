class router_rd_agent extends uvm_agent;
`uvm_component_utils(router_rd_agent)

router_rd_seqr rd_seqr;
router_rd_drv  rd_drv;
router_rd_mon rd_mon;
router_rd_agent_config r_cfg;

extern function new(string name="router_rd_agent",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass

function router_rd_agent::new(string name="router_rd_agent",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_rd_agent::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_rd_agent_config)::get(this,"","router_rd_agent_config",r_cfg))
		`uvm_fatal("rd_agent","cannot get config data");
	super.build_phase(phase);
	rd_mon=router_rd_mon::type_id::create("rd_mon",this);
	if(r_cfg.is_active==UVM_ACTIVE)
		begin
		rd_seqr=router_rd_seqr::type_id::create("rd_seqr",this);
		rd_drv=router_rd_drv::type_id::create("rd_drv",this);
		end
endfunction

function void router_rd_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	rd_drv.seq_item_port.connect(rd_seqr.seq_item_export);
endfunction

