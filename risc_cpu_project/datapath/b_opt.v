module b_opt #(
parameter WIDTH = 32
)(
input	        [WIDTH-1:0]		in,
input	        [3:0]			sel,
output  wire    [WIDTH-1:0]		out
);

reg            [WIDTH-1:0]     in_opt;

assign out = (sel[3])?  in  :   in_opt;

always@*
	case(sel[2:0])
		3'b000	:	in_opt	=	32'h0;
		3'b001	:	in_opt	=	32'h00000001;
		3'b010	:	in_opt	=	in;
		3'b011	:	in_opt	=	in	+	1;
		3'b100	:	in_opt	=	~in;
		3'b101	:	in_opt	=	~in	+	1;
		3'b110	:	in_opt	=	32'hffffffff;
		default	:	in_opt	=	0;
	endcase
	
endmodule