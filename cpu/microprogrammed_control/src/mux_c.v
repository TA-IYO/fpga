module mux_c(
input		     [7:0]		i_na,
input		     [6:0]		i_opcode,
input			    		i_mc,
output	reg	     [7:0]		o_mc	
);

always@*
	case(i_mc)
		1'b1	:	o_mc		=	{1'b0, i_opcode};
		default	:	o_mc		=	i_na;
	endcase
	
endmodule