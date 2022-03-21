////////////////////////////////////////////////////////////////////////////////
//
// Project:	Verilog Portfolio
//
// Purpose:	Verilator test bench driver file lifo module.
//
// Creator:	Zhengfan Xia
//
////////////////////////////////////////////////////////////////////////////////
//
//
#include <stdio.h>
#include <stdlib.h>
#include "Vlifo.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int	tickcount = 0;
Vlifo	*tb;
VerilatedVcdC	*tfp;

// a tick: 10ns clock period
// eval 3 times and dump: posedge-2, posedge, negedge
void tick(void) {
	
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

void status_show_i(void) {
	printf("[i] en:%d wr:%d count:%d full:%d empty:%d overflow:%d underflow:%d\n", tb->en, tb->wr, tb->count, tb->full, tb->empty, tb->overflow, tb->underflow);
}
void status_show_o(void) {
	printf("[o] en:%d wr:%d count:%d full:%d empty:%d overflow:%d underflow:%d\n", tb->en, tb->wr, tb->count, tb->full, tb->empty, tb->overflow, tb->underflow);
}

void write(uint8_t data) {
	tb->en=1;
	tb->wr=1;
	tb->wdat=data;
	status_show_i();
	tick();
	status_show_o();
	tb->en=0;
	tb->wr=0;
}

uint8_t read(void) {
	tb->en=1;
	tb->wr=0;
	status_show_i();
	tick();
	status_show_o();
	tb->en=0;
	tb->wr=0;
	return tb->rdat;
}

int main(int argc, char **argv) {

	// Call commandArgs first!
	Verilated::commandArgs(argc, argv);

	// Instantiate our design
	tb = new Vlifo;

	// Generate a trace
	Verilated::traceEverOn(true);
	tfp = new VerilatedVcdC;
	// Trace 99 levels of hierarchy
	tb->trace(tfp, 99); 
	tfp->open("dump.vcd");

	// Generate random data
	uint8_t testbench[16];
	for(int i=0;i<16;i++) testbench[i] = rand()%256;

	// Wait five clocks
	for(int i=0; i<5; i++) tick();

	// reset lifo module
	tb->rst = 1;
	tick();
	tb->rst = 0;
	tick();

	// Wait five clocks
	for(int i=0; i<5; i++) tick();

	//////////////////////////////
	// lifo write check
	// Note:
	// - When writing last data, full and overflow both go high because wr is high at the moment.
	// But, writer should set wr low immediately after seeing full flag goes high.
	// - Overflow write won't overwrite data in fifo
	for(int i=0; i<9; i++) { 
		write(testbench[i]);
		//tick();
		if(tb->count!=8) assert(tb->full!=1);
		if(tb->count!=0) assert(tb->empty!=1);
	}

	//////////////////////////////
	// lifo read check
	//
	for(int i=0; i<8; i++) { 
		uint8_t rd_data = read();
		assert(rd_data == testbench[7-i]);
		if(tb->count!=8) assert(tb->full!=1);
		if(tb->count!=0) assert(tb->empty!=1);
	}
	read();

	// close trace
	tfp->close();
	delete tfp;
	delete tb;
	printf("SUCCESS!\n");
}
