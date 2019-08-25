`include "svunit_defines.svh"
`include "clk_and_reset.svh"
`include "fifo.v"

module fifo_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "fifo_ut";
  svunit_testcase svunit_ut;

	parameter CLK_HPERIOD = 5; // pulse width
	parameter RST_PERIOD = 2;  // 4 clock
	`CLK_RESET_FIXTURE(CLK_HPERIOD,RST_PERIOD);
	logic rst;
	assign rst = !rst_n;

	parameter MSIZE=4; 
	parameter DSIZE=8; 
	logic wr;
	logic rd;
	logic [DSIZE-1:0] wdata;
	logic [DSIZE-1:0] rdata;
	logic [MSIZE:0] count;
	logic empty;
	logic full;
	logic underflow;
	logic overflow;

	integer i;
	logic [DSIZE-1:0] temp;
	logic [DSIZE-1:0] tmp_mem[0:(1<<MSIZE)-1];

	initial rd = 0;
	initial wr = 0;
	initial wdata = 0;

  //===================================
  // This is the UUT that we're 
  // running the Unit Tests on
  //===================================
  fifo #(DSIZE,MSIZE)my_fifo(.*);


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
	`FAIL_UNLESS_EQUAL(overflow,0);
	`FAIL_UNLESS_EQUAL(underflow,0);
	`FAIL_UNLESS_EQUAL(count,0);
  `SVTEST_END

  `SVTEST(test_write_read_single_data)
	for(i=0;i<20;i=i+1) begin
		temp = $random;
		// write in
		step(1); 
		rd=0;wr=1;wdata=temp;
		step(1); 
		rd=0;wr=0;
		`FAIL_UNLESS_EQUAL(count,1);
		`FAIL_UNLESS_EQUAL(empty,0);
		`FAIL_UNLESS_EQUAL(full,0);
		// read out, data shows on the top before read signals
		rd=1;wr=0;
		step(1); 
		rd=0;wr=0;
		`FAIL_UNLESS_EQUAL(rdata,temp);
		`FAIL_UNLESS_EQUAL(count,0);
		`FAIL_UNLESS_EQUAL(empty,1);
		`FAIL_UNLESS_EQUAL(full,0);
	end
  `SVTEST_END

  `SVTEST(test_write_read_full)
	`FAIL_UNLESS_EQUAL(empty,1);
	`FAIL_UNLESS_EQUAL(full,0);
	for(i=0;i<1<<MSIZE;i=i+1) begin
		tmp_mem[i] = $random;
		wdata=tmp_mem[i];
		rd=0;wr=1;
		step(1); 
		rd=0;wr=0;
	end
	`FAIL_UNLESS_EQUAL(full,1);
	`FAIL_UNLESS_EQUAL(empty,0);
	`FAIL_UNLESS_EQUAL(count,1<<MSIZE);
	step(1); 
	for(i=0;i<1<<MSIZE;i=i+1) begin
		rd=1;wr=0;
		step(1); 
		rd=0;wr=0;
		`FAIL_UNLESS_EQUAL(rdata,tmp_mem[i]);
	end
	`FAIL_UNLESS_EQUAL(full,0);
	`FAIL_UNLESS_EQUAL(empty,1);
	`FAIL_UNLESS_EQUAL(count,0);
  `SVTEST_END

  `SVTEST(test_error)
	`FAIL_UNLESS_EQUAL(empty,1);
	`FAIL_UNLESS_EQUAL(full,0);
	for(i=0;i<1<<MSIZE;i=i+1) begin
		tmp_mem[i] = $random;
		wdata=tmp_mem[i];
		rd=0;wr=1;
		step(1); 
		rd=0;wr=0;
	end
	rd=0;wr=1;
	step(1); 
	`FAIL_UNLESS_EQUAL(overflow,1);
	`FAIL_UNLESS_EQUAL(underflow,0);
	rd=0;wr=0;
	step(1); 
	`FAIL_UNLESS_EQUAL(overflow,0);
	`FAIL_UNLESS_EQUAL(underflow,0);
	for(i=0;i<1<<MSIZE;i=i+1) begin
		rd=1;wr=0;
		step(1); 
		rd=0;wr=0;
	end
	rd=1;wr=0;
	step(1); 
	`FAIL_UNLESS_EQUAL(overflow,0);
	`FAIL_UNLESS_EQUAL(underflow,1);
	rd=0;wr=0;
	step(1); 
	`FAIL_UNLESS_EQUAL(overflow,0);
	`FAIL_UNLESS_EQUAL(underflow,0);
  `SVTEST_END


  `SVUNIT_TESTS_END

//	initial begin
//		$monitor("%d, %b, %b, %b,%b, %d,%d,%b,%b,%b,%b,%d,%d,%d",$stime,my_fifo.clk, my_fifo.rst, my_fifo.rd,my_fifo.wr,my_fifo.wdata,my_fifo.rdata,my_fifo.underflow,my_fifo.overflow,my_fifo.empty,my_fifo.full,my_fifo.count,my_fifo.rd_cnt[2:0],my_fifo.wr_cnt[2:0]);
//		//$monitor("%d, %b, %b, %b, %b",$stime,clk, rst, en,wr);
//		$dumpfile("fifo.vcd");
//		//$dumpvars(0,Flag_CrossDomain_unit_test);
//		$dumpvars;
//	end

endmodule
