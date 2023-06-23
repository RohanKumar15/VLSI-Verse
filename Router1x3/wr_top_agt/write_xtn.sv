class write_xtn extends uvm_sequence_item;
`uvm_object_utils(write_xtn);

rand bit[7:0]header;
rand bit[7:0]payload_data[];
bit [7:0] parity;

constraint payload{payload_data.size ==header[7:2];}
constraint head{header[1:0]!=3;}
constraint headerdata{header[7:2]inside {[1:63]};}

extern function new(string name = "write_xtn");
extern function void do_print(uvm_printer printer);
extern function void post_randomize();
endclass

function write_xtn::new(string name = "write_xtn");
	super.new(name);
endfunction:new

function void  write_xtn::do_print (uvm_printer printer);
    
   
      printer.print_field( "header",this.header,8,UVM_BIN);
foreach(payload_data[i])
    printer.print_field( $sformatf("payload_data[%0d]",i), this.payload_data[i], 8,UVM_DEC);
    printer.print_field( "parity", this.parity,8,UVM_DEC);
   	
   endfunction
    
function void write_xtn::post_randomize();
	parity=header;
	foreach(payload_data[i])
		begin
		parity=payload_data[i]^parity;
		end
endfunction

