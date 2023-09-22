
module led_1s(
    input           clk,
    input           reset,
    output  reg     led_out
);

`define FSIM

`ifdef FSIM
    parameter CNT_1SEC = 125;
`else
    parameter CNT_1SEC = 125_000_000;
`endif

    reg     [31:0]   clk_1s;
    wire led_enable = (clk_1s == CNT_1SEC - 1);
    always @(posedge clk) begin
        if (reset)
            clk_1s <= 0;
        else if (led_enable)
            clk_1s <= 0;
        else
            clk_1s <= clk_1s + 1;
    end

    always @(posedge clk) begin
        if(reset)
            led_out <= 0;
        else if(led_enable)
            led_out <= ~led_out;
    end

endmodule