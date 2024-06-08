
module micro_control(
    input                    i_clk,
    input                    i_rstn,
    input        [31:0]      i_instruction,
    input                    i_n,
    input                    i_z,
    input                    i_v,
    input                    i_c,
    output       [7:0]       o_pc,
    output       [31:0]      o_imd,
    output       [3:0]       o_dr,
    output       [3:0]       o_sa,
    output       [3:0]       o_sb,
    output                   o_mw,
    output                   o_rw,
    output                   o_mb,
    output                   o_mm,
    output                   o_md,
    output        [4:0]      o_fs
    );
    
wire    [31:0]  o_con_ram;   
wire    [7:0]   con_ram_addr;
wire            o_ms;


wire      [7:0]       na;
wire      [2:0]       ms;
wire                  mc;
wire                  il;
wire                  pi;
wire                  pl;
wire                  mb;
wire                  md;
wire                  rw;
wire                  mm;
wire                  mw;


wire    [3:0]   dr;
wire    [3:0]   sa;
wire    [3:0]   sb;

wire    [7:0]   o_mc_addr;

wire    [31:0]  imd;

wire    [7:0]   pc, o_pc;

wire    [7:0]   o_extend, extend;

wire    [6:0]   o_opcode, opcode;

assign  o_dr = dr;
assign  o_sa = sa;
assign  o_sb = sb;

program_counter PROGRAM_COUNTER(
.i_clk(i_clk), 
.i_rstn(i_rstn),
.i_extend(extend),
.i_pi(pi),
.i_pl(pl),
.i_ms(o_ms),
.o_pc(pc)
);

assign  o_pc        =   pc;
assign  extend      =   o_extend;
assign  inst = o_con_ram;

instruction_register INSTRUCTION_REGISTER(
.i_clk(i_clk),
.i_rstn(i_rstn),
.i_instruction(i_instruction),
.i_il(il),
.o_ext(ext),
.o_opr(opr),
.o_opcode(o_opcode),
.o_dr(dr),
.o_sa(sa),
.o_sb(sb),
.o_imd(imd),
.o_extend(o_extend),
.o_fs(o_fs)
);

assign o_imd = imd;

 mux_c MC(
 .i_na(na),
 .i_opcode(opcode),
 .i_mc(mc),
 .o_mc(o_mc_addr)
 );
 
 assign     con_ram_addr = o_mc_addr;

 assign     opcode = o_opcode;
 
 mux_s MS(
 .i_ms(ms),
 .i_n(i_n),
 .i_z(i_z),
 .i_v(i_v),
 .i_c(i_c),
 .o_ms(o_ms)
 );
 
 blk_mem_gen_1 CONTROL_MEMORY(
    .clka(0),		//clk from zynq
    .ena(1'b1),		//fixed to 1'b1
    .wea(0),			//write 	(active_high)
    .addra(0),			//9bits		(address from zynq)
    .dina(0), 			//32bits	(din from zynq)
    .douta(),			//32bits	(dout to zynq)
    .clkb(i_clk), 			//32bits	clk from your cpu
    .enb(1'b1),		//fixed to 1'b1
    .web(0),			//mw from up_block
    .addrb(con_ram_addr),			//addr from MM_MUX
    .dinb(0), 			//din from MD_MUX
    .doutb(o_con_ram)			//fin to Reg_files
  );	
  
  control_logic CONTROL_LOGIC (i_clk, i_rstn, o_con_ram[27:0], na, ms, mc, il, pi, pl, mb, md, rw, mm, mw);
  /*
always@(posedge i_clk, negedge i_rstn)
    if(!i_rstn) begin
        na <= 0;
        ms <= 0;
        mc <= 0;
        il <= 0;
        pi <= 0;
        pl <= 0;
        mb <= 0;
        md <= 0;
        rw <= 0;
        mm <= 0;
        mw <= 0;
    end
    
always@* begin
        na <= o_con_ram[27:20]; 
        ms <= o_con_ram[19:17]; 
        mc <= o_con_ram[16];    
        il <= o_con_ram[15];    
        pi <= o_con_ram[14];    
        pl <= o_con_ram[13];    
        mb <= o_con_ram[9];     
        md <= o_con_ram[3];     
        rw <= o_con_ram[2];     
        mm <= o_con_ram[1];     
        mw <= o_con_ram[0];     
    end
    */
        
assign o_rw = rw;
assign o_mb = mb;
assign o_mm = mm;
assign o_md = md;
assign o_mw = mw;

endmodule
