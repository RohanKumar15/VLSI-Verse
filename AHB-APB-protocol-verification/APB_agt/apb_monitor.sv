class apb_monitor extends uvm_monitor;

        `uvm_component_utils (apb_monitor)

        virtual apb_if.APB_MON_MP vif;
        apb_xtns xtn;
        apb_config apb_cfg;
        uvm_analysis_port #(apb_xtns) apb;

        extern function new(string name = "apb_monitor", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task collect_data();

endclass

function apb_monitor::new(string name = "apb_monitor", uvm_component parent);
        super.new(name,parent);
        apb = new("apb", this);
endfunction

function void apb_monitor::build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(apb_config)::get(this, "", "apb_config", apb_cfg))
                `uvm_fatal("apb_monitor", "cannot get the config file")

endfunction

function void apb_monitor::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = apb_cfg.aif;
endfunction

task apb_monitor::run_phase(uvm_phase phase);
        forever
                begin
                        collect_data();
                end
endtask

task apb_monitor::collect_data();
        apb_xtns xtn;
        xtn = apb_xtns::type_id::create("xtn");

        wait(vif.apb_mon_cb.Penable)
                xtn.Paddr = vif.apb_mon_cb.Paddr;
                xtn.Pwrite = vif.apb_mon_cb.Pwrite;
		 xtn.Pselx = vif.apb_mon_cb.Pselx;

        if(xtn.Pwrite == 1)
		xtn.Pwdata = vif.apb_mon_cb.Pwdata; 
        else
                xtn.Prdata = vif.apb_mon_cb.Prdata;

        @(vif.apb_mon_cb); 

        apb.write(xtn);

        `uvm_info("apb_monitor", "Displaying apb_monitor data", UVM_LOW)

        apb_cfg.mon_data_count++;
endtask

