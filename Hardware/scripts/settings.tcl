# Create a Quartus II project for lsd_cv
#
# Arg 1: Project name
# Arg 2: Source directory

if { $::argc != 2 } {
    puts "Error: Insufficient or invalid options passed to script \"[file tail $argv0]\"."
    exit 1
}

set proj [lindex $::argv 0]
set src  [lindex $::argv 1]
set family "Cyclone IV E"
set part   "EP4CE22F17C6"
set top    "Top"


# Create a new project
project_new -family $family -part $part $proj
set_global_assignment -name TOP_LEVEL_ENTITY $top


# Read the LIST file which contains a list of HDL sources.
set fp [open "$src/LIST" r]
set file_data [read $fp]
close $fp

# Add each source file to the project
set data [split $file_data "\n"]
foreach line $data {
    set trimmed [string trim $line]
    if { [string length $trimmed] > 0 } {
        set firstchar [string index $trimmed 0]
        if { $firstchar != "#" } {
            set ext [string tolower [file extension $trimmed]]
            if { $ext == ".v" } {
                set_global_assignment -name VERILOG_FILE "$src/$trimmed"
            } elseif { $ext == ".sv" } {
                set_global_assignment -name SYSTEMVERILOG_FILE "$src/$trimmed"
            } elseif { $ext == ".vhdl" } {
                set_global_assignment -name VHDL_FILE "$src/$trimmed"
            } elseif { $ext == ".qip" } {
                set_global_assignment -name QIP_FILE "$src/$trimmed"
            } elseif { $ext == ".mif" } {
                set_global_assignment -name MIF_FILE "$src/$trimmed"
            } else {
                puts "Error: Unknown or unhandled file type \"$ext\"."
            }
            set_global_assignment -name SEARCH_PATH "[file dirname "$src/$trimmed"]/"
        }
    }
}



#============================================================
# System Core connections
#============================================================
set_location_assignment PIN_R8 -to CLK_50
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK_50
set_location_assignment PIN_J15 -to BUTTON_KEY0
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to BUTTON_KEY0


#============================================================
# Debug connections
#============================================================
set_location_assignment PIN_D3 -to DEBUG_00
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DEBUG_00
set_location_assignment PIN_C3 -to DEBUG_01
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DEBUG_01
set_location_assignment PIN_A3 -to DEBUG_10
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DEBUG_10
set_location_assignment PIN_B4 -to DEBUG_11
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DEBUG_11
set_location_assignment PIN_A4 -to DEBUG_PIX_DATAREADY
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DEBUG_PIX_DATAREADY
set_location_assignment PIN_B5 -to DEBUG_TFT_CLOCK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DEBUG_TFT_CLOCK


#============================================================
# OV7670 hardware connections
#============================================================

# ------------- Control I/O ----------------
set_location_assignment PIN_E8 -to OV7670_HREF
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_HREF
set_location_assignment PIN_F9 -to OV7670_VSYNC
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_VSYNC
set_location_assignment PIN_B7 -to OV7670_XCLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_XCLK
set_location_assignment PIN_A5 -to OV7670_PWDN
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_PWDN
set_location_assignment PIN_E7 -to OV7670_PCLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_PCLK
set_location_assignment PIN_B6 -to OV7670_RESET
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_RESET
set_location_assignment PIN_A7 -to OV7670_SIOC
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_SIOC
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to OV7670_SIOC
set_location_assignment PIN_C8 -to OV7670_SIOD
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_SIOD
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to OV7670_SIOD

# ------------- Image Data ----------------
set_location_assignment PIN_E9 -to OV7670_DATA[7]
set_location_assignment PIN_F8 -to OV7670_DATA[6]
set_location_assignment PIN_D8 -to OV7670_DATA[5]
set_location_assignment PIN_E6 -to OV7670_DATA[4]
set_location_assignment PIN_C6 -to OV7670_DATA[3]
set_location_assignment PIN_D6 -to OV7670_DATA[2]
set_location_assignment PIN_A6 -to OV7670_DATA[1]
set_location_assignment PIN_D5 -to OV7670_DATA[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_DATA[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_DATA[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_DATA[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_DATA[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_DATA[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_DATA[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_DATA[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to OV7670_DATA[7]


#============================================================
# ILI9341 TFT 4-wire SPIE hardware connections
#============================================================

set_location_assignment PIN_D9 -to tftSck
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to tftSck
set_location_assignment PIN_E10 -to tftMosi
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to tftMosi
set_location_assignment PIN_B11 -to tftReset
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to tftReset
set_location_assignment PIN_D11 -to tftChipSelect
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to tftChipSelect
set_location_assignment PIN_D12 -to tftLed
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to tftLed
set_location_assignment PIN_B12 -to tftDC
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to tftDC
set_location_assignment PIN_E11 -to tftMiso
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to tftMiso


#============================================================
# SDRAM
#============================================================
set_location_assignment PIN_M7 -to DRAM_BA[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_BA[0]
set_location_assignment PIN_M6 -to DRAM_BA[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_BA[1]
set_location_assignment PIN_R6 -to DRAM_DQM[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQM[0]
set_location_assignment PIN_T5 -to DRAM_DQM[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQM[1]
set_location_assignment PIN_L2 -to DRAM_RAS_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_RAS_N
set_location_assignment PIN_L1 -to DRAM_CAS_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_CAS_N
set_location_assignment PIN_L7 -to DRAM_CKE
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_CKE
set_location_assignment PIN_R4 -to DRAM_CLK
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_CLK
set_location_assignment PIN_C2 -to DRAM_WE_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_WE_N
set_location_assignment PIN_P6 -to DRAM_CS_N
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_CS_N
set_location_assignment PIN_G2 -to DRAM_DQ[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[0]
set_location_assignment PIN_G1 -to DRAM_DQ[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[1]
set_location_assignment PIN_L8 -to DRAM_DQ[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[2]
set_location_assignment PIN_K5 -to DRAM_DQ[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[3]
set_location_assignment PIN_K2 -to DRAM_DQ[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[4]
set_location_assignment PIN_J2 -to DRAM_DQ[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[5]
set_location_assignment PIN_J1 -to DRAM_DQ[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[6]
set_location_assignment PIN_R7 -to DRAM_DQ[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[7]
set_location_assignment PIN_T4 -to DRAM_DQ[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[8]
set_location_assignment PIN_T2 -to DRAM_DQ[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[9]
set_location_assignment PIN_T3 -to DRAM_DQ[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[10]
set_location_assignment PIN_R3 -to DRAM_DQ[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[11]
set_location_assignment PIN_R5 -to DRAM_DQ[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[12]
set_location_assignment PIN_P3 -to DRAM_DQ[13]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[13]
set_location_assignment PIN_N3 -to DRAM_DQ[14]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[14]
set_location_assignment PIN_K1 -to DRAM_DQ[15]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_DQ[15]
set_location_assignment PIN_P2 -to DRAM_ADDR[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[0]
set_location_assignment PIN_N5 -to DRAM_ADDR[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[1]
set_location_assignment PIN_N6 -to DRAM_ADDR[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[2]
set_location_assignment PIN_M8 -to DRAM_ADDR[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[3]
set_location_assignment PIN_P8 -to DRAM_ADDR[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[4]
set_location_assignment PIN_T7 -to DRAM_ADDR[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[5]
set_location_assignment PIN_N8 -to DRAM_ADDR[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[6]
set_location_assignment PIN_T6 -to DRAM_ADDR[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[7]
set_location_assignment PIN_R1 -to DRAM_ADDR[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[8]
set_location_assignment PIN_P1 -to DRAM_ADDR[9]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[9]
set_location_assignment PIN_N2 -to DRAM_ADDR[10]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[10]
set_location_assignment PIN_N1 -to DRAM_ADDR[11]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[11]
set_location_assignment PIN_L4 -to DRAM_ADDR[12]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to DRAM_ADDR[12]


















