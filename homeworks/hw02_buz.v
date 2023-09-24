module buzzer_sequence(
    input           clk,    
    input           reset,
    
    input           in_btn,
    output          out_buz
);

wire rstn = ~reset;

`ifdef FSIM
    parameter CNT_1MSEC = 125;
    parameter CNT_50M_1MSEC = 50;
    parameter CNT_1SEC = 10;
`else
    parameter CNT_1MSEC = 125_000;
    parameter CNT_50M_1MSEC = 50_000;
    parameter CNT_1SEC = 1000;
`endif
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

    wire in_btn;
	wire en_btn;

	button button (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.in_btn				(in_btn		        ),
		.en_btn				(en_btn			    )
	);

	buzzer buzzer (
		.clk				(clk				),
		.rstn				(rstn				),
		.buzStart			(en_btn				),
		.in_freq	        (clkCnt_1msEnd		),
		.out_buz			(out_buz			)
	);

endmodule