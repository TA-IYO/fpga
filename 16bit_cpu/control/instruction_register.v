module instruction_register(
input					i_clk, 
input                   i_rstn,
input		[31:0]		i_instruction,
input				   	i_il,
output		reg		           	o_ext,
output		reg     [11:0]		o_opr,
output		reg     [6:0]		o_opcode,
output		reg     [3:0]		o_dr,
output		reg     [3:0]		o_sa,
output		reg     [3:0]		o_sb,
output		reg     [31:0]		o_imd,
output      reg     [7:0]       o_extend,
output      reg     [4:0]       o_fs
);

reg         il_flag;
always@(posedge i_clk or negedge i_rstn) begin
    if(!i_rstn)
        il_flag     <=      0;
    else
        il_flag     <=      i_il;
end

always@(posedge i_clk or negedge i_rstn) begin
	if(!i_rstn) begin
		o_ext         <= 0;
		o_dr          <= 0;
		o_sa          <= 0;
		o_sb          <= 0;
		o_imd         <= 0;
		o_extend      <= 0;
		o_opcode      <= 0;
		o_fs          <= 0;  end
	else begin
		o_ext	      <=	i_instruction[31];
	    o_dr	      <=	i_instruction[11:8];
		o_sa	      <=	i_instruction[7:4];
		o_sb	      <=	i_instruction[3:0];
		o_opr	      <=	i_instruction[30:19];
		o_imd         <=   {0,{i_instruction[30:19]},{i_instruction[3:0]}};
		o_extend      <=   {{i_instruction[11:8]},{i_instruction[7:4]}};
		o_fs          <=   i_instruction[16:12];  
	end
end

always@* begin
        o_opcode 	        =   i_instruction[18:12];
end

always@* begin
    if((i_instruction[18:12] == 7'b0110000) && il_flag) begin
	    o_dr	       =	i_instruction[11:8];
		o_sa	       =	i_instruction[7:4];
		o_sb	       =	i_instruction[3:0];        
    end
end

endmodule
