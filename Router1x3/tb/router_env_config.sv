class router_env_config extends uvm_object;

`uvm_object_utils(router_env_config);

bit has_functional_coverage=0;
bit  no_of_wr=1;
bit  no_of_rd=3;
bit  has_router_scoreboard=1;
bit  has_router_virtual_sequencer=1;

router_wr_agent_config w_cfg[];
router_rd_agent_config r_cfg[];

bit has_router_wr_agent=1;
bit has_router_rd_agent=1;

extern function new(string name="router_env_config");

endclass

function router_env_config::new(string name="router_env_config");
	super.new(name);
endfunction
