
module CSA #(
parameter WIDTH=32,
parameter WIDTH_LOG=$clog2(WIDTH)
)(
input    [WIDTH-1:0]     a,b,
input                    cin,
output [WIDTH-1:0]       sum,
output [2:0]             cout
);

wire [9:0] c;
genvar i;
assign cout =   c[9:7];

RCA rca_1(
.a(a[3:0]),
.b(b[3:0]),
.cin(cin),
.sum(sum[3:0]),
.cout(c[1:0]));

generate
	for(i=1;i<(WIDTH/4-1);i=i+1) begin : slice
		csa_4bit sli(a[4*i+3:4*i],b[4*i+3:4*i],c[i],sum[4*i+3:4*i],c[i+1]);
	end
endgenerate

RCA rca_final(
.a(a[WIDTH-1:WIDTH-4]),
.b(b[WIDTH-1:WIDTH-4]),
.cin(c[7]),
.sum(sum[WIDTH-1:WIDTH-4]),
.cout(c[9:8]));

endmodule