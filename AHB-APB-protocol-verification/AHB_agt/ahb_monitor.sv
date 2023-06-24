class ahb_monitor extends uvm_monitor;

        `uvm_component_utils (ahb_monitor)
        virtual ahb_if.AHB_MON_MP vif;

        ahb_xtns xtn;
        ahb_config ahb_cfg;

        uvm_analysis_port #(ahb_xtns) ahb;

        extern function new(string name = "ahb_monitor", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task collect_data();

endclass

function ahb_monitor::new(string name = "ahb_monitor", uvm_component parent);
        super.new(name,parent);
        ahb = new("ahb", this);
endfunction

function void ahb_monitor::build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(ahb_config)::get(this, "", "ahb_config", ahb_cfg))
                `uvm_fatal("ahb_monitor", "cannot get the config file")
endfunction

function void ahb_monitor::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = ahb_cfg.aif;
endfunction

task ahb_monitor::run_phase(uvm_phase phase);
        forever
                begin
                        collect_data();
                end
endtask

task ahb_monitor::collect_data();
 
        xtn = ahb_xtns::type_id::create("xtn");

        wait(vif.ahb_mon_cb.Hready_out && (vif.ahb_mon_cb.Htrans == 2'b10 || vif.ahb_mon_cb.Htrans == 2'b11))
         xtn.Htrans = vif.ahb_mon_cb.Htrans;
         xtn.Hwrite = vif.ahb_mon_cb.Hwrite;
         xtn.Hsize  = vif.ahb_mon_cb.Hsize;
         xtn.Haddr  = vif.ahb_mon_cb.Haddr;
         xtn.Hburst = vif.ahb_mon_cb.Hburst;

        @(vif.ahb_mon_cb);

        wait(vif.ahb_mon_cb.Hready_out && (vif.ahb_mon_cb.Htrans == 2'b10 || vif.ahb_mon_cb.Htrans == 2'b11))
		if(Hwrite==1)
                xtn.Hwdata = vif.ahb_mon_cb.Hwdata;
		else
		xtn.Hrdata = vif.ahb_mon_cb.Hrdata;

        ahb.write(xtn); //To SB
        //`uvm_info("AHB_MONITOR", "Displaying ahb_monitor data", UVM_LOW)
        ahb_cfg.mon_data_count++;

endtask
