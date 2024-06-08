
module top_cpu(
    input                   i_clk,
    input                   i_rstn,
    output      [31:0]      datapath_out,
    output      [31:0]      dpram_out
    );
    assign datapath_out  = dp_data;
    assign dpram_out     = o_dp_out;
    
    wire    [3:0]       dr,sa,sb, o_dr, o_sa, o_sb;
    wire                rw, mb, mm, md;
    wire    [31:0]      dp_data, i_dp_data;
    wire    [8:0]       dp_addr, i_dp_addr;
    wire    [31:0]      dp_out, o_dp_out;
    wire                n,z,v,c,o_n,o_z,o_v,o_c;
    wire    [7:0]       o_pc, pc;
    wire    [31:0]      o_imd, imd;
    wire                mw = o_mw;
    wire    [4:0]       fs, o_fs;
    //from control to datapath
    assign dr = o_dr;
    assign sa = o_sa;
    assign sb = o_sb;
    assign pc = o_pc;
    assign imd = o_imd;
    assign fs = o_fs;
    assign rw = o_rw;
    assign mb = o_mb;
    assign mm = o_mm;
    assign md = o_md;
    //from datapath to RAM
    assign i_dp_data = dp_data;
    assign i_dp_addr = dp_addr;
    //from RAM
    assign dp_out = o_dp_out;
    //from RAM to control
    assign n = o_n;
    assign z = o_z;
    assign v = o_v;
    assign c = o_c;
    
    data_path DATAPATH(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .i_sel_a(sa),
    .i_sel_b(sb),
    .i_rw(rw),
    .i_dr(dr),
    .i_mb_data(imd),
    .i_mb(mb),
    .i_fs(fs),
    .i_pc(pc),
    .i_mm(mm),
    .i_md(md),
    .i_dp_out(dp_out),    
    .o_addr(dp_addr),
    .o_data(dp_data),
    .o_nflag(o_n),
    .o_zflag(o_z),
    .o_vflag(o_v),
    .o_cflag(o_c)
    );
    
    micro_control CONTROL(
     .i_clk(i_clk),
     .i_rstn(i_rstn),
     .i_instruction(dp_out),
     .i_n(n),  
     .i_z(z),  
     .i_v(v),  
     .i_c(c),            
     .o_pc(o_pc),      
     .o_imd(o_imd),
     .o_dr(o_dr),
     .o_sa(o_sa),
     .o_sb(o_sb),
     .o_mw(o_mw),
     .o_rw(o_rw),
     .o_mb(o_mb),
     .o_mm(o_mm),
     .o_md(o_md),
     .o_fs(o_fs)     
    );
    
    blk_mem_gen_0 INSTRUCTION_MEMORY(
    .clka(0),		//clk from zynq
    .ena(1'b1),		//fixed to 1'b1
    .wea(0),			//write 	(active_high)
    .addra(0),			//9bits		(address from zynq)
    .dina(0), 			//32bits	(din from zynq)
    .douta(),			//32bits	(dout to zynq)
    .clkb(i_clk), 			//32bits	clk from your cpu
    .enb(1'b1),		//fixed to 1'b1
    .web(mw),			//mw from up_block
    .addrb(i_dp_addr),			//addr from MM_MUX
    .dinb(i_dp_data), 			//din from MD_MUX
    .doutb(o_dp_out)			//fin to Reg_files
  );	
  
endmodule
