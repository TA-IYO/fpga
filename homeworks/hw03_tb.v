`timescale 1ns/1ps

module buz_btn_tb();

reg         clk;
reg         rstn;
reg         in_left;
reg         in_down;
reg         in_up;
reg         in_right;
wire        out_buz;

initial begin
    clk = 0;
    forever clk = #4 ~clk;
end

initial begin
          rstn = 0;
    #50   rstn = 1;
    #50   rstn = 0;
end

initial begin
            in_left = 0; in_down = 0; in_up = 0; in_right = 0;
    #1000000   in_up = 1;
    #1000000   in_up = 0;
    #1000000   in_down = 1;
    #1000000   in_down = 0;
    #1000000   in_left = 1;
    #1000000   in_left = 0;
    #1000000   in_right = 1;
    #1000000   in_right = 0;
end

buz_btn buz_btn(
    .clk            (clk), 
    .reset          (rstn),
    .in_left        (in_left),
    .in_down        (in_down),
    .in_up          (in_up),
    .in_right       (in_right),
    .out_buz        (out_buz)
    );
            
endmodule