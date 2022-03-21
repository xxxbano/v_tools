################################################################################
##
## Project:	Verilog Tutorial Example file
##
## Purpose:	Builds the Verilator request-walker bus slave example
##
## Targets:
##
##	The (default) or all target will build a verilator simulation for the
##	Request Walker.
##
##	clean	Removes all build products
##
## Creator:	Zhengfan Xia
##
################################################################################
.PHONY: all
all: reqwalker_tb

VERILATOR=verilator
VERILATOR_ROOT ?= $(shell bash -c 'verilator -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')
VINC := $(VERILATOR_ROOT)/include

obj_dir/Vreqwalker.cpp: reqwalker.v
	$(VERILATOR) --trace -Wall -cc reqwalker.v

obj_dir/Vreqwalker__ALL.a: obj_dir/Vreqwalker.cpp
	make --no-print-directory -C obj_dir -f Vreqwalker.mk

reqwalker_tb: reqwalker.cpp obj_dir/Vreqwalker__ALL.a
	g++ -I$(VINC) -I obj_dir $(VINC)/verilated.cpp	\
		$(VINC)/verilated_vcd_c.cpp reqwalker.cpp	\
		obj_dir/Vreqwalker__ALL.a -o reqwalker_tb

.PHONY: sby_fifo
sby_fifo: 
	sby -f fifo.sby -d sby_dir

.PHONY: clean
clean:
	rm -rf obj_dir/ sby_dir*/ reqwalker_tb reqwalker.vcd 
