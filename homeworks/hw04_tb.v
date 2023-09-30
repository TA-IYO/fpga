`timescale 1ns/1ps

module buz_led_btn_tb();

reg         clk;
reg         reset;
reg         in_up;
reg         in_down;
wire        out_buz;
wire        out_led;

initial begin
    clk = 0;
    forever clk = #4 ~clk;
end

initial begin
          reset = 0;
    #50   reset = 1;
    #50   reset = 0;
end

initial begin
    in_up = 0; in_down = 0;
    
    #2000000; in_up = 1;  
    #1000000; in_up = 0;  
    #2000000; in_up = 1;  
    #1000000; in_up = 0;
    #2000000; in_up = 1;  
    #1000000; in_up = 0; 
    #2000000; in_up = 1;  
    #1000000; in_up = 0; 
          
    #4000000;
    
    #2000000; in_down = 1;  
    #1000000; in_down = 0;  
    #2000000; in_down = 1;  
    #1000000; in_down = 0;  
    #2000000; in_down = 1;  
    #1000000; in_down = 0;  
    #2000000; in_down = 1;  
    #1000000; in_down = 0;  
        
    #4000000;
    
    #2000000; in_up = 1;  
    #1000000; in_up = 0;  
    #2000000; in_up = 1;  
    #1000000; in_up = 0;
    #2000000; in_up = 1;  
    #1000000; in_up = 0;   
    
    #4000000;    
    
    #2000000; in_down = 1;  
    #1000000; in_down = 0;  
    #2000000; in_down = 1;  
    #1000000; in_down = 0;  
    #2000000; in_down = 1;  
    #1000000; in_down = 0;  
     
end
    
    buz_led_btn buz_led_btn(
    .clk                (clk            ), 
    .reset              (reset          ),
    .in_btn_up          (in_up          ),
    .in_btn_down        (in_down        ),
    .out_buz            (out_buz        ),
    .out_led            (out_led        )
    );

endmodule