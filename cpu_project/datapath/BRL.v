module BRL
(
input	        [31:0]		i_b,
input	        [3:0]		sel_a,
output	 reg    [31:0]		brl
);

integer                 i, j;
reg	            [31:0]	temp;
reg                     temp_temp;

always@*
    begin
    temp = i_b;
    for(i=0;i<sel_a;i=i+1)
    	begin
    	    temp_temp   =   temp[31];
    		for(j=30;j>=0;j=j-1)
    			begin
    				temp[j+1]	=	temp[j];
    			end
    		temp[0]	=	temp_temp;
    	end
    	brl    =   temp;
end



endmodule