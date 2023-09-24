
module counter(
    input           clk,
    input           rstn,
    
    input   [15:0]  in_freq,
    output          out_pulse
    );
    
    parameter CNT_0P01MSEC = 1250;
    
    reg     [23:0]   clkCnt_0p01ms;
    wire clkCnt_0p01msEnd = (clkCnt_0p01ms == CNT_0P01MSEC - 1);
    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            clkCnt_0p01ms <= 0;
        else if (clkCnt_0p01msEnd)
            clkCnt_0p01ms <= 0;
        else
            clkCnt_0p01ms <= clkCnt_0p01ms + 1;
    end

    reg     [23:0]   cnt;
    wire cnt_end = (cnt == (100_000 / (2 * in_freq) - 1));
    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cnt <= 0;
        else if (clkCnt_0p01msEnd) begin
            if (cnt_end)
                cnt <= 0;
            else
                cnt <= cnt + 1;
        end
    end
    
    assign out_pulse = cnt_end;
    
endmodule
