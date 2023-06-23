class router_rd_drv extends uvm_driver #(read_xtn);
`uvm_component_utils(router_rd_drv)

virtual router_rd_if.RD_DRV_MP vif;
router_rd_agent_config r_cfg;

extern function new(string name="router_rd_drv",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_DUT(read_xtn xtn);
endclass

function router_rd_drv::new(string name="router_rd_drv",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_rd_drv::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_rd_agent_config)::get(this,"","router_rd_agent_config",r_cfg))
		`uvm_fatal("CONFIG","cannot get config data");
	super.build_phase(phase);
endfunction

function void router_rd_drv::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=r_cfg.vif;
endfunction

task router_rd_drv::run_phase(uvm_phase phase);
	forever
		begin
			seq_item_port.get_next_item(req);
			send_to_DUT(req);
			seq_item_port.item_done();
		end
endtask

task router_rd_drv::send_to_DUT(read_xtn xtn);
`uvm_info("Router_wr_drv",$sformatf("printing from drv",xtn.sprint()),UVM_LOW)

@(vif.rd_drv_cb);
	wait(vif.rd_drv_cb.vld_out)
	repeat(xtn.xtn_delay)
	@(vif.rd_drv_cb);
	vif.rd_drv_cb.read_enb<=1;
	
	wait(~vif.rd_drv_cb.vld_out)
	@(vif.rd_drv_cb);
	vif.rd_drv_cb.read_enb<=0;
endtask
