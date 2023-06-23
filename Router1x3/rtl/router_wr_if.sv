interface router_wr_if(input bit clock);
logic pkt_valid;
logic resetn;
logic busy;
logic err;
logic [7:0] data_in;

modport WR_DRV_MP (clocking wr_drv_cb);
modport WR_MON_MP (clocking wr_mon_cb);

clocking wr_drv_cb@(posedge clock);
default input #1 output #1;
output pkt_valid;
output data_in;
output resetn;
input busy;
endclocking

clocking wr_mon_cb@(posedge clock);
default input #1 output #1;
input data_in;
input err;
input resetn;
input busy;
input pkt_valid;
endclocking 

endinterface
