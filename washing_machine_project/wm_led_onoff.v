

module wm_led_onoff (
	input			clk,	// 125Mhz
	input			rstn,
	input			ledEn,
	input			clkCnt_0p5secEnd,
	input	[7:0]		cnt,
	output reg		led_onoff
);

	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			led_onoff <= 0;
		else if (~ledEn)
			led_onoff <= 0;
		else if (clkCnt_0p5secEnd) begin
			if (cnt == 0)
				led_onoff <= 1;
			else if (cnt == 1)
				led_onoff <= 0;
		end	
	end

endmodule