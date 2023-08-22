
module RCA #(
parameter WIDTH = 4
)(
input           [WIDTH-1:0]     a,b,
input                           cin,
output  wire    [WIDTH-1:0]     sum,
output  wire    [1:0]           cout
);

wire [WIDTH:0]	c;
genvar i;
assign cout = c[WIDTH:WIDTH-1];
assign c[0] =   cin;

generate
	for(i=0;i<WIDTH;i=i+1) begin : fa
		full_adder fa(a[i],b[i],c[i],sum[i],c[i+1]);
	end
endgenerate

endmodule