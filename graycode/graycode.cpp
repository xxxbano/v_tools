////////////////////////////////////////////////////////////////////////////////
//
// Project:	Verilog Portfolio
//
// Purpose:	This is an example Verilator test bench driver file graycode module.
//
// Creator:	Zhengfan Xia
//
////////////////////////////////////////////////////////////////////////////////
//
//
#include <stdio.h>
#include <stdlib.h>
#include "Vgraycode.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int	tickcount = 0;
Vgraycode	*tb;
VerilatedVcdC	*tfp;

// a tick: 10ns clock period
// eval 3 times and dump: posedge-2, posedge, negedge
void	tick(void) {
	
	tickcount+=10;

	tb->eval();
	if (tfp) tfp->dump(tickcount - 2);
	tb->clk = 1;
	tb->eval();
	if (tfp) tfp->dump(tickcount);
	tb->clk = 0;
	tb->eval();
	if (tfp) {
		tfp->dump(tickcount + 5);
		tfp->flush();
	}
}

int main(int argc, char **argv) {

	// Call commandArgs first!
	Verilated::commandArgs(argc, argv);

	// Instantiate our design
	tb = new Vgraycode;

	// Generate a trace
	Verilated::traceEverOn(true);
	tfp = new VerilatedVcdC;
	// Trace 99 levels of hierarchy
	tb->trace(tfp, 99); 
	tfp->open("dump.vcd");

	// Wait five clocks
	for(int i=0; i<5; i++) tick();

	// reset graycode module
	tb->rst = 1;
	tick();
	tb->rst = 0;
	tick();

	// Wait five clocks
	for(int i=0; i<5; i++) tick();

	// enable graycode
	tb->en = 1;

	// loop several cycles
	for(int cycle=0; cycle<20; cycle++) {
		tick();
	}

	// close trace
	tfp->close();
	delete tfp;
	delete tb;
}
