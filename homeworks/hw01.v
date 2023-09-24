
module led_sequence(
    input           clk,
    input           reset,
    
    input           in_btn,
    output   reg    out_led
    );
    
    wire rstn = ~reset;
    
`define FSIM

`ifdef FSIM
    parameter CNT_1MSEC = 125;
    parameter CNT_1SEC = 10;
`else
    parameter CNT_1MSEC = 125_000;
    parameter CNT_1SEC = 1000;
`endif
    
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

parameter BTN_EN_CNT = 100;

	reg		[7:0]	butPressCnt;
	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			butPressCnt <= 0;
		else if (~in_btn)
			butPressCnt <= 0;
		else if (clkCnt_1msEnd) begin
			if (butPressCnt == BTN_EN_CNT)
				butPressCnt <= BTN_EN_CNT;
			else
				butPressCnt <= butPressCnt + 1;
		end
	end

	assign btn_en = clkCnt_1msEnd & (butPressCnt == BTN_EN_CNT - 1);

	`define IDLE       0
	`define ON		   1
	`define FLASH      2
	`define OFF        3

	reg		[1:0]	fsm_ctrl;
	reg		[1:0]	fsm_ctrlN;
	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			fsm_ctrl <= `IDLE;
		else
			fsm_ctrl <= fsm_ctrlN;
	end

	always @(*) begin

		fsm_ctrlN = `IDLE;

		case (fsm_ctrl)
			`IDLE : begin
				if (btn_en)
					fsm_ctrlN = `ON;
				else
					fsm_ctrlN = `IDLE;
			end
			`ON : begin
				if (btn_en)
					fsm_ctrlN = `FLASH;
				else
					fsm_ctrlN = `ON;
			end
			`FLASH : begin
				if (btn_en)
					fsm_ctrlN = `OFF;
				else
					fsm_ctrlN = `FLASH;
			end
			`OFF : begin
					fsm_ctrlN = `IDLE;
			end
		endcase
	end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            out_led <= 0;
        else if (fsm_ctrl == `OFF)
            out_led <= 0;
        else if (fsm_ctrl == `ON)
            out_led <= 1;
        else if (fsm_ctrl == `FLASH)
            if (clkCnt_1secEnd)
                out_led <= ~out_led;
    end

endmodule
