class router_rd_agt_top extends uvm_env;
`uvm_component_utils(router_rd_agt_top)

router_env_config cfg;
router_rd_agent_config r_cfg[];
router_rd_agent r_ag[];

extern function new(string name="router_rd_agt_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function router_rd_agt_top::new(string name="router_rd_agt_top",uvm_component parent);
	super.new(name,parent);
endfunction 

function void router_rd_agt_top::build_phase(uvm_phase phase);
	r_cfg=new[cfg.no_of_destinations];
	r_ag=new[cfg.no_of_destinations];
	foreach(r_ag[i]) begin
	r_cfg[i]=cfg.r_cfg[i];
	r_ag[i]=router_rd_agent::type_id::create($sformatf("rd_agent[%0d]",i),this);
	end
endfunction
