


// 7-segment Naming
//                                                          a
//                 +-------+  top_hor                   +-------+
//                 |       |                            |       |  
//   top_ver_left  |       |  top_ver_right          f  |       | b
//                 |       |                            |   g   |  
//                 +-------+  mid_hor                   +-------+
//                 |       |                            |       |  
//   bot_ver_left  |       |  bot_ver_right          e  |       | c
//                 |       |                            |       |  
//                 +-------+  bot_hor                   +-------+   * dp
//                                                          d


module wm_fnd_ctrl (
	input			clk,			// 125MHz
	input			rstn,

	input			clkCnt_1msEnd,
	input	[11:0]	fndValIn,
	output	[7:0]	seg7_data,
	output	[2:0]	seg7_dig
);




    wire seg7_digitsCntEn = clkCnt_1msEnd;

    reg     [1:0]   seg7_digitsCnt;
    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            seg7_digitsCnt <= 0;
        else if (seg7_digitsCntEn) begin
            if (seg7_digitsCnt == 2)
                seg7_digitsCnt <= 0;
            else
                seg7_digitsCnt <= seg7_digitsCnt + 1;
        end
    end

	reg		[2:0]	dig;
    always @(posedge clk or negedge rstn) begin
        if (~rstn)
			dig <= 0;
        else if (seg7_digitsCntEn) begin
            case (seg7_digitsCnt)
                0 : dig <= 3'b001;
                1 : dig <= 3'b010;
                2 : dig <= 3'b100;
            endcase
        end
    end

   	//wire dig1 = (seg7_digitsCnt == 0);
   	//wire dig2 = (seg7_digitsCnt == 1);
   	//wire dig3 = (seg7_digitsCnt == 2);

	assign seg7_dig = dig;


	wire [3:0] fnd_data =
		(dig == 3'b001) ? fndValIn[3:0] :
		(dig == 3'b010) ? fndValIn[7:4] :
		(dig == 3'b100) ? fndValIn[11:8] : 0;

	reg				seg7_digitsCntEnD1;
    always @(posedge clk or negedge rstn) begin
        if (~rstn)
			seg7_digitsCntEnD1 <= 0;
		else
			seg7_digitsCntEnD1 <= seg7_digitsCntEn;
	end

	wm_fnd_led wm_fnd_led (
		.clk				(clk				),
		.rstn				(rstn				),
		.seg7_en			(seg7_digitsCntEnD1	),
		.seg7_off			(1'b0			),
		.seg7_cnt			(fnd_data			),
		.seg7_data			(seg7_data			)
	);



endmodule

