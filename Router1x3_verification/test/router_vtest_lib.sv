class router_test extends uvm_test;
`uvm_component_utils(router_test)

router_env_config cfg;
router_wr_agent_config w_cfg[i];
router_rd_agent_config r_cfg[];
int no_of_wr=1;
int no_of_rd=3;
int has_router_scoreboard=1;
int has_router_virtual_sequencer=1;
router_tb env;
int has_router_rd_agent=1;
int has_router_wr_agent=1;

extern function new(string name="router_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void  config_router();

endclass

function router_test:: new(string name="router_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_test::config_router();
if(has_router_rd_agent)
r_cfg=new[no_of_rd];
r_cfg=router_rd_agent_config::type_id::create("r_cfg",this);
if(!uvm_config_db #(virtual router_rd_if)::get(this,"","vif_rd",r_cfg.vif)
`uvm_fatal("CONFIG","cannot get vif to r_cfg")
r_cfg.is_active=UVM_ACTIVE;
cfg.r_cfg=r_cfg;

if(has_router_wr_agent)
w_cfg=new[no_of_wr];
foreach(w_cfg[i])
w_cfg[i]=router_wr_agent_config::type_id::create($sformatf("w_cfg[%0d]",i),this);
if(!uvm_config_db #(virtual router_wr_if)::get(this,"","vif_wr",w_cfg[i].vif))
`uvm_fatal("router_test","cannot get vif to w_cfg")
w_cfg[i].is_active=UVM_ACTIVE;
cfg.w_cfg[i]=w_cfg[i];
endfunction

function void router_test:: build_phase(uvm_phase phase);
cfg=router_env_config::type_id::create("cfg",this);
if(cfg.has_router_wr_agent)
cfg.w_cfg=new[no_of_wr];
if(cfg.has_rd_agent)
cfg.r_cfg=new[no_of_rd];
config_router();

env=router_tb::type_id::create("env",this);
uvm_config_db #(router_env_config)::set(this,"env*","router_env_config",cfg);
super.build_phase(phase);
endfunction


class router_test_1 extends router_test;
`uvm_component_utils(router_test_1)

router_virtual_sequence_1 v_seq;
bit [1:0] addr;

extern function new(string name="router_test_1",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function router_test_1:: new(string name="router_test_1",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_test_1::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction		

task router_test_1::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(10)
	begin
	addr={$random} %3;
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",addr);
	v_seq=router_virtual_sequence_1::type_id::create("v_seq");
	v_seq.start(env.v_seqr);
	end
	phase.drop_objection(this);
endtask

