/*
 * clock_wrapper.v
 * author: Samuel Ellicott
 * date:  11/03/23 
 * Wrap all the important bits of the clock for tiny tapeout
 * This includes the
 * - button debouncing
 * - time register
 * - binary to BCD converter
 * - BCD to 7-segment display
 * - 7-segment serializer
 */

module clock_wrapper (
	i_clk,          // fast system clock (~50MHz)
	i_reset_n,      // syncronous reset (active low)
	i_en,           // enable the clock 
	i_fast_set,     // select the timeset speed (1 for fast, 0 for slow)
	i_mode,         // select the mode for the clock to be in

	o_serial_data,
	o_serial_latch,
	o_serial_clk
);
parameter SYS_CLK_HZ = 50_000_000;
parameter FAST_SET_HZ = 5;
parameter SLOW_SET_HZ = 2;

input wire       i_clk;
input wire       i_reset_n;
input wire       i_en;
input wire       i_fast_set;
input wire [1:0] i_mode;

wire [5:0] clock_seconds;
wire [5:0] clock_minutes;
wire [4:0] clock_hours;

basic_clock #(
	.SYS_CLK_HZ(SYS_CLK_HZ),
	.FAST_SET_HZ(FAST_SET_HZ),
	.SLOW_SET_HZ(SLOW_SET_HZ)
) clock_inst (
	.i_clk(i_clk),
	.i_reset_n(i_reset_n),
	.i_en(i_en),
	.i_fast_set(i_fast_set),
	.i_mode(i_mode),

	.o_seconds(clock_seconds),
	.o_minutes(clock_minutes),
	.o_hours(clock_hours)
);

clock_to_7seg disp_out (
	.i_clk(i_clk),
	.i_reset_n(i_reset_n),
	.i_en(i_en),

	.i_seconds(clock_seconds),
	.i_minutes(clock_minutes),
	.i_hours(clock_hours),

        .o_hours_msb,
        .o_hours_lsb,
        .o_minutes_msb,
        .o_minutes_lsb,
        .o_seconds_msb,
        .o_seconds_lsb
);
endmodule
