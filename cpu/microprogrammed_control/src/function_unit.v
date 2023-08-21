module function_unit #(
parameter WIDTH = 32
)(
input   [WIDTH-1:0]     i_opr_a, i_opr_b,
input   [3:0]           i_sel_a,
input   [4:0]           i_fs,

output  [WIDTH-1:0]     o_func,
output                  o_z,o_n,o_c,o_v
);

reg     [WIDTH-1:0]     t_din;
wire    [WIDTH-1:0]     o_bar,o_alu;

barrel bar(
    .i_barrel(i_opr_b),
    .i_fs(i_fs[3:0]),
    .i_sel_a(i_sel_a),
    .i_opr_a(i_opr_a[3:0]),
    .o_barrel(o_bar)
);

ALU arith_logic(
    .i_a(i_opr_a),
    .i_b(i_opr_b),
    .gs(i_fs[3:0]),
    .out(o_alu),
    .z(o_z),
    .n(o_n),
    .c(o_c),
    .v(o_v)
);
    
always@*
	case(i_fs[4])
		1'b1	:	t_din	=	o_bar;
		default	:	t_din	=	o_alu;
	endcase

assign o_func = t_din;

endmodule
