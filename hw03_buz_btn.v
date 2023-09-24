module buz_btn(
    input           clk,    
    input           rstn,
    
    input           in_left,
    input           in_down,
    input           in_up,
    input           in_right,
    output          out_buzz
);

`ifdef FSIM
    parameter CNT_1MSEC = 125;
    parameter CNT_50M_1MSEC = 50;
    parameter CNT_1SEC = 10;
`else
    parameter CNT_1MSEC = 125_000;
    parameter CNT_50M_1MSEC = 50_000;
    parameter CNT_1SEC = 1000;
`endif

    reg     [23:0]   clkCnt_1ms;
    wire clkCnt_1msEnd = (clkCnt_1ms == CNT_1MSEC - 1);
    wire clkCnt_1msEnd = (clkCnt_1ms == CNT_1MSEC - 1);
    wire clkCnt_1msEnd = (clkCnt_1ms == CNT_1MSEC - 1);
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

    wire en_left;
	wire en_down;
	wire en_up;
	wire en_right;

	button btn_L (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.but_in				(in_left		    ),
		.but_en				(en_left			)
	);

	button btn_D (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.but_in				(in_down		    ),
		.but_en				(en_down		    )
	);

	button btn_U (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.but_in				(in_up  			),
		.but_en				(en_up	    		)
	);

	button btn_R (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.but_in				(in_right   		),
		.but_en				(en_right   		)
	);

	wire buzStart = en_left | en_down | en_up | en_right;
    wire in_freq = en_left ? 
	wm_buzzer wm_buzzer (
		.clk					(clk					),
		.rstn					(rstn					),
		.buzStart				(en_left				),
		.in_freq	        	(clkCnt_1msEnd		    ),
		.out_buz				(out_buz				)
	);

    wm_buzzer wm_buzzer (
		.clk					(clk					),
		.rstn					(rstn					),
		.buzStart				(en_down				),
		.in_freq	        	(clkCnt_1msEnd		    ),
		.out_buz				(out_buz				)
	);

    wm_buzzer wm_buzzer (
		.clk					(clk					),
		.rstn					(rstn					),
		.buzStart				(en_up				    ),
		.in_freq	        	(clkCnt_1msEnd		    ),
		.out_buz				(out_buz				)
	);

    wm_buzzer wm_buzzer (
		.clk					(clk					),
		.rstn					(rstn					),
		.buzStart				(en_right				),
		.in_freq	        	(clkCnt_1msEnd		    ),
		.out_buz				(out_buz				)
	);

endmodule