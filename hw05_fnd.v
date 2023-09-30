

module wm_fnd_led (
	input			clk,			// 48MHz
	input			rstn,

	input			seg7_en,
	input			seg7_off,
	input	[3:0]	seg7_cnt,
	output	[7:0]	seg7_data
);



	reg				seg7TopH;
	reg				seg7MidH;
	reg				seg7BotH;
	reg				seg7TopVL;
	reg				seg7TopVR;
	reg				seg7BotVL;
	reg				seg7BotVR;
	always @(posedge clk or negedge rstn) begin
		if (~rstn) begin
			seg7TopH               <= 1'b0;
			{seg7TopVL, seg7TopVR} <= {1'b0, 1'b0};
			seg7MidH 			   <= 1'b0;
			{seg7BotVL, seg7BotVR} <= {1'b0, 1'b0};
			seg7BotH 			   <= 1'b0;
		end
		else if (seg7_en) begin
			if (seg7_off) begin
				seg7TopH               <= 1'b0;
				{seg7TopVL, seg7TopVR} <= {1'b0, 1'b0};
				seg7MidH 			   <= 1'b0;
				{seg7BotVL, seg7BotVR} <= {1'b0, 1'b0};
				seg7BotH 			   <= 1'b0;
			end
			else begin
				case (seg7_cnt)
				0 : begin
					seg7TopH               <= 1'b1;
					{seg7TopVL, seg7TopVR} <= {1'b1, 1'b1};
					seg7MidH 			   <= 1'b0;
					{seg7BotVL, seg7BotVR} <= {1'b1, 1'b1};
					seg7BotH 			   <= 1'b1;
				end
				1 : begin
					seg7TopH               <= 1'b0;
					{seg7TopVL, seg7TopVR} <= {1'b0, 1'b1};
					seg7MidH 			   <= 1'b0;
					{seg7BotVL, seg7BotVR} <= {1'b0, 1'b1};
					seg7BotH 			   <= 1'b0;
				end
				2 : begin
					seg7TopH               <= 1'b1;
					{seg7TopVL, seg7TopVR} <= {1'b0, 1'b1};
					seg7MidH 			   <= 1'b1;
					{seg7BotVL, seg7BotVR} <= {1'b1, 1'b0};
					seg7BotH 			   <= 1'b1;
				end
				3 : begin
					seg7TopH               <= 1'b1;
					{seg7TopVL, seg7TopVR} <= {1'b0, 1'b1};
					seg7MidH 			   <= 1'b1;
					{seg7BotVL, seg7BotVR} <= {1'b0, 1'b1};
					seg7BotH 			   <= 1'b1;
				end
				4 : begin
					seg7TopH               <= 1'b0;
					{seg7TopVL, seg7TopVR} <= {1'b1, 1'b1};
					seg7MidH 			   <= 1'b1;
					{seg7BotVL, seg7BotVR} <= {1'b0, 1'b1};
					seg7BotH 			   <= 1'b0;
				end
				5 : begin
					seg7TopH               <= 1'b1;
					{seg7TopVL, seg7TopVR} <= {1'b1, 1'b0};
					seg7MidH 			   <= 1'b1;
					{seg7BotVL, seg7BotVR} <= {1'b0, 1'b1};
					seg7BotH 			   <= 1'b1;
				end
				6 : begin
					seg7TopH               <= 1'b1;
					{seg7TopVL, seg7TopVR} <= {1'b1, 1'b0};
					seg7MidH 		       <= 1'b1;
					{seg7BotVL, seg7BotVR} <= {1'b1, 1'b1};
					seg7BotH 		       <= 1'b1;
				end
				7 : begin
					seg7TopH               <= 1'b1;
					{seg7TopVL, seg7TopVR} <= {1'b0, 1'b1};
					seg7MidH 		       <= 1'b0;
					{seg7BotVL, seg7BotVR} <= {1'b0, 1'b1};
					seg7BotH 		       <= 1'b0;
				end
				8 : begin
					seg7TopH               <= 1'b1;
					{seg7TopVL, seg7TopVR} <= {1'b1, 1'b1};
					seg7MidH 			   <= 1'b1;
					{seg7BotVL, seg7BotVR} <= {1'b1, 1'b1};
					seg7BotH 			   <= 1'b1;
				end
				9 : begin
					seg7TopH               <= 1'b1;
					{seg7TopVL, seg7TopVR} <= {1'b1, 1'b1};
					seg7MidH 			   <= 1'b1;
					{seg7BotVL, seg7BotVR} <= {1'b0, 1'b1};
					seg7BotH 			   <= 1'b1;
				end
				4'hA : begin
					seg7TopH               <= 1'b1;
					{seg7TopVL, seg7TopVR} <= {1'b1, 1'b1};
					seg7MidH 			   <= 1'b1;
					{seg7BotVL, seg7BotVR} <= {1'b1, 1'b1};
					seg7BotH 			   <= 1'b0;
				end
				4'hB : begin
					seg7TopH               <= 1'b0;
					{seg7TopVL, seg7TopVR} <= {1'b1, 1'b0};
					seg7MidH 			   <= 1'b1;
					{seg7BotVL, seg7BotVR} <= {1'b1, 1'b1};
					seg7BotH 			   <= 1'b1;
				end
				4'hC : begin
					seg7TopH               <= 1'b1;
					{seg7TopVL, seg7TopVR} <= {1'b1, 1'b0};
					seg7MidH 			   <= 1'b0;
					{seg7BotVL, seg7BotVR} <= {1'b1, 1'b0};
					seg7BotH 			   <= 1'b1;
				end
				4'hD : begin
					seg7TopH               <= 1'b0;
					{seg7TopVL, seg7TopVR} <= {1'b0, 1'b1};
					seg7MidH 			   <= 1'b1;
					{seg7BotVL, seg7BotVR} <= {1'b1, 1'b1};
					seg7BotH 			   <= 1'b1;
				end
				4'hE : begin
					seg7TopH               <= 1'b1;
					{seg7TopVL, seg7TopVR} <= {1'b1, 1'b0};
					seg7MidH 			   <= 1'b1;
					{seg7BotVL, seg7BotVR} <= {1'b1, 1'b0};
					seg7BotH 			   <= 1'b1;
				end
				4'hF : begin
					seg7TopH               <= 1'b1;
					{seg7TopVL, seg7TopVR} <= {1'b1, 1'b0};
					seg7MidH 			   <= 1'b1;
					{seg7BotVL, seg7BotVR} <= {1'b1, 1'b0};
					seg7BotH 			   <= 1'b0;
				end
				endcase
			end
		end
	end

	// Assign 7-segment output port
	wire seg7_top_hor       = ~seg7TopH;
	wire seg7_mid_hor       = ~seg7MidH;
	wire seg7_bot_hor       = ~seg7BotH;
	wire seg7_top_ver_left  = ~seg7TopVL;
	wire seg7_top_ver_right = ~seg7TopVR;
	wire seg7_bot_ver_left  = ~seg7BotVL;
	wire seg7_bot_ver_right = ~seg7BotVR;

	assign seg7_data = {
		1'b1,
		seg7_mid_hor       ,
		seg7_top_ver_left  ,
		seg7_bot_ver_left  ,
		seg7_bot_hor       ,
		seg7_bot_ver_right ,
		seg7_top_ver_right ,
		seg7_top_hor       };
	

endmodule
