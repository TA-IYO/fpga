## This file is a general .xdc for the Cora Z7-07S Rev. B
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# PL System Clock
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 8.000 -name sys_clk_pin -waveform {0.000 4.000} -add [get_ports clk]

# ResetN
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports reset]

# Button
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports in_up]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports in_down]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports in_left]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports in_right]

## Pmod Header JB
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports out_buz]

