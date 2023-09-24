
module buz_btn(
    input           clk,    
    input           reset,
    
    input           in_left,
    input           in_down,
    input           in_up,
    input           in_right,
    output  reg     out_buz
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

    reg     [23:0]   clkCnt_1s;
    wire clkCnt_1sEnd = clkCnt_1msEnd & (clkCnt_1s == CNT_1SEC - 1);
    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            clkCnt_1s <= 0;
		else if (clkCnt_1msEnd) begin
        	if (clkCnt_1sEnd)
            	clkCnt_1s <= 0;
        	else
            	clkCnt_1s <= clkCnt_1s + 1;
		end
    end

`define up_freq 300
`define down_freq 600
`define left_freq 900
`define right_freq 1200

wire cnt_1ms_End;
wire cnt_300_End;
wire cnt_600_End;
wire cnt_900_End;
wire cnt_1200_End;
        
    counter cnt_300Hz (
        .clk            (clk            ),
        .rstn           (rstn           ),       
        .in_freq        (`up_freq       ),
        .out_pulse      (cnt_300_End    )
        );

   counter cnt_600Hz (
        .clk            (clk            ),
        .rstn           (rstn           ),       
        .in_freq        (`down_freq     ),
        .out_pulse      (cnt_600_End    )
        );

    counter cnt_900Hz (
        .clk            (clk            ),
        .rstn           (rstn           ),    
        .in_freq        (`left_freq     ),
        .out_pulse      (cnt_900_End    )
        );

    counter cnt_1200Hz (
        .clk            (clk            ),
        .rstn           (rstn           ),       
        .in_freq        (`right_freq    ),
        .out_pulse      (cnt_1200_End   )
        );

    wire en_left;
	wire en_down;
	wire en_up;
	wire en_right;

	button btn_L (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.in_btn				(in_left		    ),
		.en_btn				(en_left			)
	);

	button btn_D (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.in_btn				(in_down		    ),
		.en_btn				(en_down		    )
	);

	button btn_U (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.in_btn				(in_up  			),
		.en_btn				(en_up	    		)
	);

	button btn_R (
		.clk				(clk				),
		.rstn				(rstn				),
		.clkCnt_1msEnd		(clkCnt_1msEnd		),
		.in_btn				(in_right   		),
		.en_btn				(en_right   		)
	);
              
//	wire   buzStart = en_left | en_down | en_up | en_right;
    reg     [2:0]   btn_flag;
    always @(posedge clk or negedge rstn) begin
        if(~rstn)
            btn_flag <= 0;
        else if (en_up)
            btn_flag <= 1;
        else if (en_down)
            btn_flag <= 2;
        else if (en_left)
            btn_flag <= 3;
        else if (en_right)
            btn_flag <= 4;
    end
    
    wire out_up;
    wire out_down;
    wire out_left;
    wire out_right;
    
	buzzer buzzerU (
		.clk					(clk			),
		.rstn					(rstn			),
		.buzStart				(en_up		    ),
		.in_freq	        	(cnt_300_End	),
		.out_buz				(out_up   	    )
	);

    buzzer buzzerD (
		.clk					(clk			),
		.rstn					(rstn			),
		.buzStart				(en_down		),
		.in_freq	        	(cnt_600_End	),
		.out_buz				(out_down	    )
	);
	
	buzzer buzzerL (
		.clk					(clk			),
		.rstn					(rstn			),
		.buzStart				(en_left		),
		.in_freq	        	(cnt_900_End	),
		.out_buz				(out_left	    )
	);
	
	buzzer buzzerR (
		.clk					(clk			),
		.rstn					(rstn			),
		.buzStart				(en_right		),
		.in_freq	        	(cnt_1200_End	),
		.out_buz				(out_right	    )
	);
	
	always @(posedge clk or negedge rstn) begin
	   if(~rstn)
	       out_buz <= 0;
	   else if (btn_flag == 1)
	       out_buz <= out_up;
	   else if (btn_flag == 2)
	       out_buz <= out_down;
	   else if (btn_flag == 3)
	       out_buz <= out_left;
	   else if (btn_flag == 4)
	       out_buz <= out_right;
	end
	
endmodule