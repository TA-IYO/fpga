`timescale		1ns/1ns

module tb #(parameter AW=32, parameter DW=32) ;

reg					rstn=1'b0, clk=1'b0;

wire				awvalid;
wire	[AW-1:0]	awaddr;

wire				wvalid;
wire	[DW-1:0]	wdata;

wire				bready;

wire				arvalid;
wire	[AW-1:0]	araddr;
wire				rready;

wire	[DW-1:0]	reg_rdata;
wire				reg_rvalid=1'bx;

wire				awready;
wire				wready;
wire				bvalid;
wire	[1:0]		bresp;
wire				arready;
wire				rvalid;
wire	[DW-1:0]	rdata;
wire	[1:0]		rresp;

wire	[AW-1:0]	reg_addr;
wire	[DW-1:0]	reg_wdata;
wire				reg_wr;
	
reg		[AW-1:0]	addr;
reg		[DW-1:0]	w_data;
reg					wcmd;
reg					rcmd;

wire	[DW-1:0]	r_data;
wire				done;
wire	[1:0]		rw_status;

//	
wire	[2:0]	led0_rgb, led1_rgb;


axi_slv #(.AW(AW), .DW(DW)) 
	inst_axi_slv (	
		.rstn, .clk,
		.awvalid, .awready, .awaddr,
		.wvalid, .wready, .wdata, 
		.bvalid, .bready, .bresp,
	    .arvalid, .arready, .araddr,
	    .rvalid, .rready, .rdata, .rresp,
		.reg_addr, .reg_wdata, .reg_wr, .reg_rdata
		//,.reg_rvalid 
);

reg_files  #(.REG_BASE_ADDR(16'h0100), .NUM(4))
	inst_reg_files (
		.rstn(rstn), 
		.clk(clk), 
		.addr(reg_addr),
		.wr(reg_wr),
		.wdata(reg_wdata),
		.rdata(reg_rdata),
		.led0_rgb(led0_rgb),
		.led1_rgb(led1_rgb)
);



axi_mst #(.AW(AW), .DW(DW))
	inst_axi_mst (
		.rstn, .clk,
		.addr, .w_data, .wcmd, .rcmd,
		.r_data, .done, .rw_status,		
		.awvalid, .awready, .awaddr,
		.wvalid, .wready, .wdata,
		.bvalid, .bready, .bresp,
		.arvalid, .arready, .araddr,
		.rvalid, .rready, .rdata, .rresp	
);

always #5 clk = ~clk;

initial
begin
	#20		rstn = 1'b1; 

	#5		addr=32'hxxxx_xxxx; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b0;

	#10		addr=32'h0000_0080; w_data=32'h2345_6789; wcmd=1'b1; rcmd=1'b0;
	#10 	addr=32'hxxxx_xxxx; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b0;
	#100;

	#10		addr=32'h0000_0100; w_data=32'h3456_789A; wcmd=1'b1; rcmd=1'b0;
	#10 	addr=32'hxxxx_xxxx; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b0;
	#100;
	
	#10		addr=32'h0000_0104; w_data=32'h4567_89AB; wcmd=1'b1; rcmd=1'b0;
	#10 	addr=32'hxxxx_xxxx; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b0;
	#100;
	
	#10		addr=32'h0000_0108; w_data=32'h5678_9ABC; wcmd=1'b1; rcmd=1'b0;
	#10 	addr=32'hxxxx_xxxx; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b0;
	#100;
	
	#10		addr=32'h0000_010C; w_data=32'h6789_ABCD; wcmd=1'b1; rcmd=1'b0;
	#10 	addr=32'hxxxx_xxxx; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b0;
	#100;
	
	#10		addr=32'h0000_0080; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b1;
	#10 	addr=32'hxxxx_xxxx; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b0;
	#100;
	
	#10		addr=32'h0000_0100; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b1;
	#10 	addr=32'hxxxx_xxxx; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b0;
	#100;
	
	#10		addr=32'h0000_0104; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b1;
	#10 	addr=32'hxxxx_xxxx; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b0;
	#100;
	
	#10		addr=32'h0000_0108; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b1;
	#10 	addr=32'hxxxx_xxxx; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b0;
	#100;
	
	#10		addr=32'h0000_010C; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b1;
	#10 	addr=32'hxxxx_xxxx; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b0;
	#100;
	
	#10		addr=32'hxxxxxxxx; w_data=32'hxxxx_xxxx; wcmd=1'b0; rcmd=1'b0;
	#100;

	#10 $stop;
end 

endmodule