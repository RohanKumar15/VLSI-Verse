class ahb_xtns extends uvm_sequence_item;

        `uvm_object_utils(ahb_xtns)

	extern function void do_print(uvm_printer printer);

        logic Hclk;
	logic Hresetn;
        rand logic Hwrite; 
        rand logic [2:0] Hsize;
        rand logic [1:0] Htrans;
        logic Hready_in;
        logic Hready_out;
        rand logic [31:0] Haddr;
        rand logic [2:0] Hburst;
        logic [1:0] Hresp;
        rand logic [31:0] Hwdata;
        logic [31:0] Hrdata; 
	rand logic [7:0] length;

                constraint valid_size {Hsize inside {[0:2]};}
			
                constraint valid_length {(2**Hsize) * length <= 1024;}

                constraint valid_haddr {Hsize == 1 -> Haddr % 2 == 0;
                                                                Hsize == 2 -> Haddr % 2 == 0;}
                constraint valid_haddr1 {Haddr inside {[32'h8000_0000 : 32'h8000_03ff],
                                               [32'h8400_0000 : 32'h8400_03ff],
                                               [32'h8800_0000 : 32'h8800_03ff],
                                               [32'h8c00_0000 : 32'h8c00_03ff]};}
endclass

function void ahb_xtns::do_print(uvm_printer printer);
        super.do_print(printer);

        printer.print_field("Haddr", this.Haddr, 32, UVM_HEX);
        printer.print_field("Hwdata", this.Hwdata, 32, UVM_HEX);
        printer.print_field("Hready_in", this.Hready_in, 1, UVM_DEC);
        printer.print_field("Hwrite", this.Hwrite, 1, UVM_DEC);
        printer.print_field("Htrans", this.Htrans, 2, UVM_DEC);
        printer.print_field("Hburst", this.Hburst, 3, UVM_DEC);
endfunction
