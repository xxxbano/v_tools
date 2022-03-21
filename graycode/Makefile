################################################################################
##
## Project:	Verilog Portfolio
##
## Purpose:	Builds portfoio of verilog modules
##
## Targets:
##
##	The (default) or all target will build a verilator simulation for the
##	defined top module
##
##	run:	run simulation
##	sby:	sambiyosys formal verification
##	clean:	Removes all build products
##
## Creator:	Zhengfan Xia
##
################################################################################
.PHONY: all

TOPNAME := graycode
VFILE   := $(TOPNAME).v
VCDFILE := $(TOPNAME).vcd
SIMFILE := $(TOPNAME).cpp
SIMPROG := $(TOPNAME)
VDIR    := ./obj_dir
all: $(SIMPROG)

VERILATOR=verilator
VERILATOR_ROOT ?= $(shell bash -c 'verilator -V|grep VERILATOR_ROOT | head -1 | sed -e "s/^.*=\s*//"')
VINC := $(VERILATOR_ROOT)/include

$(VDIR)/V$(TOPNAME).cpp: $(VFILE)
	$(VERILATOR) --trace -Wall -cc $(VFILE)

$(VDIR)/V$(TOPNAME)__ALL.a: $(VDIR)/V$(TOPNAME).cpp
	make --no-print-directory -C $(VDIR) -f V$(TOPNAME).mk

$(SIMPROG): $(SIMFILE) $(VDIR)/V$(TOPNAME)__ALL.a
	g++ -I$(VINC) -I $(VDIR) $(VINC)/verilated.cpp	\
		$(VINC)/verilated_vcd_c.cpp $(SIMFILE)	\
		$(VDIR)/V$(TOPNAME)__ALL.a -o $(SIMPROG)

.PHONY: run
run:
	./$(SIMPROG)

.PHONY: sby
sby: 
	sby -f $(TOPNAME).sby -d sby_dir

.PHONY: clean
clean:
	rm -rf obj_dir/ sby_dir*/ $(SIMPROG) dump.vcd 
