module top;
        
        import APB_AHB_pkg::*;
        import uvm_pkg::*;
        bit clock;

        initial
               begin
                        clock = 1'b0;
                        forever #10 clock = ~clock;
                end
                
         ahb_if ahbif(clock);
         apb_if apbif(clock);

        rtl_top DUT(
            .Hclk(clock),
            .Hresetn(ahbif.Hresetn),
            .Htrans(ahbif.Htrans),
            .Hsize(ahbif.Hsize),
            .Hreadyin(ahbif.Hready_in),
            .Hwdata(ahbif.Hwdata),
            .Haddr(ahbif.Haddr),
            .Hwrite(ahbif.Hwrite),
            .Hrdata(ahbif.Hrdata),
            .Hresp(ahbif.Hresp),
            .Hreadyout(ahbif.Hready_out),
            .Pselx(apbif.Pselx),
            .Pwrite(apbif.Pwrite),
            .Penable(apbif.Penable),
            .Paddr(apbif.Paddr),
	    .Pwdata(apbif.Pwdata));
           
                initial
                        begin
                                uvm_config_db #(virtual ahb_if)::set(null, "*", "vif_ahb", ahbif);
                                uvm_config_db #(virtual apb_if)::set(null, "*", "vif_apb", apbif);
                                run_test();
                        end
endmodule
