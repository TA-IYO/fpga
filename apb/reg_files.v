module reg_files #(parameter REG_BASE_ADDR=16'h0100, NUM=4)
(
	input					rstn, clk, 
	input		[15:0]		addr,
	input					wr,
	input		[31:0]		wdata,
	output		[31:0]		rdata,
	output      [2:0]       led0_rgb,
	output      [2:0]       led1_rgb
);

reg		[31:0]		regfiles [0:NUM-1];

integer	i;

wire	b_addr_en;

assign b_addr_en = (addr[15:4]==REG_BASE_ADDR[15:4]) ? 1'b1 : 1'b0;

always @(posedge clk, negedge rstn)
	if (!rstn)
		for (i=0; i<NUM; i=i+1)
			regfiles[i] <= {32{1'b0}};
	else if (b_addr_en & wr)
		regfiles[addr[$clog2(NUM)-1+2:2]] <= wdata;

//
assign rdata = b_addr_en ? regfiles[addr[$clog2(NUM)-1+2:2]] : 32'h12345678;

wire   [31:0]    t_r0, t_r1;

assign t_r0 = regfiles[0];
assign t_r1 = regfiles[1];

assign led0_rgb = t_r0[2:0];
assign led1_rgb = t_r1[2:0];

endmodule