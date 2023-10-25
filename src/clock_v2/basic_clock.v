/*
 * basic_clock.v
 * author: Samuel Ellicott
 * date:  10/13/23 
 * The simplest clock we can make, no ability to set registers or anything
 */

`timescale 1ns / 1ns
`default_nettype none

module basic_clock (
	i_sysclk,       // fast system clock (~50MHz)
	i_reset_n,      // syncronous reset (active low)
	i_en,           // enable counting 

	o_seconds,
	o_minutes,
	o_hours
);

input  wire i_sysclk;
input  wire i_reset_n;
input  wire i_en;

output wire [5:0] o_seconds;
output wire [5:0] o_minutes;
output wire [4:0] o_hours;
/* verilator lint_off UNUSED */
wire clk_div;
/* verilator lint_on UNUSED */


wire seconds_sysclk_div;
sysclk_divider #(
	.SYS_CLK_HZ(50_000_000),
	.OUT_CLK_HZ(1),
) sysclk_div_inst (
	.i_sysclk(i_sysclk),
	.i_reset_n(i_reset_n),
	.i_en(i_en),
	.o_div(clk_div),
	.o_clk_overflow(seconds_sysclk_div)
);

wire seconds_count = seconds_sysclk_div;
wire seconds_overflow;
overflow_counter #(
	.WIDTH(6),
	.OVERFLOW(60)
) seconds_count_inst (
	.i_sysclk(i_sysclk),
	.i_reset_n(i_reset_n),
	.i_en(seconds_count),
	.o_count(o_seconds),
	.o_overflow(seconds_overflow)
);

wire minutes_count = seconds_overflow;
wire minutes_overflow;
overflow_counter #(
	.WIDTH(6),
	.OVERFLOW(60)
) minutes_count_inst (
	.i_sysclk(i_sysclk),
	.i_reset_n(i_reset_n),
	.i_en(minutes_count),
	.o_count(o_minutes),
	.o_overflow(minutes_overflow)
);

wire hours_count = minutes_overflow;
/* verilator lint_off UNUSED */
wire hours_overflow;
/* verilator lint_on UNUSED */
overflow_counter #(
	.WIDTH(5),
	.OVERFLOW(24)
) hours_count_inst (
	.i_sysclk(i_sysclk),
	.i_reset_n(i_reset_n),
	.i_en(hours_count),
	.o_count(o_hours),
	.o_overflow(hours_overflow)
);
endmodule
