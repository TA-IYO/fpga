module wm_led_onoff(
    input       clk,
    input       rstn,
    input       ledEn,
    input       clkCnt_1secEnd,
    output reg  led_onoff
);

    always @(posedge clk or negedge rstn) begin
        if(~rstn)
            led_onoff <= 0;
        else if(~ledEn)
            led_onoff <= 0;
        else if(clkCnt_1secEnd)
            led_onoff <= ~led_onoff;
    end

endmodule