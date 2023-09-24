## This file is a general .xdc for the Cora Z7-07S Rev. B
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# PL System Clock
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 8.000 -name sys_clk_pin -waveform {0.000 4.000} -add [get_ports clk]

# ResetN
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports reset]

## ChipKit Inner Digital Header
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports red_led_wash]
set_property -dict {PACKAGE_PIN U12 IOSTANDARD LVCMOS33} [get_ports red_led_rinse]
set_property -dict {PACKAGE_PIN U13 IOSTANDARD LVCMOS33} [get_ports red_led_dry]
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports red_led_repeat]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33} [get_ports red_led_water_height]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports red_led_hot_cold]
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS33} [get_ports green_led_water_high]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports green_led_water_mid]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports green_led_water_low]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports green_led_hot_only]
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports green_led_cold_only]
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports green_led_hot_cold]


# Button
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports but_in_up]
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports but_in_down]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports but_in_left]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports but_in_right]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports us_sensor_echo]
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports us_sensor_trig]

## Pmod Header JA
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports {fnd_data[0]}]
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports {fnd_data[1]}]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {fnd_data[2]}]
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports {fnd_data[3]}]
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {fnd_data[4]}]
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {fnd_data[5]}]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports {fnd_data[6]}]
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {fnd_data[7]}]

## Pmod Header JB
set_property -dict {PACKAGE_PIN W14 IOSTANDARD LVCMOS33} [get_ports pwm_servo_motor_hot_in]
set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports pwm_servo_motor_cold_in]
set_property -dict {PACKAGE_PIN T11 IOSTANDARD LVCMOS33} [get_ports pwm_servo_motor_out]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports pwm_buzzer]
#set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports temp]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports {fnd_dig[0]}]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports {fnd_dig[1]}]
set_property -dict {PACKAGE_PIN W13 IOSTANDARD LVCMOS33} [get_ports {fnd_dig[2]}]
