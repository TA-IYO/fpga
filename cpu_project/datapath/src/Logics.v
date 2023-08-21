module Logics #(
parameter WIDTH = 32
)(
input	      [WIDTH-1:0]		a,b,
input	      [1:0]			sel,
output	reg   [WIDTH-1:0]		out
);

always@*
	case(sel)
		2'b00	:	out	=	a&b;
		2'b01	:	out	=	a|b;
		2'b10	:	out	=	a^b;
		2'b11	:	out	=	~a;
	endcase
	
endmodule