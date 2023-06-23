class router_wr_drv extends uvm_driver #(write_xtn);
`uvm_component_utils(router_wr_drv)

virtual router_wr_if.WR_DRV_MP vif;
router_wr_agent_config w_cfg;

extern function new(string name="router_wr_drv",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_DUT(write_xtn xtn);
endclass

function router_wr_drv::new(string name="router_wr_drv",uvm_component parent);
	super.new(name,parent);
endfunction

function void router_wr_drv::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_wr_agent_config)::get(this,"","router_wr_agent_config",w_cfg))
		`uvm_fatal("DRV","cannot get config data")
	super.build_phase(phase);
endfunction

function void router_wr_drv::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=w_cfg.vif;
endfunction

task router_wr_drv::run_phase(uvm_phase phase);
	@(vif.wr_drv_cb);
	vif.wr_drv_cb.resetn<=0;
	@(vif.wr_drv_cb);
	vif.wr_drv_cb.resetn<=1;
	forever
		begin
			seq_item_port.get_next_item(req);
			send_to_DUT(req);
			seq_item_port.item_done();
		end
endtask

task router_wr_drv::send_to_DUT(write_xtn xtn);
	wait(~vif.wr_drv_cb.busy);
	@(vif.wr_drv_cb);
	vif.wr_drv_cb.pkt_valid<=1;
	vif.wr_drv_cb.data_in<=xtn.header;
	@(vif.wr_drv_cb);
	foreach (payload_data[i])
		begin
				wait(~vif.wr_drv_cb.busy);
				vif.wr_drv_cb.data_in<=xtn.payload_data[i];
				@(vif.wr_drv_cb);
		end
	wait(~vif.wr_drv_cb.busy);
	vif.wr_drv_cb.pkt_valid<=0;
	vif.wr_drv_cb.data_in<=xtn.parity;
	repeat(2)
	@(vif.wr_drv_cb);
endtask
	
