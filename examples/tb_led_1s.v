`timescale 1ps/1ps

module tb_led_1s();

reg         clk;
reg         reset;
wire        led_out;

initial begin
    clk = 0;
    forever clk = #4 ~clk;
end

initial begin
            reset = 0;
    #100    reset = 1;
    #1000   reset = 0;

end

led_1s led_1s(clk, reset, led_out);

endmodule