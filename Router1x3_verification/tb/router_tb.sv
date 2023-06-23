class router_tb extends uvm_env;
`uvm_component_utils(router_tb);

router_env_config cfg;
router_scoreboard sb;
router_virtual_sequencer v_seqr;
router_wr_agt_top wr_agt_top[];
router_rd_agt_top rd_agt_top[];

extern function new(string name="router_tb",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

function router_tb::new(string name="router_tb",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_tb::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",cfg))
		`uvm_fatal("drv","cannot get config data");
	super.build_phase(phase);
	if(cfg.has_router_wr_agent)
	begin
	wr_agt_top=new[cfg.no_of_wr];
	foreach(wr_agt_top[i])
	begin
	
	wr_agt_top[i]=router_wr_agt_top::type_id::create($sformatf("wr_agt_top[%0d]",i),this);
	uvm_config_db #(router_wr_agent_config)::set(this,$sformatf("wr_agt_top[%0d]*",i),"router_wr_agent_config",cfg.w_cfg[i]);
	end
	end

if(cfg.has_router_rd_agent)
	 begin
	rd_agt_top=new[cfg.no_of_rd];
	foreach (rd_agt_top[i])
	begin
	
	rd_agt_top[i]=router_rd_agt_top::type_id::create($sformatf("rd_agt_top[%0d]",i),this);
	uvm_config_db #(router_rd_agent_config)::set(this,$sformatf("rd_agt_top[%0d]*",i),"router_rd_agent_config",cfg.r_cfg[i]);
	end
	end
super.build_phase(phase);


	if(cfg.has_virtual_sequencer)
		v_seqr=router_virtual_sequencer::type_id::create("v_seqr",this);
	if(cfg.has_router_scoreboard)
		sb=router_scoreboard::type_id::create("sb",this);

endfunction

function void router_tb::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	if(cfg.has_virtual_sequencer)
	begin
	if(cfg.has_router_wr_agent)
	foreach (wr_agt_top[i])
		v_seqr.wr_seqr[i]=wr_agt_top[i].wr_ag[i].wr_seqr;
	end
	if(cfg.has_router_rd_agent)
	begin
	foreach(rd_agt_top[i])
		v_seqr.rd_seqr[i]=rd_agt_top.rd_ag[i].rd_seqr;
	end
	if(cfg.has_router_scoreboard)
	begin
		wr_agt_top[0].wr_ag.wr_mon.ap_w.connect(sb.af_w.analysis_export);
		rd_agt_top[0].rd_ag.rd_mon.ap_r.connect(sb.af_r0.analysis_export);
		rd_agt_top[1].rd_ag.rd_mon.ap_r.connect(sb.af_r1.analysis_export);
		rd_agt_top[2].rd_ag.rd_mon.ap_r.connect(sb.af_r2.analysis_export);
	end
endfunction
	
