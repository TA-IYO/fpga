
//`include "wm_fsim_def.v"

module wm_led_top (
	input			clk,	// 125Mhz
	input			reset,

	output			red_led_wash,
	output			red_led_rinse,
	output			red_led_dry,
	output			red_led_repeat,
	output			red_led_water_height,
	output			red_led_hot_cold,

	output			green_led_water_high,
	output			green_led_water_mid,
	output			green_led_water_low,

	output			green_led_hot_only,
	output			green_led_cold_only,
	output			green_led_hot_cold,

	input			but_in_left,
	input			but_in_right,

	output			pwm_buzzer
);

	wire rstn = ~reset;

`ifdef FSIM
    parameter CNT_1MSEC = 125;
`else
    parameter CNT_1MSEC = 125_000;
`endif

    parameter CNT_1SEC = 1000;
    parameter CNT_0P5SEC = 500;

    reg     [23:0]   clkCnt_1ms;
    wire clkCnt_1msEnd = (clkCnt_1ms == CNT_1MSEC - 1);
    wire clkCnt_0p5msEnd = (clkCnt_1ms == (CNT_1MSEC/2) - 1) | (clkCnt_1ms == CNT_1MSEC - 1);
    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            clkCnt_1ms <= 0;
        else if (clkCnt_1msEnd)
            clkCnt_1ms <= 0;
        else
            clkCnt_1ms <= clkCnt_1ms + 1;
    end


    reg     [23:0]   clkCnt_1sec;
    wire clkCnt_1secEnd = clkCnt_1msEnd & (clkCnt_1sec == CNT_1SEC - 1);
    wire clkCnt_0p5secEnd = clkCnt_1msEnd & 
			((clkCnt_1sec == CNT_1SEC - 1) | (clkCnt_1sec == CNT_0P5SEC - 1));

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            clkCnt_1sec <= 0;
		else if (clkCnt_1msEnd) begin
        	if (clkCnt_1secEnd)
            	clkCnt_1sec <= 0;
        	else
            	clkCnt_1sec <= clkCnt_1sec + 1;
		end
    end

	wire cntEn = clkCnt_0p5secEnd;
	wire [7:0] cntStartVal = 0;
	wire [7:0] cntEndVal = 2;

	//wire cntEn = clkCnt_1msEnd;
	//wire [7:0] cntStartVal = 3;
	//wire [7:0] cntEndVal = 9;

	reg		[7:0]	cnt;
    always @(posedge clk or negedge rstn) begin
        if (~rstn)
			cnt <= cntStartVal;
		else if (cntEn) begin
			if (cnt == cntEndVal)
				cnt <= cntStartVal;
			else
				cnt <= cnt + 1;
		end
	end


	//wm_led_onoff wm_led_onoff_wash  (clk, rstn, 1'b1, clkCnt_0p5secEnd, cnt, red_led_wash);
	//wm_led_onoff wm_led_onoff_rinse (clk, rstn, 1'b1, clkCnt_0p5secEnd, cnt, red_led_rinse);
	//wm_led_onoff wm_led_onoff_dry   (clk, rstn, 1'b1, clkCnt_0p5secEnd, cnt, red_led_dry);

	//assign red_led_repeat = 0;
	//assign red_led_water_height = 0;
	//assign red_led_hot_cold = 0;
	assign green_led_water_high = 1;
	assign green_led_water_mid = 1;
	assign green_led_water_low = 1;
	assign green_led_hot_only = 1;
	assign green_led_cold_only = 1;
	assign green_led_hot_cold = 1;
	

	wire but_enLeft;
	wire but_enRight;

	wm_but wm_but_left (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.but_in				(but_in_left		),
		.but_en				(but_enLeft			)
	);

	wm_but wm_but_right (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.but_in				(but_in_right		),
		.but_en				(but_enRight		)
	);


	reg		[2:0]	ledOnCnt;
	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			ledOnCnt <= 0;
		else if (but_enLeft) begin
			if (ledOnCnt == 0)
				ledOnCnt <= 0;
			else
				ledOnCnt <= ledOnCnt - 1;
		end
		else if (but_enRight) begin
			if (ledOnCnt == 5)
				ledOnCnt <= 5;
			else
				ledOnCnt <= ledOnCnt + 1;
		end
	end

	assign red_led_wash         = (ledOnCnt == 0) ? 1 : 0;
	assign red_led_rinse        = (ledOnCnt == 1) ? 1 : 0;
	assign red_led_dry          = (ledOnCnt == 2) ? 1 : 0;
	assign red_led_repeat       = (ledOnCnt == 3) ? 1 : 0;
	assign red_led_water_height = (ledOnCnt == 4) ? 1 : 0;
	assign red_led_hot_cold     = (ledOnCnt == 5) ? 1 : 0;

	// Buzzer

	wire buzStart = but_enRight | but_enLeft;

	wm_buzzer wm_buzzer (
		.clk					(clk					),
		.rstn					(rstn					),
		.buzStart				(buzStart				),
		.clkCnt_0p5msEnd		(clkCnt_0p5msEnd		),
		.buzOut					(pwm_buzzer				)
	);



endmodule