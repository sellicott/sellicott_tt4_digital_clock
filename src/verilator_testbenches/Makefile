#verilog_SRCS = clock_wrapper.v \
#	       basic_clock.v time_register.v overflow_counter.v sysclk_divider.v upcounter.v timeset_divider.v load_divider.v \
#	       output_wrapper.v digit_shift_register.v shift_register_controller.v \
#	       bin_to_bcd.v bcd_segment_mux.v bcd_to_7seg.v clock_to_7seg.v
#testbench = clock_wrapper_tb.cpp
#top_module = clock_wrapper
verilog_SRCS = shift_register.v shift_register_tb.v sysclk_divider.v
testbench = shift_register_tb.cpp
top_module = shift_register_tb

SRC_DIR = ../clock_v2

SYS_CLK_HZ = 10000

PARAMS = -GSYS_CLK_HZ=$(SYS_CLK_HZ) -GSHIFT_CLK_HZ=1000
DEFINES = -DSYS_CLK_HZ=$(SYS_CLK_HZ)
#PARAMS = -GWIDTH=8

#verilator_include = $(HOME)/.local/extra_packages/verilator/usr/share/verilator/include
verilator_include = /usr/share/verilator/include

EXPANDED_SRC = $(verilog_SRCS:%.v=$(SRC_DIR)/%.v)

.PHONY: all verilator build clean

all: verilator build
	
verilator:
	verilator -Wall --trace $(PARAMS) --top-module $(top_module) -cc $(EXPANDED_SRC) 
	$(MAKE) -C obj_dir -f V$(top_module).mk

build: 
	g++ -std=c++11 \
	$(DEFINES) \
	-I $(verilator_include) \
	-I obj_dir/ \
	$(verilator_include)/verilated.cpp \
	$(verilator_include)/verilated_vcd_c.cpp \
	$(verilator_include)/verilated_threads.cpp \
	$(testbench) obj_dir/V$(top_module)__ALL.a \
	-latomic \
	-o $(top_module) 

clean:
	-rm -r obj_dir
	-rm *.vcd
	-rm $(top_module)

