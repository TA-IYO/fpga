`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/23 00:28:18
// Design Name: 
// Module Name: control_logic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_logic(
    input                   clk, rstn,
    input           [27:0]  in,
    output  reg     [7:0]   na,
            reg     [2:0]   ms,
            reg             mc,
            reg             il,
            reg             pi,
            reg             pl,
            reg             mb,
            reg             md,
            reg             rw,
            reg             mm,
            reg             mw       
    );
    
    always@(posedge clk, negedge rstn)
    if(!rstn) begin
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
        na <= in[27:20]; 
        ms <= in[19:17]; 
        mc <= in[16];    
        il <= in[15];    
        pi <= in[14];    
        pl <= in[13];    
        mb <= in[9];     
        md <= in[3];     
        rw <= in[2];     
        mm <= in[1];     
        mw <= in[0];     
    end

endmodule
