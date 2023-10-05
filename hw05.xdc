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
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports but_in_up]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports but_in_down]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports but_in_left]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports but_in_right]

## Pmod Header JA
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports {out_fnd_data[0]}]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports {out_fnd_data[1]}]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {out_fnd_data[2]}]
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports {out_fnd_data[3]}]
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {out_fnd_data[4]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {out_fnd_data[5]}]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {out_fnd_data[6]}]
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {out_fnd_data[7]}]

#set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports temp]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {out_fnd_dig[0]}]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {out_fnd_dig[1]}]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {out_fnd_dig[2]}]
