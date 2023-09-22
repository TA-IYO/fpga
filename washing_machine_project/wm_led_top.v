
`include "wm_fsim_def.v"

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
	input			but_in_up,
	input			but_in_down,

	output			pwm_buzzer,

	output	[7:0]	fnd_data,
	output	[2:0]	fnd_dig,

	output			us_sensor_trig,
	input			us_sensor_echo
);

/*
	wire clk50mhz;
	wire clk200mhz;

	wm_pll wm_pll (
  		.clk_out1	(clk50mhz),
  		.clk_out2	(clk200mhz),
  		.reset		(reset),
  		.locked		(),
  		.clk_in1	(clk)	
 	);
*/

	wire rstn = ~reset;

`ifdef FSIM
    parameter CNT_1MSEC = 125;
    parameter CNT_50M_1MSEC = 50;
`else
    parameter CNT_1MSEC = 125_000;
    parameter CNT_50M_1MSEC = 50_000;
`endif

    parameter CNT_1SEC = 1000;
    parameter CNT_0P5SEC = 500;

	/*
    reg     [23:0]   clkCnt50m_1ms;
    wire clkCnt50m_1msEnd = (clkCnt50m_1ms == CNT_50M_1MSEC - 1);
    always @(posedge clk50mhz or negedge rstn) begin
        if (~rstn)
            clkCnt50m_1ms <= 0;
        else if (clkCnt50m_1msEnd)
            clkCnt50m_1ms <= 0;
        else
            clkCnt50m_1ms <= clkCnt50m_1ms + 1;
    end
	*/

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
	//assign green_led_water_high = 1;
	//assign green_led_water_mid = 1;
	//assign green_led_water_low = 1;
	//assign green_led_hot_only = 1;
	//assign green_led_cold_only = 1;
	//assign green_led_hot_cold = 1;
	

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

	wire but_enUp;
	wire but_enDown;

	wm_but wm_but_up (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.but_in				(but_in_up			),
		.but_en				(but_enUp			)
	);

	wm_but wm_but_down (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.but_in				(but_in_down		),
		.but_en				(but_enDown			)
	);


	/*
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
	*/

	/*
	assign red_led_wash         = (ledOnCnt == 0) ? 1 : 0;
	assign red_led_rinse        = (ledOnCnt == 1) ? 1 : 0;
	assign red_led_dry          = (ledOnCnt == 2) ? 1 : 0;
	assign red_led_repeat       = (ledOnCnt == 3) ? 1 : 0;
	assign red_led_water_height = (ledOnCnt == 4) ? 1 : 0;
	assign red_led_hot_cold     = (ledOnCnt == 5) ? 1 : 0;
	*/

	// Buzzer

	wire buzStart = but_enRight | but_enLeft | but_enUp | but_enDown;

	wm_buzzer wm_buzzer (
		.clk					(clk					),
		.rstn					(rstn					),
		.buzStart				(buzStart				),
		.clkCnt_0p5msEnd		(clkCnt_0p5msEnd		),
		.buzOut					(pwm_buzzer				)
	);

	// Set control panel
	
	wire [7:0] fndVal_ctrl;

	wm_ctrl wm_ctrl (
		.clk						(clk						),
		.rstn						(rstn						),
		.butEn_up					(but_enUp					),
		.butEn_down					(but_enDown					),
		.butEn_left					(but_enLeft					),
		.butEn_right				(but_enRight				),
		.red_led_wash				(red_led_wash				),
		.red_led_rinse				(red_led_rinse				),
		.red_led_dry				(red_led_dry				),
		.red_led_repeat				(red_led_repeat				),
		.red_led_water_height		(red_led_water_height		),
		.red_led_hot_cold			(red_led_hot_cold			),
		.green_led_water_high		(green_led_water_high		),
		.green_led_water_mid		(green_led_water_mid		),
		.green_led_water_low		(green_led_water_low		),
		.green_led_hot_only			(green_led_hot_only			),
		.green_led_cold_only		(green_led_cold_only		),
		.green_led_hot_cold			(green_led_hot_cold			),
		.fndVal_ctrl				(fndVal_ctrl				)
	);

	// US Sensor
	
	wire			usDistChkEn = 1;
	wire			usDistEn;
	wire	[7:0]	usDist;

	wm_us_ctrl wm_us_ctrl (
		.clk						(clk						),
		.rstn						(rstn						),
		.distChkEn					(usDistChkEn				),
		.clkCnt_1msEnd				(clkCnt_1msEnd				),
		.usEcho						(us_sensor_echo				),
		.usTrig						(us_sensor_trig				),
		.usDistEn					(usDistEn					),
		.usDist						(usDist						)
	);

	// FND

	//wire [11:0] fndValIn = fndVal_ctrl;
	//wire [11:0] fndValIn = usDist;
	wire [11:0] fndValIn = (red_led_water_height)? usDist : fndVal_ctrl;


	wm_fnd_ctrl wm_fnd_ctrl (
		.clk					(clk),
		.rstn					(rstn),
		.clkCnt_1msEnd			(clkCnt_1msEnd),
		.fndValIn				(fndValIn),
		.seg7_data				(fnd_data),
		.seg7_dig				(fnd_dig)
	);

endmodule
