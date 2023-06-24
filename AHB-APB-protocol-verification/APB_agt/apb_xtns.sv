class apb_xtns extends uvm_sequence_item;

        `uvm_object_utils(apb_xtns)

        logic Pclk, Penable, Pwrite, Presetn;
      
        rand logic [31:0] Prdata;
       
        logic [31:0] Pwdata;
       
        logic [31:0] Paddr;
       
        logic [3:0] Pselx;

        extern function void do_print(uvm_printer printer);
endclass

function void apb_xtns::do_print(uvm_printer printer);
        super.do_print(printer);

        printer.print_field("Paddr", this.Paddr, 32, UVM_HEX);
        printer.print_field("Penable", this.Penable, 1, UVM_DEC);
        printer.print_field("Pwrite", this.Pwrite, 1, UVM_DEC);
        printer.print_field("Pselx", this.Pselx, 1, UVM_DEC);
        printer.print_field("Prdata", this.Prdata, 32, UVM_HEX);

endfunction
