#verilog_SRCS = basic_clock.v overflow_counter.v sysclk_divider.v upcounter.v 
verilog_SRCS = timeset_divider.v load_divider.v
testbench = timeset_divider_tb.cpp
top_module = timeset_divider

SRC_DIR = ../clock_v2

SYS_CLK_HZ = 1000000 

PARAMS = -GSYS_CLK_HZ=$(SYS_CLK_HZ)
DEFINES = -DSYS_CLK_HZ=$(SYS_CLK_HZ)
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

