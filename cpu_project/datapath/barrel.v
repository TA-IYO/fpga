module Barrel #(
parameter WIDTH = 32
)(
input	     [WIDTH-1:0]	   i_barrel,
input	     [3:0]			   i_fs,
input	     [3:0]			   i_sel_a,
input        [3:0]            i_opr_a,
output	reg  [WIDTH-1:0]	   o_barrel
);

wire    [WIDTH-1:0]     brr,brl,bsr,bsl;

BRR bar_rot_r(i_barrel,i_opr_a,brr);
BRL bar_rot_l(i_barrel,i_opr_a,brl);
BSR bar_shi_r(i_barrel,i_opr_a,bsr);
BSL bar_shi_l(i_barrel,i_opr_a,bsl);

always@*
    case(i_fs)
        4'b1100   :   o_barrel =   brr;
        4'b1110   :   o_barrel =   brl;
        4'b1101   :   o_barrel =   bsr;
        4'b1111   :   o_barrel =   bsl;
        4'b0010   :   o_barrel =   bsl;
        4'b0100   :   o_barrel =   bsr;
        4'b0110   :   o_barrel =   bsr;
        4'b1000   :   o_barrel =   brl;
        4'b1010   :   o_barrel =   brr;        
        default :   o_barrel =   i_barrel;
    endcase
                           
endmodule