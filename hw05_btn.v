
module button (
	input		clk,
	input		rstn,
	input		clkCnt_1msEnd,
	input		in_btn,
	output		en_btn
);

	parameter BUT_EN_CNT = 100;

	reg		[7:0]	butPressCnt;
	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			butPressCnt <= 0;
		else if (~in_btn)
			butPressCnt <= 0;
		else if (clkCnt_1msEnd) begin
			if (butPressCnt == BUT_EN_CNT)
				butPressCnt <= BUT_EN_CNT;
			else
				butPressCnt <= butPressCnt + 1;
		end
	end

	assign en_btn = clkCnt_1msEnd & (butPressCnt == BUT_EN_CNT - 1);

endmodule
