`timescale 1ns/1ps

module tb_led_sequence();

reg         clk;
reg         rstn;
reg         in_btn;
wire        out_led;

initial begin
    clk = 0;
    forever clk = #4 ~clk;
end

initial begin
          rstn = 0;
    #30   rstn = 1;
    #70   rstn = 0;
end

initial begin
              in_btn = 0;
    #50000    in_btn = 1;   #150000     in_btn = 0;
    #50000    in_btn = 1;   #150000     in_btn = 0;
    #50000    in_btn = 1;   #150000     in_btn = 0;
    #50000    in_btn = 1;   #150000     in_btn = 0;
    #50000    in_btn = 1;   #150000     in_btn = 0;
    #50000    in_btn = 1;   #150000     in_btn = 0;
    #50000    in_btn = 1;   #150000     in_btn = 0;
    #50000    in_btn = 1;   #150000     in_btn = 0;
end
            
led_sequence led_sequence(clk, rstn, in_btn, out_led);

endmodule