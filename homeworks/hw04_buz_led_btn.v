
module buz_led_btn(
    input           clk,
    input           reset,

    input           in_btn_up,
    input           in_btn_down,
    output          out_buz,
    output  reg     out_led
    );

wire rstn = ~reset;

`define FSIM
`ifdef FSIM
    parameter CNT_1MSEC = 125;
`else
    parameter CNT_1MSEC = 125_000;   
`endif

    reg     [23:0]   clkCnt_1ms;
    wire clkCnt_1msEnd = (clkCnt_1ms == CNT_1MSEC - 1);
    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            clkCnt_1ms <= 0;
        else if (clkCnt_1msEnd)
            clkCnt_1ms <= 0;
        else
            clkCnt_1ms <= clkCnt_1ms + 1;
    end

	wire en_down;
	wire en_up;

	button btn_D (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.in_btn				(in_btn_down		),
		.en_btn				(en_down		    )
	);

	button btn_U (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.in_btn				(in_btn_up  	    ),
		.en_btn				(en_up	    		)
	);    

    reg [15:0]  buzzer_freq;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            buzzer_freq <= 500;
        else if (en_up)
            if (buzzer_freq == 750)
                buzzer_freq <= buzzer_freq;
            else
                buzzer_freq <= buzzer_freq + 50;
        else if (en_down)
            if (buzzer_freq == 250)
                buzzer_freq <= buzzer_freq;
            else
               buzzer_freq <= buzzer_freq - 50;    
    end

    wire out_pulse;
    
    counter counter(
        .clk             (clk           ),
        .rstn            (rstn          ),
        .in_freq         (buzzer_freq   ),
        .out_pulse       (out_pulse     )
    );

    wire buz_start = en_up | en_down;

    buzzer buzzer (
		.clk				(clk			    ),
		.rstn				(rstn			    ),
		.buzStart			(buz_start		    ),
		.in_freq	        (out_pulse	        ),
		.out_buz			(out_buz   	        )
	);    

    reg     [23:0]   led_cnt;
    wire led_cnt_end = clkCnt_1msEnd & (led_cnt == (1000 - buzzer_freq));
 
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            led_cnt <= 0;
            out_led <= 0;
            end
		else if (clkCnt_1msEnd) begin
        	if (led_cnt_end) begin
            	led_cnt <= 0;
                out_led <= ~out_led;
            end
        	else
            	led_cnt <= led_cnt + 1;
		end
    end

endmodule
