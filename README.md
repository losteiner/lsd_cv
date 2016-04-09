#lsd_cv

A tiny psychedelic project for machine vision on FPGA.

The goal is to provide a platform for machine vision on low-cost boards like Terasic DE0-Nano.
This is my very first FPGA/Verilog project, so do not hesitate to give hints/critics.

##Details:

- The system targets the VGA (640x480) resolution.
- At the moment it works on QVGA (320x240) resolution in YUV mode (only Y used later later on)
- Target FPS is 30/15/7.5. Not yet parametrized.
- The visualization is done by the 2.2" 4-wire ILI9341 TFT. (SDRAM based output is not yet implemented)


##Requirements

- DE0-Nano development board (easy to port to other)
- Altera Quartus II software (14.0 used)
- OV7670 camera (no FIFO version)
- [optional] TFT 2.2" ILI9341 display
- Dev.Environment: GNU/Linux (Lubuntu 15.10), HP EliteBook 2530p


##Inspirations:
Check out these links for more sophisticated solutions.

- OV7670 driver (basis for mine): https://github.com/westonb/OV7670-Verilog
- other OV7670 driver: https://github.com/Poofjunior/HardwareModules
- tft_ili9341 driver for display (basis for mine): https://github.com/thekroko/ili9341_fpga
- Build environment scripts: https://github.com/grantae/mips32r1_soc_nano

## Demo:
https://www.youtube.com/watch?v=qPlGpQFgjh4

##TODO:

- Release the test benches, scripts, etc.
- Integrate a 32bit SoC like **mips32r1_soc** (prepared).
- Camera configuration shouldn't be static, config via SoC or host PC.
- Provide a visualization interface via ethernet/JTAG.  
