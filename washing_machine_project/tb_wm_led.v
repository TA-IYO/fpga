


`timescale 1ns/10ps

module tb_wm_led ();

	// Reset & Clock

	reg rstn;

	initial begin
		rstn = 1;
		#300;
		rstn = 0;
		#1000;
		rstn = 1;
	end

	reg clk;
 
	parameter CLK_T = 8.00;

	initial begin
		clk = 0;
	end

	always clk = #(CLK_T/2) ~clk;

	wire			red_led_wash;
	wire			red_led_rinse;
	wire			red_led_dry;
	wire			red_led_repeat;
	wire			red_led_water_height;
	wire			red_led_hot_cold;
	wire			green_led_water_high;
	wire			green_led_water_mid;
	wire			green_led_water_low;
	wire			green_led_hot_only;
	wire			green_led_cold_only;
	wire			green_led_hot_cold;
	/*
	reg				but_in;

	initial begin
		but_in = 0;
		#10_000;
		but_in = 1; #10000; but_in = 0; #20000;
		but_in = 1; #20000; but_in = 0; #20000;
		but_in = 1; #30000; but_in = 0; #20000;
		but_in = 1; #1000_000; but_in = 0; #2000;
	end
	*/

   	reg				but_in_left;
	reg				but_in_right;
	initial begin
		but_in_left = 0;
		but_in_right = 0;
		#10_000;
		but_in_left = 1; #1000_000; but_in_left = 0; #2000;
		but_in_left = 1; #1000_000; but_in_left = 0; #2000;
		but_in_right = 1; #1000_000; but_in_right = 0; #2000;
		but_in_right = 1; #1000_000; but_in_right = 0; #2000;
		but_in_right = 1; #1000_000; but_in_right = 0; #2000;
		but_in_right = 1; #1000_000; but_in_right = 0; #2000;
		but_in_right = 1; #1000_000; but_in_right = 0; #2000;
		but_in_right = 1; #1000_000; but_in_right = 0; #2000;
		but_in_left = 1; #1000_000; but_in_left = 0; #2000;
		but_in_left = 1; #1000_000; but_in_left = 0; #2000;
		but_in_left = 1; #1000_000; but_in_left = 0; #2000;
		but_in_left = 1; #1000_000; but_in_left = 0; #2000;
	end

	wm_led_top wm_led_top (
		.clk						(clk						),
		.reset						(~rstn						),
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
		.but_in_left				(but_in_left				),
		.but_in_right				(but_in_right				),
		.pwm_buzzer                 (pwm_buzzer                 )
	);

endmodule