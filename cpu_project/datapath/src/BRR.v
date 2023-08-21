module BRR
(
input   	   [31:0]		i_b,
input	       [3:0]		sel_a,
output	reg    [31:0]		brr
);

integer                 i, j;
reg	            [31:0]	temp;
reg                     temp_temp;

always@*
    begin
    temp = i_b;
    for(i=0;i<sel_a;i=i+1)
    	begin
    	    temp_temp   =   temp[0];
    		for(j=0;j<31;j=j+1)
    			begin
    				temp[j]	=	temp[j+1];
    			end
    		temp[31]	=	temp_temp;
    	end
    	brr  =   temp;
end


endmodule