`timescale 1ns / 1ps

/**
 * @file camera_read.sv
 * @author David Losteiner
 * @date 2016.04.09.
 * @brief This module implements the pixel extraction from OV7670 data stream.
 *
 * The original version came from westonb:
 * @see https://github.com/westonb/OV7670-Verilog
 */
 
 
module camera_read(
	input wire p_clock,
	input wire vsync,
	input wire href,
	input wire [7:0] p_data,
	output reg [15:0] pixel_data =0,
	output reg pixel_valid = 0,
	output reg frame_done = 0
    );
	 
	
	reg [1:0] FSM_state = 0;
    reg pixel_half = 0;
	
	localparam WAIT_FRAME_START = 0;
	localparam ROW_CAPTURE = 1;
	
	
	always@(posedge p_clock)
	begin 
	
	case(FSM_state)
	
	WAIT_FRAME_START: begin //wait for VSYNC
	   FSM_state <= (!vsync) ? ROW_CAPTURE : WAIT_FRAME_START;
	   frame_done <= 0;
	   pixel_half <= 0;
	end
	
	ROW_CAPTURE: begin 
	   FSM_state <= vsync ? WAIT_FRAME_START : ROW_CAPTURE;
	   frame_done <= vsync ? 1 : 0;
	   pixel_valid <= (href && pixel_half) ? 1 : 0; 
	   if (href) begin
	       pixel_half <= ~ pixel_half;
	       if (pixel_half) pixel_data[7:0] <= p_data;
	       else pixel_data[15:8] <= p_data;
	   end
	end
	
	
	endcase
	end
	
endmodule
