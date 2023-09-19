module wm_led_top(
    input       clk,
    input       rstn,

    output      red_led_wash,
    output      red_led_rinse,
    output      red_led_dry,
    output      red_led_repeat,
    output      red_led_water_height,
    output      red_led_hot_cold,

    output      green_led_water_high,
    output      green_led_water_mid,
    output      green_led_water_low,

    output      green_led_hot_only,
    output      green_led_cold_only,
    output      green_led_hot_cold
);

parameter CNT_1MSEC = 125000;
parameter CNT_1SEC = 1000;  

    reg     [23:0]      clkCnt_1ms;
    wire    clkCnt_1msEnd = (clkCnt_1ms == CNT_1MSEC - 1);
    wire    clkCnt_0p5msEnd = (clkCnt_1ms == (CNT_1MSEC/2) - 1) | (clkCnt_1ms == CNT_1MSEC - 1);
    always @(posedge  clk or negedge rstn) begin
        if(~rstn)
            clkCnt_1ms <= 0;
        else if(clkCnt_1msEnd)
            clkCnt_1ms <= 0;
        else
            clkCnt_1ms <= clkCnt_1ms + 1;
    end

    reg     [23:0]      clkCnt_1sec;
    wire    clkCnt_1secEnd = clkCnt_1msEnd & (clkCnt_1sec == CNT_1SEC -1);
    
    always @(posedge clk or negedge rstn) begin
        if(~rstn)
            clkCnt_1sec <= 0;
        else if (clkCnt_1msEnd) begin
            if(clkCnt_1secEnd)
                clkCnt_1sec <= 0;
            else
                clkCnt_1sec <= clkCnt_1sec + 1;
        end
    end

wm_led_onoff wm_led_onoff_wash(clk, rstn, 1'b1, clkCnt_1secEnd, red_led_wash);
wm_led_onoff wm_led_onoff_rinse(clk, rstn, 1'b1, clkCnt_1secEnd, red_led_rinse);
wm_led_onoff wm_led_onoff_dry(clk, rstn, 1'b1, clkCnt_1secEnd, red_led_dry);

assign red_led_repeat = 0;
assign red_led_water_high = 0;
assign red_led_hot_cold = 0;
assign green_led_water_high = 1;
assign green_led_water_mid = 1;
assign green_led_water_low = 1;
assign green_led_hot_only = 1;
assign green_led_cold_only = 1;
assign green_led_hot_cold = 1;

endmodule