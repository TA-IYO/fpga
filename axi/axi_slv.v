module axi_slv #(parameter AW=32, parameter DW=32)
(
	input					rstn, clk,
	
	input					awvalid,
	output	reg				awready,
	input		[AW-1:0]	awaddr,

	input					wvalid,
	output	reg				wready,
	input		[DW-1:0]	wdata,
	
	output	reg				bvalid,
	input					bready,
	output		[1:0]		bresp,

	input					arvalid,
	output	reg				arready,
	input		[AW-1:0]	araddr,

	output	reg				rvalid,
	input					rready,
	output		[DW-1:0]	rdata,
	output		[1:0]		rresp,
	
	output		[AW-1:0]	reg_addr,
	output		[DW-1:0]	reg_wdata,
	output					reg_wr,
	input		[DW-1:0]	reg_rdata
);

localparam S0=2'h0, S1=2'h1, S2=2'h2, S3=2'h3;

reg		[1:0]	aw_cs, aw_ns;
reg		[1:0]	w_cs, w_ns;
reg		[1:0]	b_cs, b_ns;
reg		[1:0]	ar_cs, ar_ns;
reg		[1:0]	r_cs, r_ns;

//AW-Channel
always @(posedge clk, negedge rstn)
	if (!rstn)
		aw_cs <= S0;
	else 
		aw_cs <= aw_ns;
		
always @(aw_cs, awvalid)
begin
	case (aw_cs)
		S0 : begin
			awready = 1'b0;
			if(awvalid)
				aw_ns = S1;
			else
				aw_ns = S0;
		end
		S1 : begin
			awready = 1'b1;
			aw_ns = S2;
		end
		default : begin
			awready = 1'b0;
			aw_ns = S0;
		end
	endcase
end

//W-Channel
always @(posedge clk, negedge rstn)
	if (!rstn)
		w_cs <= S0;
	else 
		w_cs <= w_ns;
		
always @(w_cs, wvalid)
begin
	case (w_cs)
		S0 : begin
			wready = 1'b0;
			if (wvalid)
				w_ns = S1;
			else
				w_ns = S0;
		end
		S1 : begin
			wready = 1'b1;
			w_ns = S2;
		end
		default : begin
			wready = 1'b0;
			w_ns = S0;
		end
	endcase
end

//B-Channel
always @(posedge clk, negedge rstn)
	if (!rstn)
		b_cs <= S0;
	else 
		b_cs <= b_ns;
		
always @(b_cs, wvalid, wready, bready)
begin
	case (b_cs)
		S0 : begin
			if(w_cs==S2) begin	//wvalid & wready) begin
				bvalid = 1'b1;
				if (bready)
					b_ns = S2;
				else
					b_ns = S1;
			end
			else begin
				bvalid = 1'b0;
				b_ns = S0;
			end			
		end
		S1 : begin
			bvalid = 1'b1;
			if (bready)
				b_ns = S2;
			else
				b_ns = S1;
		end
		default : begin
			bvalid = 1'b0;
			b_ns = S0;
		end
	endcase
end

//AR-Channel
always @(posedge clk, negedge rstn)
	if (!rstn)
		ar_cs <= S0;
	else 
		ar_cs <= ar_ns;
		
always @(ar_cs, arvalid)
begin
	case (ar_cs)
		S0 : begin
			if(arvalid) begin
				arready = 1'b0;
				ar_ns = S1;
			end
		end
		S1 : begin
			arready = 1'b1;
			ar_ns = S2;
		end
		default : begin
			arready = 1'b0;
			ar_ns = S0;
		end
	endcase
end

//R-Channel
always @(posedge clk, negedge rstn)
	if (!rstn)
		r_cs <= S0;
	else 
		r_cs <= r_ns;
		
always @(r_cs, arvalid, arready, rready)
begin
	case (r_cs)
		S0 : begin
			if (ar_cs==S2) begin//arvalid & arready) begin
				rvalid = 1'b1;
				if (rready)
					r_ns = S2;
				else
					r_ns = S1;
			end
			else
				r_ns = S0;
		end
		S1 : begin
			rvalid = 1'b1;
			if (rready)
				r_ns = S2;
			else
				r_ns = S1;
		end
		default : begin
			rvalid = 1'b0;
			r_ns = S0;
		end
	endcase
end

assign bresp = 2'b0;
assign rresp = 2'b0;

//
assign reg_addr = awvalid ? awaddr : araddr;
assign reg_wdata = wdata;
assign reg_wr = wvalid & wready;

assign rdata = reg_rdata;

endmodule	