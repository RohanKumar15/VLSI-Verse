interface apb_if (input bit clock);

        logic Penable, Pwrite, Presetn;

        logic [31:0] Prdata;

        logic [31:0] Pwdata;

        logic [31:0] Paddr;
      
        logic [3:0] Pselx;

        clocking apb_drv_cb @(posedge clock);
                default input #1 output #1;
                output Prdata;
                input Penable;
		input Paddr;
		input Pwdata;
                input Pwrite;
		input Presetn;
                input Pselx; 
        endclocking
       
        clocking apb_mon_cb @(posedge clock);
                default input #1 output #1;
                input Prdata;
                input Penable;
                input Pwrite;
                input Pselx;
                input Paddr;
                input Pwdata;
        endclocking

    modport APB_DRV_MP (clocking apb_drv_cb);
    modport APB_MON_MP (clocking apb_mon_cb);

endinterface
