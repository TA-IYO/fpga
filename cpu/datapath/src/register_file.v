module register_file #(
parameter WIDTH = 32,
parameter DEPTH = 16,
parameter DEPTH_LOG = $clog2(DEPTH)
)(
input 					clk, rstn,
input					rw,

input	[WIDTH-1:0]		data,
input	[DEPTH_LOG-1:0]	sel_a,sel_b,
input	[DEPTH_LOG-1:0]	dr,

output	wire [WIDTH-1:0]		o_A, o_B
);
integer i;
reg		[WIDTH-1:0]	register	[DEPTH-1:0];

always@(posedge clk , negedge rstn) begin
if(!rstn)
	for(i=0;i<DEPTH;i=i+1) begin	register[i]<={WIDTH{1'h0}};   end
else if(rw)
    register    [dr]    <=  data;
	end

assign  o_A      =   register[sel_a];

assign  o_B      =   register[sel_b];



endmodule