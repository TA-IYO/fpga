`timescale 1ns/1ps

module hw05_tb();

reg         clk;
reg         reset;

reg         in_btn_L;
reg         in_btn_R;
reg         in_btn_D;
wire	[7:0]	out_fnd_data;
wire	[2:0]	out_fnd_dig;

initial begin
    clk = 0;
    forever clk = #4 ~clk;
end

initial begin
          reset = 0;
    #30   reset = 1;
    #70   reset = 0;
end

initial begin
              in_btn_L = 0; in_btn_R = 0; in_btn_D = 0;
    #50000    in_btn_R = 1;   #150000     in_btn_R = 0;
    #50000    in_btn_L = 1;   #150000     in_btn_L = 0;
    #50000    in_btn_D = 1;   #150000     in_btn_D = 0;
    #50000    in_btn_R = 1;   #150000     in_btn_R = 0;
    #50000    in_btn_D = 1;   #150000     in_btn_D = 0;
end
            
fnd_0p1sec_top counter0p1s(clk, rstn, in_btn, out_led);

endmodule