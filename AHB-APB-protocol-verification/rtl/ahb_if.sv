interface ahb_if(input bit clock);

                logic Hresetn, Hwrite;
            
                logic [2:0] Hsize;
                
                logic [1:0] Htrans;

                logic Hready_in;
              
                logic Hready_out;

                logic [31:0] Haddr;
               
                logic [2:0] Hburst;

                logic [1:0] Hresp;

                logic [31:0] Hwdata;
               
                logic [31:0] Hrdata;


        clocking ahb_drv_cb@(posedge clock);
                default input #1 output #1;
                                output Hwrite;
                                output Hready_in;
				output Hwdata;
                                output Haddr;
                                output Htrans;
                                output Hburst;
                                output Hresetn;
                                output Hsize;
                                input Hready_out;
        endclocking


        clocking ahb_mon_cb@(posedge clock);
                default input #1 output #1;
                                input Hwrite;
                                input Hready_in;
                                input Hwdata;
                                input Haddr;
                                input Htrans;
                                input Hburst;
                                input Hresetn;
                                input Hsize;
                                input Hready_out;
        endclocking


        modport AHB_DRV_MP (clocking ahb_drv_cb);
        modport AHB_MON_MP (clocking ahb_mon_cb);

endinterface 
