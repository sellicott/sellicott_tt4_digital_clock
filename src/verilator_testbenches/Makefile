#verilog_SRCS = basic_clock.v time_register.v overflow_counter.v sysclk_divider.v upcounter.v timeset_divider.v load_divider.v
#testbench = basic_clock_tb.cpp
#top_module = basic_clock
verilog_SRCS = bin_to_bcd.v
testbench = bin_to_bcd.cpp
top_module = bin_to_bcd

SRC_DIR = ../clock_v2

SYS_CLK_HZ = 10000 

#PARAMS = -GSYS_CLK_HZ=$(SYS_CLK_HZ)
#DEFINES = -DSYS_CLK_HZ=$(SYS_CLK_HZ)
#PARAMS = -GWIDTH=8

verilator_include = /usr/share/verilator/include

EXPANDED_SRC = $(verilog_SRCS:%.v=$(SRC_DIR)/%.v)

.PHONY: all verilator build clean

all: verilator build
	
verilator:
	verilator -Wall --trace $(PARAMS) --top-module $(top_module) -cc $(EXPANDED_SRC) 
	$(MAKE) -C obj_dir -f V$(top_module).mk

build: 
	clang++ \
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

