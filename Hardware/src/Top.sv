
/**
 * @file Top.sv
 * @author David Losteiner
 * @date 2016.04.09.
 * @brief Top module that connects the OV7670 to the TFT display and to the image processing blocks (later on.)
 *
 */

module Top( 
				// System related I/O
            input logic CLK_50,         			// System clock (50MHz)
            input logic BUTTON_KEY0,    // Button for reset

            // OV7670 Camera related
            input logic OV7670_VSYNC,
            input logic OV7670_HREF,			
            input logic OV7670_PCLK,		  // Pixel clock
            input logic [7:0] OV7670_DATA,  // Raw pixel data from OV7670
            output logic OV7670_SIOC,       // [scl] serial data clock
            output logic OV7670_SIOD,       // [sda] serial data (SCCB)
            output logic OV7670_XCLK,		// System clock (24MHz, 12Mhz)
				output logic OV7670_RESET,		// Hard reset
				output logic OV7670_PWDN,		// Power down
            
				/// Screen outputs
				input    logic tftMiso,				
            output logic tftChipSelect, 
				output logic tftMosi, 
				output logic tftSck, 
				output logic tftReset,
            output logic tftDC,
				output logic tftLed,

            /// Debug pins
				output logic DEBUG_00, // Config start
            output logic DEBUG_01, // Config done
            output logic DEBUG_10, // Pixel valid
            output logic DEBUG_11,  // Frame done
				
				output logic DEBUG_PIX_DATAREADY,
				output logic DEBUG_TFT_CLOCK
            );

logic reset;
assign reset = ~BUTTON_KEY0; 
assign OV7670_RESET = ~reset;


/// ********************************    Camera Input   *********************************

reg initNeeded = 1;
wire start;
assign start = initNeeded; // The start migh be set to 1 by default (later?)

assign DEBUG_00 = start;


logic [31:0] clkCount = 0;
always@(posedge CLK_50) begin
	if(1 == initNeeded) begin
		clkCount <= clkCount + 1;
		
		if (clkCount > 30) begin
			initNeeded <= 0;
			clkCount <= 0;
		end
	end
	
	if((1 == reset) && (0 == initNeeded)) begin
		initNeeded <= 1;
	end
end



/// Clock division 50MHz --> 25MHz (30fps) / 12.5MHz (15fps)
OV7670_ClkDiv OV7670_ClkInst(CLK_50, reset, 8'b1, OV7670_XCLK);

logic initDone;
assign DEBUG_01 = initDone;

// Instance: camera_configure
camera_configure camera_conf_inst
        (
        .clk(OV7670_XCLK),
        .start(start),
        .sioc(OV7670_SIOC),
        .siod(OV7670_SIOD),
        .done(initDone)
        );


// Pixel output: {Y[15:8], U/V[7:0]}
logic pixelValid;

// Camera read indicators
logic frameDone;
wire [15:0] pixelData;

 camera_read camera_read_inst (
        .p_clock(OV7670_PCLK), 
        .vsync(OV7670_VSYNC), 
        .href(OV7670_HREF),
        .p_data(OV7670_DATA), 
        .pixel_data(pixelData), 
        .pixel_valid(pixelValid),
        .frame_done(frameDone)
    );

assign DEBUG_10 = pixelValid;
assign DEBUG_11 = frameDone;
	 

/// ********************************  TFT output   **********************************
	 
assign tftLed = 1;
wire tft_clk;
pll pll_inst(CLK_50, tft_clk);

// *************************** Framebuffer
	reg[16:0] framebufferIndex = 17'd0;
	wire fbClk;
	
	initial framebufferIndex = 17'd0;
	
	always @ (posedge fbClk) begin
		framebufferIndex <= (framebufferIndex + 1'b1) % 17'(320*240);
	end
	
// *************************** TFT Module
logic dataReady;
logic [15:0] rgbPixelDataIn;

assign dataReady = (pixelValid & ~OV7670_VSYNC  );

// Convert Y(UV) data for TFT:  Y[15:8] - UV[7:0]
assign rgbPixelDataIn = { pixelData[15:11], pixelData[15:10] , pixelData[15:11]};

// Pas the data to the TFT output
tft_ili9341 #(.INPUT_CLK_MHZ(120))  tft( tft_clk,  tftMiso, tftSck, tftMosi, tftDC, tftReset, tftChipSelect, dataReady, rgbPixelDataIn, fbClk);


assign DEBUG_TFT_CLOCK = fbClk;
assign DEBUG_PIX_DATAREADY = dataReady;
	

endmodule








