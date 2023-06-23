class router_wr_mon extends uvm_monitor;
`uvm_component_utils(router_wr_mon)

virtual router_wr_if.WR_MON_MP vif;
router_wr_agent_config w_cfg;
uvm_analysis_port #(write_xtn) ap_w;
write_xtn xtn;

extern function new(string name="router_wr_mon",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
endclass

function router_wr_mon::new(string name="router_wr_mon",uvm_component parent);
	super.new(name,parent);
	ap_w=new("ap_w",this);
endfunction

function void router_wr_mon::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_wr_agent_config)::get(this,"","router_wr_agent_config",w_cfg))
		`uvm_fatal("MON","cannot get config data")
	super.build_phase(phase);
endfunction

function void router_wr_mon::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	vif=w_cfg.vif;
endfunction

task router_wr_mon::run_phase(uvm_phase phase);
	forever
		collect_data();
endtask

task router_wr_mon::collect_data;
	write_xtn xtn;
	wait((vif.wr_mon_cb.pkt_valid)&&(~vif.wr_mon_cb.busy))
	xtn=write_xtn::type_id::create("write_xtn");
	xtn.header=vif.wr_mon_cb.data_in;
	xtn.payload_data=new[xtn.header[7:2]];
	@(vif.wr_mon_cb);
	foreach(xtn.payload_data[i])
		begin
				wait((~vif.wr_mon_cb.busy)&&(vif.wr_mon_cb.pkt_valid))
				xtn.payload_data[i]=vif.wr_mon_cb.data_in;
				@(vif.wr_mon_cb);
		end
	wait((~vif.w_mon_cb.busy)&&(~vif.w_mon_pkt_valid))
	xtn.parity=vif.wr_mon_cb.data_in;
	@(vif.wr_mon_cb);
	ap_w.write(xtn);
endtask
	

