interface router_rd_if (input bit clock);
logic read_enb;
logic vld_out;
logic [7:0] data_out;

modport RD_DRV_MP (clocking rd_drv_cb);
modport RD_MON_MP (clocking rd_mon_cb);

clocking rd_drv_cb@(posedge clock);
default input #1 output #1;
input vld_out;
output read_enb;
endclocking 

clocking rd_mon_cb@(posedge clock);
default input #1 output #1;
input read_enb;
input data_out;
endclocking 
endinterface
