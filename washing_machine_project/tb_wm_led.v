`timescale 1ns/10ps

module tb_wm_led();

    reg rstn;

    initial begin
        rstn = 1;
        #300;
        rtsn = 0;
        #1000;
        rstn = 1;
    end

    reg clk;

    parameter CLK_T = 8.00;

    initial begin
        clk = 0;
    end

    always clk = #(CLK_T/2) ~clk;

    wire      red_led_wash;
    wire      red_led_rinse;
    wire      red_led_dry;
    wire      red_led_repeat;
    wire      red_led_water_height;
    wire      red_led_hot_wire;
    wire      green_led_water_high;
    wire      green_led_water_mid;
    wire      green_led_waterwire;
    wire      green_led_hot_only;
    wire      green_led_cold_only;
    wire      green_led_hot_cold;

    wm_led_top wm_led_top(  
        .clk                    (clk                    ),
        .reset                  (~rstn                  ),
        .reg_led_wash           (red_led_wash           ),
        .red_led_rinse          ( red_led_rinse         ),
        .red_led_dry            (red_led_dry            ),
        .red_led_water_height   (red_led_water_height   ),
        .red_led_hot_cold       (red_led_hot_cold       ),
        .green_led_water_high   (green_led_water_high   ),
        .green_led_water_mid    (green_led_water_mid    ),
        .green_led_water_low    (green_led_water_low    ),
        .green_led_hot_only     (green_led_hot_only     ),
        .green_led_cold_only    (green_led_cold_only    ),
        .green_led_hot_cold     (green_led_hot_cold     )
    );

endmodule           
