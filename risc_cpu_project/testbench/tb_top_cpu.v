`timescale 1ns / 1ps

module tb_top_cpu;
reg         clk, rstn;
wire [31:0] DP_out;
wire [31:0] DP_RAM_out;

top_cpu CPU(
clk, rstn, DP_out, INST_out
);

initial begin
clk = 1;
forever #5 clk = ~clk;
end

initial begin
rstn = 1'b1;
#10 rstn = 1'b0;
#20 rstn = 1'b1;
end

endmodule
