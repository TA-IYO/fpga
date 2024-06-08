module data_path (
input	                        i_clk, 
input                           i_rstn,

//registerfile
input	         [3:0]			i_sel_a,
input	         [3:0]			i_sel_b,
input	         				i_rw,
input	         [3:0]			i_dr,

//mu
input	         [31:0]			i_mb_data,
input	         				i_mb,

//select
input	         [4:0]			i_fs,

//mm
input            [7:0]          i_pc,    
input                           i_mm,

//md
input                           i_md,
input           [31:0]          i_dp_out,
//address and data
output	reg      [8:0]			o_addr,
output	         [31:0]			o_data,


//psr
output	reg			           	o_nflag,
output	reg			           	o_zflag,
output	reg			           	o_vflag,
output	reg			           	o_cflag
);

wire	[31:0]		  opr_a;
wire	[31:0]		  opr_b;
wire    [31:0]        opr_b_reg;
reg     [31:0]        opr_b_mb;
wire				  z,n,c,v;
reg     [31:0]        reg_in;
wire    [31:0]        o_func;


//register
register_file REGISTERx16(
    .clk(i_clk),
    .rstn(i_rstn),
    .rw(i_rw),
    .dr(i_dr),
    .data(reg_in),
    .sel_a(i_sel_a),
    .sel_b(i_sel_b),
    .o_A(opr_a),
    .o_B(opr_b_reg)
);

//operation				 
function_unit FUNCTION_UNIT(
    .i_opr_a(opr_a),
    .i_opr_b(opr_b),
    .i_sel_a(i_sel_a),
    .i_fs(i_fs),
    .o_func(o_func),
    .o_n(n),
    .o_z(z),
    .o_v(v),
    .o_c(c)
    );


	
//address selection					
always@*
	case(i_mm)
		1'b1	:	o_addr	  =	  {{1'b0},{i_pc}};
		default	:   o_addr    =   opr_a[8:0];
	endcase       

//operand b selection
					
always@*
	case(i_mb)
		1'b1	:	opr_b_mb	=	i_mb_data;
		default	:   opr_b_mb    =   opr_b_reg;
	endcase
	
assign o_data  = opr_b_mb;
assign opr_b  = opr_b_mb;
	
	
//memory or operation
always@*
	case(i_md)
		1'b1	:	reg_in    =    i_dp_out;
		default	:	reg_in	   =    o_func;
	endcase	

//psr
always@(posedge i_clk or negedge i_rstn) begin
    if(!i_rstn)   begin
        o_nflag <= 1'b0;
        o_zflag <= 1'b0;
        o_vflag <= 1'b0;
        o_cflag <= 1'b0;
    end else begin
        if(i_rw) begin
            o_nflag   <=  n;
            o_zflag   <=  z;
            o_vflag   <=  v;
            o_cflag   <=  c;
            end
    end
end


endmodule


