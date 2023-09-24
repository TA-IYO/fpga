
module buzzer (
	input			   clk,
	input			   rstn,
	input			   buzStart,
	input			   in_freq,
	output     reg	   out_buz
);
//`define FSIM
`ifdef FSIM
	parameter BUZ_TIME = 3000;
`else
	parameter BUZ_TIME = 125_000_000;
`endif
	
	reg				buzCntEn;
	reg		[31:0]	buzCnt;
	wire buzCntEnd = buzCntEn & (buzCnt == BUZ_TIME);

	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			buzCntEn <= 0;
		else if (buzStart)
			buzCntEn <= 1;
		else if (buzCntEnd)
			buzCntEn <= 0;
	end

	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			buzCnt <= 0;
		else if (buzStart)
			buzCnt <= 1;
		else if (buzCntEn)
			buzCnt <= buzCnt + 1;
	end

	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			out_buz <= 0;
		else if (buzStart)
			out_buz <= 0;
		else if (buzCntEn) begin
			if (in_freq)
			out_buz <= ~out_buz;
		end
		else
			out_buz <= 0;
	end

endmodule
