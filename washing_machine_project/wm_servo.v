module wm_servo(
    input           clk,
    input           rstn,

    input           clkCnt_0p5msEnd,
    input           servoOpen,
    input           servoClose,
    output  reg     pwm_servo
);

reg     [7:0]       servoCnt;
wire    servoCntEnd = clkCnt_0p5msEnd & (servoCnt == 39);

always @(posedge clk or negedge rstn) begin
    if (~rstn)
        servoCnt <= 0;
    else if (clkCnt_0p5msEnd) begin
        if(servoCntEnd)
            servoCnt <= 0;
        else
            servoCnt <= servoCnt + 1; 
    end
end

reg     servoOpenEn;
always @(posedge clk or negedge rstn) begin
    if (~rstn)
        servoOpenEn <= 0;
    else if (servoOpen)
        servoOpenEn <= 1;
    else if (servoClose)
        servoOpenEn <= 0;
end

always @(posedge clk or negedge rstn) begin
    if (~rstn)
        pwm_servo <= 0;
    else if (clkCnt_0p5msEnd) begin
        if (servoOpenEn) begin
            if (servoCnt == 0)
                pwm_servo <= 1;
            else if (servoCnt == 4)
                pwm_servo <= 0;
        end
        else begin
            if (servoCnt == 0)
                pwm_servo <= 1;
            else if (servoCnt == 2)
                pwm_servo <= 0;
        end
    end 
end
    
endmodule