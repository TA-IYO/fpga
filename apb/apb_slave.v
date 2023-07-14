module apb_slave #(parameter AWD=16, DWD=32, RWN=3'h2)
(
	input					resetn, pclk, 
	input		[AWD-1:0]	paddr,
	input					psel, penable, pwrite,
	input		[DWD-1:0]	pwdata,
	output		[DWD-1:0]	prdata,
	output	reg				pready,
	output					pslverr,
	
	output		[AWD-1:0]	addr,
	output	reg				wr,
	output		[DWD-1:0]	wdata,
	input		[DWD-1:0]	rdata	
);

localparam	IDLE = 2'b00;
localparam	SETUP = 2'b01;
localparam	ACCESS = 2'b10;
localparam	WAIT = 2'b11;

reg		[1:0]		curr_st;
reg		[1:0]		next_st;
reg		[2:0]		curr_cnt;

always @(posedge pclk, negedge resetn)
	if (!resetn)
		curr_st <= IDLE;
	else
		curr_st <= next_st;

always @(posedge pclk, negedge resetn)
	if (!resetn)
		curr_cnt <= 3'b0;
	else if (curr_st==IDLE)
		curr_cnt <= 3'b0;
	else if ((curr_st==SETUP) && (penable==1'b1) & (pwrite==1'b0))
		curr_cnt <= curr_cnt + 1'b1;

always @(curr_st, psel, penable, pwrite, curr_cnt)
begin
	pready = 1'b0;
	wr = 1'b0;
	next_st = IDLE; 
	case(curr_st)
		IDLE : begin
			if (psel) 
				next_st = SETUP;
		end
		SETUP : begin
			if (penable) begin
				if (pwrite) begin
					next_st = ACCESS;
					pready = 1'b1;
					wr = 1'b1;
				end
				else begin
					if (curr_cnt==RWN) begin
						next_st = ACCESS;
						pready = 1'b1;
					end						
					else begin
						next_st = SETUP;
					end
				end
			end
		end
		default : begin	//ACCESS
			next_st = IDLE;
		end
	endcase
end

assign addr = paddr;
assign wdata = pwdata;

assign prdata = rdata;
assign pslverr = 1'b0;

endmodule