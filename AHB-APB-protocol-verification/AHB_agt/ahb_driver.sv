class ahb_driver extends uvm_driver#(ahb_xtns);

        `uvm_component_utils (ahb_driver)
        virtual ahb_if.AHB_DRV_MP vif;

        ahb_xtns xtn;
        ahb_config ahb_cfg;

        extern function new(string name = "ahb_driver", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task send_to_dut(ahb_xtns xtn);

endclass

function ahb_driver::new(string name = "ahb_driver", uvm_component parent);
        super.new(name,parent);
endfunction

function void ahb_driver::build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(ahb_config)::get(this, "", "ahb_config", ahb_cfg))
                `uvm_fatal("ahb_driver", "cannot get the config file")

endfunction

function void ahb_driver::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = ahb_cfg.aif;
endfunction

task ahb_driver::run_phase(uvm_phase phase);

        @(vif.ahb_drv_cb);
        vif.ahb_drv_cb.Hresetn <= 1'b0;

        repeat(2)
        @(vif.ahb_drv_cb);
        vif.ahb_drv_cb.Hresetn <= 1'b1;

        forever
                begin
                        seq_item_port.get_next_item(req);
                        send_to_dut(req);
                        seq_item_port.item_done();
                end
endtask

task ahb_driver::send_to_dut(ahb_xtns xtn);

        vif.ahb_drv_cb.Hwrite  <= xtn.Hwrite;
        vif.ahb_drv_cb.Htrans <= xtn.Htrans;
        vif.ahb_drv_cb.Hsize   <= xtn.Hsize;
        vif.ahb_drv_cb.Haddr   <= xtn.Haddr;
	vif.ahb_drv_cb.Hburst <= xtn.Hburst;
        vif.ahb_drv_cb.Hready_in <= 1'b1; //Hreadyin will always be high indicating to slave that Master is ready to send

        @(vif.ahb_drv_cb);

        wait(vif.ahb_drv_cb.Hready_out)
                vif.ahb_drv_cb.Hwdata<=xtn.Hwdata;

        //`uvm_info("AHB_DRIVER", "Displaying ahb_driver data", UVM_LOW)
        //xtn.print();
        ahb_cfg.drv_data_count++;

endtask

