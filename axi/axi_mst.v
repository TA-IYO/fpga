module axi_mst #(parameter AW=32, parameter DW=32)
(
	input					rstn, clk,
	
	input		[AW-1:0]	addr,
	input		[DW-1:0]	w_data,
	input					wcmd,
	input					rcmd,
	output	reg	[DW-1:0]	r_data,
	output	reg				done,
	output	reg	[1:0]		rw_status,
//
	output	reg				awvalid,
	input					awready,
	output	reg	[AW-1:0]	awaddr,

	output	reg				wvalid,
	input					wready,
	output	reg	[DW-1:0]	wdata,
	
	input					bvalid,
	output	reg				bready,
	input		[1:0]		bresp,

	output	reg				arvalid,
	input					arready,
	output	reg	[AW-1:0]	araddr,

	input					rvalid,
	output	reg				rready,
	input		[DW-1:0]	rdata,
	input		[1:0]		rresp	
);

localparam S0=2'h0, S1=2'h1, S2=2'h2, S3=2'h3;

reg		[1:0]	aw_cs, aw_ns;
reg		[1:0]	w_cs, w_ns;
reg		[1:0]	b_cs, b_ns;
reg		[1:0]	ar_cs, ar_ns;
reg		[1:0]	r_cs, r_ns;

reg				wr;
reg				rd;

always @(posedge clk, negedge rstn)
	if (!rstn) begin
		awaddr <= {AW{1'b0}};
		araddr <= {AW{1'b0}};
		wdata <= {DW{1'b0}}; 
		wr <= 1'b0;
		rd <= 1'b0;
	end
	else begin
		wr <= wcmd;
		rd <= rcmd;
		
		if (wcmd) begin
			awaddr <= addr;
			wdata <= w_data;
		end
		else if (rcmd)
			araddr <= addr;
	end
	
//AW-Channel
always @(posedge clk, negedge rstn)
	if (!rstn)
		aw_cs <= S0;
	else 
		aw_cs <= aw_ns;
		
always @(aw_cs, wr, awready)
begin
	case (aw_cs)
		S0 : begin
			if(wr) begin
				awvalid = 1'b1;
				if (awready)
					aw_ns = S2;
				else
					aw_ns = S1;
			end
			else 
                aw_ns = S0;
		end
		S1 : begin
			awvalid = 1'b1;
			if (awready)
				aw_ns = S2;
			else
				aw_ns = S1;
		end
		default : begin
			awvalid = 1'b0;
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
		
always @(w_cs, wr, wready)
begin
	case (w_cs)
		S0 : begin
			if(wr) begin
				wvalid = 1'b1;
				if (wready)
					w_ns = S2;
				else
					w_ns = S1;
			end
			else 
                w_ns = S0;
		end
		S1 : begin
			wvalid = 1'b1;
			if (wready)
				w_ns = S2;
			else
				w_ns = S1;
		end
		default : begin
			wvalid = 1'b0;
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
		
always @(b_cs, wvalid, wready, bvalid)
begin
	case (b_cs)
		S0 : begin
			if(wvalid & wready) begin
				if (bvalid) begin
					b_ns = S2;
					bready = 1'b1;
				end
				else begin
					b_ns = S1;
					bready = 1'b0;
				end
			end
			else 
                b_ns = S0;
		end
		S1 : begin
			bready = 1'b1;
			if (bvalid)
				b_ns = S2;
			else
				b_ns = S1;
		end
		default : begin
			bready = 1'b0;
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
		
always @(ar_cs, rd, arready)
begin
	case (ar_cs)
		S0 : begin
			if(rd) begin
				arvalid = 1'b1;
				if (arready)
					ar_ns = S2;
				else
					ar_ns = S1;
			end
			else 
                ar_ns = S0;
		end
		S1 : begin
			arvalid = 1'b1;
			if (arready)
				ar_ns = S2;
			else
				ar_ns = S1;
		end
		default : begin
			arvalid = 1'b0;
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
		
always @(r_cs, rvalid)
begin
	case (r_cs)
		S0 : begin
			if (rvalid) begin
				r_ns = S2;
				rready = 1'b1;
			end
			else begin
				r_ns = S1;
				rready = 1'b0;
			end
		end
		S1 : begin
			rready = 1'b1;
			if (rvalid)
				r_ns = S2;
			else
				r_ns = S1;
		end
		default : begin
			rready = 1'b0;
			r_ns = S0;
		end
	endcase
end

//Done_check
always @(posedge clk, negedge rstn)
	if (!rstn) begin
		done <= 1'b1;
		rw_status <= 2'b0;
	end
	else if (wr | rd)
		done <= 1'b0;
	else if (bvalid & bready) begin
		done <= 1'b1;
		rw_status <= bresp;
	end
	else if (rvalid & rready) begin
		done <= 1'b1;
		rw_status <= rresp;
		r_data <= rdata;
	end	
endmodule	
/*module axi_mst #(parameter AW=32, parameter DW=32)
(
	input					rstn, clk,
	
	input		[AW-1:0]	addr,
	input		[DW-1:0]	w_data,
	input					wcmd,
	input					rcmd,
	output	reg	[DW-1:0]	r_data,
	output	reg				done,
	output	reg	[1:0]		rw_status,
//
	output	reg				awvalid,
	input					awready,
	output	reg	[AW-1:0]	awaddr,

	output	reg				wvalid,
	input					wready,
	output	reg	[DW-1:0]	wdata,
	
	input					bvalid,
	output	reg				bready,
	input		[1:0]		bresp,

	output	reg				arvalid,
	input					arready,
	output	reg	[AW-1:0]	araddr,

	input					rvalid,
	output	reg				rready,
	input		[DW-1:0]	rdata,
	input		[1:0]		rresp	
);

localparam S0=2'h0, S1=2'h1, S2=2'h2, S3=2'h3;

reg		[1:0]	aw_cs, aw_ns;
reg		[1:0]	w_cs, w_ns;
reg		[1:0]	b_cs, b_ns;
reg		[1:0]	ar_cs, ar_ns;
reg		[1:0]	r_cs, r_ns;

reg				wr;
reg				rd;

always @(posedge clk, negedge rstn)
	if (!rstn) begin
		awaddr <= {AW{1'b0}};
		araddr <= {AW{1'b0}};
		wdata <= {DW{1'b0}}; 
	end
	else begin
		wr <= wcmd;
		rd <= rcmd;
		
		if (wcmd) begin
			awaddr <= addr;
			wdata <= w_data;
		end
		else if (rcmd)
			araddr <= addr;
	end
	
//AW-Channel
always @(posedge clk, negedge rstn)
	if (!rstn)
		aw_cs <= S0;
	else 
		aw_cs <= aw_ns;
		
always @(aw_cs, wr, awready)
begin
	case (aw_cs)
		S0 : begin
			if(wr) begin
				awvalid = 1'b1;
				if (awready)
					aw_ns = S2;
				else
					aw_ns = S1;
			end
		end
		S1 : begin
			awvalid = 1'b1;
			if (awready)
				aw_ns = S2;
			else
				aw_ns = S1;
		end
		default : begin
			awvalid = 1'b0;
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
		
always @(w_cs, wr, wready)
begin
	case (w_cs)
		S0 : begin
			if(wr) begin
				wvalid = 1'b1;
				if (wready)
					w_ns = S2;
				else
					w_ns = S1;
			end
		end
		S1 : begin
			wvalid = 1'b1;
			if (wready)
				w_ns = S2;
			else
				w_ns = S1;
		end
		default : begin
			wvalid = 1'b0;
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
		
always @(b_cs, wvalid, wready, bvalid)
begin
	case (b_cs)
		S0 : begin
			if(wvalid & wready) begin
				if (bvalid) begin
					b_ns = S2;
					bready = 1'b1;
				end
				else begin
					b_ns = S1;
					bready = 1'b0;
				end
			end
		end
		S1 : begin
			bready = 1'b1;
			if (bvalid)
				b_ns = S2;
			else
				b_ns = S1;
		end
		default : begin
			bready = 1'b0;
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
		
always @(ar_cs, rd, arready)
begin
	case (ar_cs)
		S0 : begin
			if(rd) begin
				arvalid = 1'b1;
				if (arready)
					ar_ns = S2;
				else
					ar_ns = S1;
			end
		end
		S1 : begin
			arvalid = 1'b1;
			if (arready)
				ar_ns = S2;
			else
				ar_ns = S1;
		end
		default : begin
			arvalid = 1'b0;
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
		
always @(r_cs, rvalid)
begin
	case (r_cs)
		S0 : begin
			if (rvalid) begin
				r_ns = S2;
				rready = 1'b1;
			end
			else begin
				r_ns = S1;
				rready = 1'b0;
			end
		end
		S1 : begin
			rready = 1'b1;
			if (rvalid)
				r_ns = S2;
			else
				r_ns = S1;
		end
		default : begin
			rready = 1'b0;
			r_ns = S0;
		end
	endcase
end

//Done_check
always @(posedge clk, negedge rstn)
	if (!rstn) begin
		done <= 1'b1;
		rw_status <= 2'b0;
	end
	else if (wr | rd)
		done <= 1'b0;
	else if (bvalid & bready) begin
		done <= 1'b1;
		rw_status <= bresp;
	end
	else if (rvalid & rready) begin
		done <= 1'b1;
		rw_status <= rresp;
		r_data <= rdata;
	end	
endmodule	
*/