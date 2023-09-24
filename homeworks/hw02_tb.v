`timescale 1ns/1ps

module buzzer_tb();

reg         clk;
reg         rstn;
reg         in_btn;
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
             in_btn = 0;
    #100000   in_btn = 1;
    #100000   in_btn = 0;
    #100000   in_btn = 1;
    #100000   in_btn = 0;
    #100000   in_btn = 1;
    #100000   in_btn = 0;
    #100000   in_btn = 1;
    #100000   in_btn = 0;            
end

buzzer_sequence buzzer_sequence(
    .clk            (clk), 
    .reset          (rstn),
    .in_btn         (in_btn),
    .out_buz        (out_buz)
    );
            
endmodule