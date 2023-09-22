
module wm_us_ctrl (
	input			clk,			// 125MHz
	input			rstn,

	input			distChkEn,
	input			clkCnt_1msEnd,
	input			usEcho,
	output			usTrig,
	output reg		usDistEn,
	output reg	[7:0]	usDist
);

	reg				trigStart;
	reg				usDistEnP;

	reg				trigCntEn;
	reg		[7:0]	trigCnt;
	wire trigCntEnd = clkCnt_1msEnd & (trigCnt == 9);

	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			trigCntEn <= 0;
		else if (trigStart)
			trigCntEn <= 1;
		else if (trigCntEnd)
			trigCntEn <= 0;
	end

	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			trigCnt <= 0;
		else if (trigStart)
			trigCnt <= 0;
		else if (trigCntEn & clkCnt_1msEnd)
			trigCnt <= trigCnt + 1;
	end

	assign usTrig = trigCntEn;

	reg		[31:0]	echoCnt;
	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			echoCnt <= 0;
		else if (usTrig)
			echoCnt <= 0;
		else if (usEcho)
			echoCnt <= echoCnt + 1;
	end

	//assign usDist = (echoCnt[31:16]) ? 8'hff : echoCnt[15:8];

	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			usDist <= 0;
		else if (usDistEnP)
			//usDist <= (echoCnt[31:18]) ? 8'hff : echoCnt[17:10];
			usDist <= (echoCnt[31:17]) ? 8'hff : echoCnt[16:9];
	end

	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			usDistEn <= 0;
		else
			usDistEn <= usDistEnP;
	end

	`define FSM_US_IDLE			0
	`define FU_START			1
	`define FU_TRIG				2
	`define FU_WAIT_ECHO_HIGH	3
	`define FU_WAIT_ECHO_LOW	4
	`define FU_END				5

	reg		[2:0]	fsm_us;
	reg		[2:0]	fsm_usN;
	always @(posedge clk or negedge rstn) begin
		if (~rstn)
			fsm_us = `FSM_US_IDLE;
		else
			fsm_us = fsm_usN;
	end

	always @(*) begin

		trigStart = 0;
		usDistEnP = 0;

		case (fsm_us)
			`FSM_US_IDLE : begin
				if (distChkEn)
					fsm_usN = `FU_START;
				else
					fsm_usN = `FSM_US_IDLE;
			end
			`FU_START : begin
				fsm_usN = `FU_TRIG;
				trigStart = 1;
			end
			`FU_TRIG : begin
				if (trigCntEnd)
					fsm_usN = `FU_WAIT_ECHO_HIGH;
				else
					fsm_usN = `FU_TRIG;
			end
			`FU_WAIT_ECHO_HIGH : begin
				if (usEcho)
					fsm_usN = `FU_WAIT_ECHO_LOW;
				else
					fsm_usN = `FU_WAIT_ECHO_HIGH;
			end
			`FU_WAIT_ECHO_LOW : begin
				if (~usEcho)
					fsm_usN = `FU_END;
				else
					fsm_usN = `FU_WAIT_ECHO_LOW;
			end
			`FU_END : begin
				if (distChkEn)
					fsm_usN = `FU_START;
				else
					fsm_usN = `FSM_US_IDLE;
				usDistEnP = 1;
			end
		endcase
	end


endmodule
