    set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports clk]
    
    create_clock -period 8.000 -name sys_clk_pin -waveform {0.000 4.000} -add [get_ports clk]

    set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports reset]

    set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports in_btn]

    set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports out_buz]