
module program_counter(
    input                            i_clk, 
    input                            i_rstn,
    input                [7:0]       i_extend,
    input                            i_pi, 
    input                            i_pl,
    input                            i_ms,
    output      reg      [7:0]       o_pc
    );
    
    reg     [7:0]       pc_temp;
    wire    [7:0]       extend;
    reg                 ms_flag;
    reg     [15:0]      swap_cnt;
    
always@(posedge i_clk or negedge i_rstn) begin
    if(!i_rstn)
        swap_cnt            <=  0;
    else begin
        if((o_pc==8'h0a)&&i_pi)
            swap_cnt        <=  swap_cnt    +   1'b1;
        else
            swap_cnt        <=  swap_cnt;
    end
end             
    
always@(posedge i_clk or negedge i_rstn) begin
    if(!i_rstn)
        ms_flag             <=  0;
    else
        ms_flag             <=  i_ms;
end
    
always@(posedge i_clk or negedge i_rstn) begin
    if(!i_rstn)
        o_pc                <=      0;
    else if(i_pi|i_pl) begin
        if(ms_flag) begin
            o_pc            <=      pc_temp     +   1'b1;
            pc_temp         <=      pc_temp     +   1'b1;
        end
        else if(i_pl)
            o_pc            <=      i_extend;
        else begin
            o_pc            <=      pc_temp;
        end
    end
end

always@(i_pi|i_ms) begin
    if(!i_rstn)
        pc_temp             =   0;
    else begin
        pc_temp = pc_temp + i_pi;
        if(i_ms) begin
                pc_temp     =   pc_temp     +   i_extend;
                o_pc        =   pc_temp;
                end
        else
                pc_temp     =   pc_temp;
    end      
end

endmodule