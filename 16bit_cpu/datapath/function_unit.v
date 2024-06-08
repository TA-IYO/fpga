module function_unit #(
parameter WIDTH = 32
)(
input   [WIDTH-1:0]     i_opr_a, i_opr_b,
input   [3:0]           i_sel_a,
input   [4:0]           i_fs,

output  [WIDTH-1:0]     o_func,
output                  o_n,o_z,o_v,o_c
);

reg     [WIDTH-1:0]     t_din;
wire    [WIDTH-1:0]     o_bar,o_alu;

Barrel BARREL_SHIFT(
    .i_barrel(i_opr_b),
    .i_fs(i_fs[3:0]),
    .i_sel_a(i_sel_a),
    .i_opr_a(i_opr_a[3:0]),
    .o_barrel(o_bar)
);

ALU ARITHMETIC_LOGIC(
    .i_a(i_opr_a),
    .i_b(i_opr_b),
    .gs(i_fs[3:0]),
    .out(o_alu),
    .n(o_n),
    .z(o_z),
    .v(o_v),
    .c(o_c)
);
    
always@*
	case(i_fs[4])
		1'b1	:	t_din	=	o_bar;
		default	:	t_din	=	o_alu;
	endcase

assign o_func = t_din;

endmodule
