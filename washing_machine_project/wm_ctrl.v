
`define TIME_INIT_WASH		10
`define TIME_MAX_WASH		40
`define TIME_INT_WASH		8

`define TIME_INIT_RINSE		10
`define TIME_MAX_RINSE		40
`define TIME_INT_RINSE		8

`define TIME_INIT_DRY		4
`define TIME_MAX_DRY		8
`define TIME_INT_DRY		1

`define NUM_INIT_REPEAT		2
`define NUM_MAX_REPEAT		3
`define NUM_INT_REPEAT		1

module wm_ctrl (
	input			clk,	// 125Mhz
	input			rstn,

	input			butEn_up,
	input			butEn_down,
	input			butEn_left,
	input			butEn_right,

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

	output	[7:0]	fndVal_ctrl
);


	reg		[5:0]	redLED;
	assign {red_led_wash, red_led_rinse, red_led_dry, red_led_repeat, red_led_water_height, red_led_hot_cold} = redLED;

	`define FSM_CTRL_IDLE	0
	`define FC_WASH			1
	`define FC_RINSE		2
	`define FC_DRY			3
	`define FC_REPEAT		4
	`define FC_WATER_HEIGHT	5
	`define FC_HOT_COLD		6

	reg		[2:0]	fsm_ctrl;
	reg		[2:0]	fsm_ctrlN;
	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			fsm_ctrl <= `FSM_CTRL_IDLE;
		else
			fsm_ctrl <= fsm_ctrlN;
	end

	always @(*) begin

		fsm_ctrlN = `FSM_CTRL_IDLE;
		redLED = 6'b000_000;

		case (fsm_ctrl)
			`FSM_CTRL_IDLE : begin
				fsm_ctrlN = `FC_WASH;
			end
			`FC_WASH : begin
				if (butEn_left)
					fsm_ctrlN = `FC_HOT_COLD;
				else if (butEn_right)
					fsm_ctrlN = `FC_RINSE;
				else
					fsm_ctrlN = `FC_WASH;
				redLED = 6'b100_000;
			end
			`FC_RINSE : begin
				if (butEn_left)
					fsm_ctrlN = `FC_WASH;
				else if (butEn_right)
					fsm_ctrlN = `FC_DRY;
				else
					fsm_ctrlN = `FC_RINSE;
				redLED = 6'b010_000;
			end
			`FC_DRY : begin
				if (butEn_left)
					fsm_ctrlN = `FC_RINSE;
				else if (butEn_right)
					fsm_ctrlN = `FC_REPEAT;
				else
					fsm_ctrlN = `FC_DRY;
				redLED = 6'b001_000;
			end
			`FC_REPEAT : begin
				if (butEn_left)
					fsm_ctrlN = `FC_DRY;
				else if (butEn_right)
					fsm_ctrlN = `FC_WATER_HEIGHT;
				else
					fsm_ctrlN = `FC_REPEAT;
				redLED = 6'b000_100;
			end
			`FC_WATER_HEIGHT : begin
				if (butEn_left)
					fsm_ctrlN = `FC_REPEAT;
				else if (butEn_right)
					fsm_ctrlN = `FC_HOT_COLD;
				else
					fsm_ctrlN = `FC_WATER_HEIGHT;
				redLED = 6'b000_010;
			end
			`FC_HOT_COLD : begin
				if (butEn_left)
					fsm_ctrlN = `FC_WATER_HEIGHT;
				else if (butEn_right)
					fsm_ctrlN = `FC_WASH;
				else
					fsm_ctrlN = `FC_HOT_COLD;
				redLED = 6'b000_001;
			end
		endcase
	end

	reg		[7:0]	time_wash;
	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			time_wash <= `TIME_INIT_WASH;
		else if (fsm_ctrl == `FC_WASH) begin
			if (butEn_up) begin
				if ((time_wash > `TIME_MAX_WASH) | (time_wash == `TIME_MAX_WASH))
					time_wash <= `TIME_MAX_WASH;
				else
 					time_wash <= time_wash + `TIME_INT_WASH;
			end
			else if (butEn_down) begin
				if ((time_wash < 0) | (time_wash == 0))
					time_wash <= 0;
				else
 					time_wash <= time_wash - `TIME_INT_WASH;
			end
		end
	end

	reg		[7:0]	time_rinse;
	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			time_rinse <= `TIME_INIT_RINSE;
		else if (fsm_ctrl == `FC_RINSE) begin
			if (butEn_up) begin
				if (time_rinse > (`TIME_MAX_RINSE - 1))
					time_rinse <= `TIME_MAX_RINSE;
				else
 					time_rinse <= time_rinse + `TIME_INT_RINSE;
			end
			else if (butEn_down) begin
				if (time_rinse < 1)
					time_rinse <= 0;
				else
 					time_rinse <= time_rinse - `TIME_INT_RINSE;
			end
		end
	end

	reg		[7:0]	time_dry;
	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			time_dry <= `TIME_INIT_DRY;
		else if (fsm_ctrl == `FC_DRY) begin
			if (butEn_up) begin
				if (time_dry == `TIME_MAX_DRY)
					time_dry <= `TIME_MAX_DRY;
				else
 					time_dry <= time_dry + `TIME_INT_DRY;
			end
			else if (butEn_down) begin
				if (time_dry == 0)
					time_dry <= 0;
				else
 					time_dry <= time_dry - `TIME_INT_DRY;
			end
		end
	end

	reg		[7:0]	rinseRepeatNum;
	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			rinseRepeatNum <= `NUM_INIT_REPEAT;
		else if (fsm_ctrl == `FC_REPEAT) begin
			if (butEn_up) begin
				if (rinseRepeatNum == `NUM_MAX_REPEAT)
					rinseRepeatNum <= `NUM_MAX_REPEAT;
				else
 					rinseRepeatNum <= rinseRepeatNum + `NUM_INT_REPEAT;
			end
			else if (butEn_down) begin
				if (rinseRepeatNum == 1)
					rinseRepeatNum <= 1;
				else
 					rinseRepeatNum <= rinseRepeatNum - `NUM_INT_REPEAT;
			end
		end
	end

	assign fndVal_ctrl =
		(fsm_ctrl == `FC_WASH)   ? time_wash   :
		(fsm_ctrl == `FC_RINSE)  ? time_rinse  :
		(fsm_ctrl == `FC_DRY)    ? time_dry    :
		(fsm_ctrl == `FC_REPEAT) ? rinseRepeatNum : 0;



	reg		[1:0]	waterHeight;
	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			waterHeight <= 2;	// default high
		else if (fsm_ctrl == `FC_WATER_HEIGHT) begin
			if (butEn_up) begin
				if (waterHeight == 2)
					waterHeight <= 2;
				else
 					waterHeight <= waterHeight + 1;
			end
			else if (butEn_down) begin
				if (waterHeight == 0)
					waterHeight <= 0;
				else
 					waterHeight <= waterHeight - 1;
			end
		end
	end

	reg		[1:0]	hotCold;
	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			hotCold <= 0;	// default hot + cold
		else if (fsm_ctrl == `FC_HOT_COLD) begin
			if (butEn_up) begin
				if (hotCold == 2)
					hotCold <= 2;
				else
 					hotCold <= hotCold + 1;
			end
			else if (butEn_down) begin
				if (hotCold == 0)
					hotCold <= 0;
				else
 					hotCold <= hotCold - 1;
			end
		end
	end

	assign green_led_water_high = (waterHeight == 2);
	assign green_led_water_mid  = (waterHeight == 1);
	assign green_led_water_low  = (waterHeight == 0);

	assign green_led_hot_only  = (hotCold == 2);
	assign green_led_cold_only = (hotCold == 1);
	assign green_led_hot_cold  = (hotCold == 0);
	
endmodule
