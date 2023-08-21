module ALU  #(
parameter WIDTH = 32
)(
input           [WIDTH-1:0]     i_a, i_b,
input           [3:0]           gs,
output  wire    [WIDTH-1:0]     out,
output                          z,
output                          n,
output                          c,
output                          v
    );
    
    wire 	[WIDTH-1:0]    	 sum;
    wire    [2:0]         	 cout;
    wire	[WIDTH-1:0]		lout;
	wire	[WIDTH-1:0]		i_b_opt;
	
b_opt opt(i_b,gs[3:0],i_b_opt);
CSA arith(i_a,i_b_opt,1'b0,sum,cout);			
Logics logi(i_a,i_b,gs[2:1],lout);
	

assign out  =   (gs[3])?    lout    :   sum;

assign v    =   cout[1]^cout[0];

assign c    =   cout[2];

assign z    =   ~(|out);

assign n    =   out[WIDTH-1];
    
endmodule