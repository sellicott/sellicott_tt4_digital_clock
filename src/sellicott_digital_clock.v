/* 
 * sellicott_digital_clock.v
 * Top level module for the digital clock deisgn
 * Wraps the actual design for use with the TinyTapeout4 template
 */
module sellicott_digital_clock (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock ~ 10MHz
    input  wire       rst_n     // reset_n - low to reset
);
