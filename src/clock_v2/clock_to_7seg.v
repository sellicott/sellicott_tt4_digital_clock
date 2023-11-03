`timescale 1ns / 1ns
`default_nettype none

module clock_to_7seg (
	i_clk,
	i_reset_n,
	i_en,

	i_seconds,
	i_minutes,
	i_hours,

        o_hours_msb,
        o_hours_lsb,
        o_minutes_msb,
        o_minutes_lsb,
        o_seconds_msb,
        o_seconds_lsb
);

input wire i_clk;
input wire [5:0] o_seconds;
input wire [5:0] o_minutes;
input wire [4:0] o_hours;

output wire [6:0] o_hours_msb   = 0;
output wire [6:0] o_hours_lsb   = 0;
output wire [6:0] o_minutes_msb = 0;
output wire [6:0] o_minutes_lsb = 0;
output wire [6:0] o_seconds_msb = 0;
output wire [6:0] o_seconds_lsb = 0;

// pipeline the bcd outputs into registers
output wire [6:0] hours_msb_reg   = 0;
output wire [6:0] hours_lsb_reg   = 0;
output wire [6:0] minutes_msb_reg = 0;
output wire [6:0] minutes_lsb_reg = 0;
output wire [6:0] seconds_msb_reg = 0;
output wire [6:0] seconds_lsb_reg = 0;

wire [4:0] hours_msb;
wire [4:0] hours_lsb;
wire [4:0] minutes_msb;
wire [4:0] minutes_lsb;
wire [4:0] seconds_msb;
wire [4:0] seconds_lsb;

always @(posedge i_clk) begin 
	if(!i_reset_n) begin
		hours_msb_reg   <= 0;
		hours_lsb_reg   <= 0;
		minutes_msb_reg <= 0;
		minutes_lsb_reg <= 0;
		seconds_msb_reg <= 0;
		seconds_lsb_reg <= 0;
	end
	else begin
		hours_msb_reg   <= hours_msb;
		hours_lsb_reg   <= hours_lsb;
		minutes_msb_reg <= minutes_msb;
		minutes_lsb_reg <= minutes_lsb;
		seconds_msb_reg <= seconds_msb;
		seconds_lsb_reg <= seconds_lsb;
	end
end

bin_to_bcd hours_bcd_inst (
	.i_clk(i_clk),
	.i_bin(i_hours),
	.o_bcd_lsb(hours_lsb),
	.o_bcd_msb(hours_msb)
);
bcd_to_7seg hours_msb (
    .bcd(hours_msb),
    .en(i_en),
    .led_out(o_hours_msb)
);
bcd_to_7seg hours_lsb (
    .bcd(hours_lsb),
    .en(i_en),
    .led_out(o_hours_lsb)
);

bin_to_bcd minutes_bcd_inst (
	.i_clk(i_clk),
	.i_bin(i_minutes),
	.o_bcd_lsb(minutes_lsb),
	.o_bcd_msb(minutes_msb)
);
bcd_to_7seg minutes_msb (
    .bcd(minutes_msb),
    .en(i_en),
    .led_out(o_minutes_msb)
);
bcd_to_7seg minutes_lsb (
    .bcd(minutes_lsb),
    .en(i_en),
    .led_out(o_minutes_lsb)
);

bin_to_bcd minutes_bcd_inst (
	.i_clk(i_clk),
	.i_bin(i_seconds),
	.o_bcd_lsb(seconds_lsb),
	.o_bcd_msb(seconds_msb)
);
bcd_to_7seg seconds_msb(
    .bcd(seconds_msb),
    .en(i_en),
    .led_out(o_seconds_msb)
);
bcd_to_7seg seconds_lsb(
    .bcd(seconds_lsb),
    .en(i_en),
    .led_out(o_seconds_lsb)
);

endmodule
