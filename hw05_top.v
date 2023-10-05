module fnd_0p1sec_top(
    input           clk,
    input           reset,

    input           in_btn_L,
    input           in_btn_R,
    input           in_btn_D,
	output	[7:0]	out_fnd_data,
	output	[2:0]	out_fnd_dig
);

wire rstn = ~reset;

//`define FSIM
`ifdef FSIM
    parameter CNT_1MSEC = 125;
    parameter CNT_1SEC = 10;
`else
    parameter CNT_1MSEC = 125_000;
    parameter CNT_1SEC = 1000;     
`endif
    parameter CNT_0P1SEC = 100;

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

    reg     [11:0]   clkCnt_0p1s;
    wire clkCnt_0p1sEnd = clkCnt_1msEnd & (clkCnt_0p1s == CNT_0P1SEC - 1);
    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            clkCnt_0p1s <= 0;
		else if (clkCnt_1msEnd) begin
        	if (clkCnt_0p1sEnd)
            	clkCnt_0p1s <= 0;
        	else
            	clkCnt_0p1s <= clkCnt_0p1s + 1;
		end
    end

	wire en_left;
	wire en_right;
	wire en_down;


	button btn_L (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.in_btn				(in_btn_L		),
		.en_btn				(en_left		    )
	);

	button btn_R (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.in_btn				(in_btn_R       	),
		.en_btn				(en_right		    )
	);

	button btn_D (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.in_btn				(in_btn_D    	    ),
		.en_btn				(en_down	    	)
	);    


	`define IDLE       0
	`define START	   1
	`define STOP       2
	`define RESET      3

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
				if (en_right)
					fsm_ctrlN = `START;
				else
					fsm_ctrlN = `IDLE;
			end
			`START : begin
				if (en_left)
					fsm_ctrlN = `STOP;
                else if (en_down)
                    fsm_ctrlN = `RESET;
				else
					fsm_ctrlN = `START;
			end
			`STOP : begin
				if (en_right)
					fsm_ctrlN = `START;
                else if (en_down)
                    fsm_ctrlN = `RESET;
				else
					fsm_ctrlN = `STOP;
			end
			`RESET : begin
					fsm_ctrlN = `IDLE;
			end
		endcase
	end

    reg     [11:0]  cnt_100ms;
    wire    cnt_100ms_End = clkCnt_1msEnd & (cnt_100ms == 4096 - 1);
    always @(posedge clk or negedge rstn) begin
        if ((~rstn) | (fsm_ctrl == `IDLE))
            cnt_100ms <= 0;
		else if (clkCnt_0p1sEnd) begin
        	if (cnt_100ms_End)
            	cnt_100ms <= 0;
            else if (fsm_ctrl == `STOP)
                cnt_100ms <= cnt_100ms;
        	else if (fsm_ctrl == `START)
            	cnt_100ms <= cnt_100ms + 1;
		end
    end

	wm_fnd_ctrl wm_fnd_ctrl (
		.clk					(clk),
		.rstn					(rstn),
		.clkCnt_1msEnd			(clkCnt_1msEnd),
		.fndValIn				(cnt_100ms),
		.seg7_data				(out_fnd_data),
		.seg7_dig				(out_fnd_dig)
	);    

endmodule