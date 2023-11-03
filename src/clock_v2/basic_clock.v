/*
 * basic_clock.v
 * author: Samuel Ellicott
 * date:  11/02/23 
 * A simple clock that implements the basic features we want, like the ability
 * to set the time. Provides a working base for us to build up features
 *
 * There are 4 modes for the clock
 * 0: COUNTING      - Normal mode, update the clock every second
 * 1: SET_MINUTES   - Set the minutes based on the overflow of the timeset
 *                    clock (FAST_SET_HZ, or SLOW_SET_HZ)
 * 2: SET_HOURS     - Set the minutes based on the overflow of the timeset 
 *                    clock (FAST_SET_HZ, or SLOW_SET_HZ)
 * 3: CLEAR_SECONDS - Clear the seconds register
 */

`timescale 1ns / 1ns
`default_nettype none

module basic_clock (
	i_clk,          // fast system clock (~50MHz)
	i_reset_n,      // syncronous reset (active low)
	i_en,           // enable the clock 
	i_fast_set,     // select the timeset speed (1 for fast, 0 for slow)
	i_mode,         // select the mode for the clock to be in

	o_seconds,
	o_minutes,
	o_hours
);
parameter SYS_CLK_HZ = 50_000_000;
parameter FAST_SET_HZ = 5;
parameter SLOW_SET_HZ = 2;

input wire       i_clk;
input wire       i_reset_n;
input wire       i_en;
input wire       i_fast_set;
input wire [1:0] i_mode;

output wire [5:0] o_seconds;
output wire [5:0] o_minutes;
output wire [4:0] o_hours;

/* verilator lint_off UNUSED */
wire clk_1hz;
/* verilator lint_on UNUSED */
wire sysclk_1hz_stb;
wire timeset_stb;

// handle time inputs to generate our 1hz clock for the clock and our time set
// pulses for adjusting the time
sysclk_divider #(
	.SYS_CLK_HZ(SYS_CLK_HZ),
	.OUT_CLK_HZ(1) 
) sysclk_div_inst (
    .i_sysclk(i_clk),
    .i_reset_n(i_reset_n),
    .i_en(i_en),
    .o_div(clk_1hz),
    .o_clk_overflow(sysclk_1hz_stb)
);

timeset_divider #(
	.SYS_CLK_HZ(SYS_CLK_HZ),
	.FAST_SET_HZ(FAST_SET_HZ),
	.SLOW_SET_HZ(SLOW_SET_HZ)
) timeset_div_inst (
    .i_clk(i_clk),
    .i_reset_n(i_reset_n),
    .i_en(i_en),
    .i_fast_set(i_fast_set),
    .o_timeset_stb(timeset_stb)
);

// We need to set the clock stb input based on whether we are in the timeset
// mode or in the free running mode
wire [1:0] timeset_mode = i_mode;
wire is_timeset_mode = |timeset_mode;
wire time_reg_stb = is_timeset_mode ? timeset_stb : sysclk_1hz_stb;

time_register time_reg_inst (
	.i_clk(i_clk),
	.i_reset_n(i_reset_n),
	.i_en(time_reg_stb),
	.i_mode(timeset_mode),
	.o_seconds(o_seconds),
	.o_minutes(o_minutes),
	.o_hours(o_hours)
);

endmodule
