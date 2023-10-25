/*
 * overflow_counter.v
 * author: Samuel Ellicott
 * date:  10/13/23 
 * basic WIDTH-bit upcounter use en signal to enable the counting
 */

`timescale 1ns / 1ns
`default_nettype none

module overflow_counter (
    i_sysclk,       // fast system clock (~50MHz)
    i_reset_n,      // syncronous reset (active low)
    i_en,           // enable counting 
    o_count,        // output count
    o_overflow      // output overflow (generates a sysclk length pulse)
);
parameter WIDTH = 8;
parameter OVERFLOW = 60;

input  wire i_sysclk;
input  wire i_reset_n;
input  wire i_en;
output wire [WIDTH-1:0] o_count;
output wire o_overflow;

assign o_overflow = o_count >= OVERFLOW-1;

// active low signal for reseting the counter
wire clear_counter_n = !(!i_reset_n | o_overflow);

upcounter #(
	.WIDTH(WIDTH)
) counter_inst (
	.i_sysclk(i_sysclk),
	.i_reset_n(clear_counter_n),
	.i_en(i_en),
	.o_count(o_count)
);

endmodule
