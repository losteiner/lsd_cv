`timescale 1ns / 1ps

/**
 * @file camera_configure.sv
 * @author David Losteiner
 * @date 2016.04.09.
 * @brief The OV7670 static configuration is done here.Also provides a clock divisor.
 *
 * The original version came from westonb:
 * @see https://github.com/westonb/OV7670-Verilog
 */


module camera_configure
    #(
    parameter CLK_FREQ=25000000
    )
    (
    input wire clk,
    input wire start,
    output wire sioc,
    output wire siod,
    output wire done
    );
    
    wire [7:0] rom_addr;
    wire [15:0] rom_dout;
    wire [7:0] SCCB_addr;
    wire [7:0] SCCB_data;
    wire SCCB_start;
    wire SCCB_ready;
    wire SCCB_SIOC_oe;
    wire SCCB_SIOD_oe;
    
    assign sioc = SCCB_SIOC_oe ? 1'b0 : 1'bZ;
    assign siod = SCCB_SIOD_oe ? 1'b0 : 1'bZ;
    
    OV7670_config_rom rom1(
        .clk(clk),
        .addr(rom_addr),
        .dout(rom_dout)
        );
        
    OV7670_config #(.CLK_FREQ(CLK_FREQ)) config_1(
        .clk(clk),
        .SCCB_interface_ready(SCCB_ready),
        .rom_data(rom_dout),
        .start(start),
        .rom_addr(rom_addr),
        .done(done),
        .SCCB_interface_addr(SCCB_addr),
        .SCCB_interface_data(SCCB_data),
        .SCCB_interface_start(SCCB_start)
        );
    
    SCCB_interface #( .CLK_FREQ(CLK_FREQ)) SCCB1(
        .clk(clk),
        .start(SCCB_start),
        .address(SCCB_addr),
        .data(SCCB_data),
        .ready(SCCB_ready),
        .SIOC_oe(SCCB_SIOC_oe),
        .SIOD_oe(SCCB_SIOD_oe)
        );
    
endmodule



module OV7670_ClkDiv( 
                      input logic clk, reset,                                          
                      input logic [7:0] divInput,      // clock divisor                
                      output logic slowClk);                                            
                                                                                
    logic [7:0] divisor;    /// divisor (aka: divInput) should never be 0.         
    logic countMatch;                                                           
    logic [7:0] count;                                                          
                                                                                
    assign countMatch = (divisor == count);                                     
                                                                                
    always @ (posedge clk)                                                   
    begin                                                                       
        divisor <= divInput;                                                    
    end                                                                         
                                                                                
    always @ (posedge clk)                                                   
    begin                                                                       
        if (reset | countMatch )  // count reset must be synchronous.           
            count <= 8'b00000000;                                               
        else                                                                    
            count <= count + 8'b00000001;                                       
    end                                                                         
                                                                                
    always @ (posedge clk, posedge reset)                                    
    if (reset)                                                                  
            slowClk <= 'b0;                                                     
    else                                                                        
    begin                                                                       
            slowClk <= (countMatch) ?                                           
                            ~slowClk :                                          
                            slowClk;                                            
    end                                                                         
endmodule                