
//`include "wm_fsim_def.v"

module wm_buzzer (
	input			clk,	// 125Mhz
	input			rstn,
	input			buzStart,
	input			clkCnt_0p5msEnd,
	output reg		buzOut
);

`ifdef FSIM
	parameter BUZ_TIME = 800;
`else
	parameter BUZ_TIME = (125_000_000/10);	// 0.1ms
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
			buzOut <= 0;
		else if (buzStart)
			buzOut <= 0;
		else if (buzCntEn) begin
			if (clkCnt_0p5msEnd)
				buzOut <= ~buzOut;
		end
		else
			buzOut <= 0;
	end

endmodule