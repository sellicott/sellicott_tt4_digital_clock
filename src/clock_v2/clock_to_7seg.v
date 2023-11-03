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
input wire i_reset_n;
input wire i_en;
input wire [5:0] i_seconds;
input wire [5:0] i_minutes;
input wire [4:0] i_hours;

output wire [6:0] o_hours_msb;
output wire [6:0] o_hours_lsb;
output wire [6:0] o_minutes_msb; 
output wire [6:0] o_minutes_lsb;
output wire [6:0] o_seconds_msb;
output wire [6:0] o_seconds_lsb;

// pipeline the bcd outputs into registers
wire [3:0] hours_msb;
wire [3:0] hours_lsb;
wire [3:0] minutes_msb;
wire [3:0] minutes_lsb;
wire [3:0] seconds_msb;
wire [3:0] seconds_lsb;

wire [3:0] hours_msb_reg;
wire [3:0] hours_lsb_reg;
wire [3:0] minutes_msb_reg;
wire [3:0] minutes_lsb_reg;
wire [3:0] seconds_msb_reg;
wire [3:0] seconds_lsb_reg;

bin_to_bcd hours_bcd_inst (
	.i_clk(i_clk),
	.i_bin(hours_int),
	.o_bcd_lsb(hours_lsb),
	.o_bcd_msb(hours_msb)
);
bin_to_bcd minutes_bcd_inst (
	.i_clk(i_clk),
	.i_bin(i_minutes),
	.o_bcd_lsb(minutes_lsb),
	.o_bcd_msb(minutes_msb)
);
bin_to_bcd seconds_bcd_inst (
	.i_clk(i_clk),
	.i_bin(i_seconds),
	.o_bcd_lsb(seconds_lsb),
	.o_bcd_msb(seconds_msb)
);

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

wire [5:0] hours_int = {1'b0, i_hours};

bcd_to_7seg hours_msb_inst (
    .bcd(hours_msb_reg),
    .en(i_en),
    .led_out(o_hours_msb)
);
bcd_to_7seg hours_lsb_inst (
    .bcd(hours_lsb_reg),
    .en(i_en),
    .led_out(o_hours_lsb)
);

bcd_to_7seg minutes_msb_inst (
    .bcd(minutes_msb_reg),
    .en(i_en),
    .led_out(o_minutes_msb)
);
bcd_to_7seg minutes_lsb_inst (
    .bcd(minutes_lsb_reg),
    .en(i_en),
    .led_out(o_minutes_lsb)
);

bcd_to_7seg seconds_msb_inst (
    .bcd(seconds_msb_reg),
    .en(i_en),
    .led_out(o_seconds_msb)
);
bcd_to_7seg seconds_lsb_inst (
    .bcd(seconds_lsb_reg),
    .en(i_en),
    .led_out(o_seconds_lsb)
);

endmodule
