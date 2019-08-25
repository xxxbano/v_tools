`include "svunit_defines.svh"
`include "clk_and_reset.svh"
`include "lifo.v"

module lifo_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "lifo_ut";
  svunit_testcase svunit_ut;

	parameter CLK_HPERIOD = 5; // pulse width
	parameter RST_PERIOD = 2;  // 4 clock
	`CLK_RESET_FIXTURE(CLK_HPERIOD,RST_PERIOD);
	logic rst;
	assign rst = !rst_n;

	parameter MSIZE=3; 
	parameter DSIZE=8; 
	logic wr;
	logic en;
	logic [DSIZE-1:0] wdata;
	logic [DSIZE-1:0] rdata;
	logic [MSIZE:0] count;
	logic empty;
	logic full;
	logic overflow;
	logic underflow;

	integer i;
	logic [DSIZE-1:0] temp;
	logic [DSIZE-1:0] tmp_mem[0:(1<<MSIZE)-1];

	initial en = 0;
	initial wr = 0;
	initial wdata = 0;

  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  lifo #(DSIZE,MSIZE) my_lifo(.*);


  //===================================
  // Build
  //===================================
  function void build();
    svunit_ut = new(name);
  endfunction


  //===================================
  // Setup for running the Unit Tests
  //===================================
  task setup();
    svunit_ut.setup();
    /* Place Setup Code Here */

  endtask


  //===================================
  // Here we deconstruct anything we 
  // need after running the Unit Tests
  //===================================
  task teardown();
    svunit_ut.teardown();
    /* Place Teardown Code Here */

  endtask


  //===================================
  // All tests are defined between the
  // SVUNIT_TESTS_BEGIN/END macros
  //
  // Each individual test must be
  // defined between `SVTEST(_NAME_)
  // `SVTEST_END
  //
  // i.e.
  //   `SVTEST(mytest)
  //     <test code>
  //   `SVTEST_END
  //===================================
  `SVUNIT_TESTS_BEGIN

  `SVTEST(test_rst)
	step(1);  // 1 clock step
	reset();
	`FAIL_UNLESS_EQUAL(empty,1);
	`FAIL_UNLESS_EQUAL(full,0);

  `SVTEST_END

  `SVTEST(test_write_read_single_data)
	for(i=0;i<10;i=i+1) begin
		temp = $random;
		// write in
	  en=1;wr=1;wdata=temp;
		step(1); 
	  en=0;
		`FAIL_UNLESS_EQUAL(count,1);
		`FAIL_UNLESS_EQUAL(empty,0);
		// read out, data shows on the top before read signals
	  en=1;wr=0;
		step(1); 
	  en=0;
		`FAIL_UNLESS_EQUAL(rdata,temp);
		`FAIL_UNLESS_EQUAL(count,0);
		`FAIL_UNLESS_EQUAL(empty,1);
	end
  `SVTEST_END

  `SVTEST(test_write_read_full_stack)
	`FAIL_UNLESS_EQUAL(empty,1);
	`FAIL_UNLESS_EQUAL(full,0);
	for(i=0;i<1<<MSIZE;i=i+1) begin
		tmp_mem[i] = $random;
		wdata=tmp_mem[i];
		en=1;wr=1;
		step(1); 
		en=0;
		`FAIL_UNLESS_EQUAL(my_lifo.m[i],wdata);
	end
	`FAIL_UNLESS_EQUAL(full,1);
	`FAIL_UNLESS_EQUAL(empty,0);
	for(i=0;i<1<<MSIZE;i=i+1) begin
		en=1;wr=0;
		step(1); 
		`FAIL_UNLESS_EQUAL(rdata,tmp_mem[(1<<MSIZE)-1-i]);
		en=0;
	end
	`FAIL_UNLESS_EQUAL(full,0);
	`FAIL_UNLESS_EQUAL(empty,1);
  `SVTEST_END

  `SVTEST(test_error)
	`FAIL_UNLESS_EQUAL(empty,1);
	`FAIL_UNLESS_EQUAL(full,0);
	for(i=0;i<1<<MSIZE;i=i+1) begin
		tmp_mem[i] = $random;
		wdata=tmp_mem[i];
		en=1;wr=1;
		step(1); 
		en=0;
	end
		en=1;wr=1;
		step(1); 
	`FAIL_UNLESS_EQUAL(overflow,1);
	`FAIL_UNLESS_EQUAL(underflow,0);
		en=0;
		step(1); 
	`FAIL_UNLESS_EQUAL(overflow,0);
	`FAIL_UNLESS_EQUAL(underflow,0);
	for(i=0;i<1<<MSIZE;i=i+1) begin
		en=1;wr=0;
		step(1); 
		en=0;
	end
		en=1;wr=0;
		step(1); 
		en=0;
	`FAIL_UNLESS_EQUAL(overflow,0);
	`FAIL_UNLESS_EQUAL(underflow,1);
		step(1); 
	`FAIL_UNLESS_EQUAL(overflow,0);
	`FAIL_UNLESS_EQUAL(underflow,0);
  `SVTEST_END

  `SVUNIT_TESTS_END

//	initial begin
//		$monitor("%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",$stime,my_lifo.clk, my_lifo.rst, my_lifo.en,my_lifo.wr,my_lifo.wdata,my_lifo.rdata,my_lifo.empty,my_lifo.full,my_lifo.count,my_lifo.overflow,my_lifo.underflow);
//		//$monitor("%d, %b, %b, %b, %b,%d, %d,%d,%d,%d,%d,%d",$stime,my_lifo.clk, my_lifo.rst, my_lifo.en,wr,my_lifo.SP,my_lifo.stack_mem[8],temp,dat_o,dat_i,my_lifo.counter,my_lifo.SP);
//		//$monitor("%d, %b, %b, %b, %b",$stime,clk, rst, en,wr);
//		$dumpfile("lifo.vcd");
//		//$dumpvars(0,Flag_CrossDomain_unit_test);
//		$dumpvars;
//	end

endmodule
