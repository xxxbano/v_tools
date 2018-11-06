`include "../rtl/TaskAck_CrossDomain.v"
`timescale 1ns/100ps

module TaskAck_CrossDomain_test();

	reg clkA;
	reg clkB;
	reg TaskA_start;
	wire TaskA_busy;
	wire TaskA_done;
	wire TaskB_start;
	wire TaskB_busy;
	reg TaskB_done;

	
	initial clkA = 0;
	initial clkB = 0;
	initial TaskA_start = 0;
	initial TaskB_done = 0;

	always #20 clkA = !clkA;
	always #10 clkB = !clkB;


	TaskAck_CrossDomain i_tc(
		.clkA(clkA),
		.clkB(clkB),
		.TaskA_start(TaskA_start),
		.TaskA_busy(TaskA_busy),
		.TaskA_done(TaskA_done),
		.TaskB_start(TaskB_start),
		.TaskB_busy(TaskB_busy),
		.TaskB_done(TaskB_done)
	);

	initial begin

		#100;
		@(negedge clkA) TaskA_start = 1;
		@(negedge clkA) TaskA_start = 0;
		wait(TaskB_start)
		#100;
		@(negedge clkB) TaskB_done = 1;
		@(negedge clkB) TaskB_done = 0;
		#300 $finish;
	end

	initial begin
		//$monitor("%d, %b, %b, %b, %b, %b",$stime,clkA, clkB, FlagIn,FlagOut,my_Flag_CrossDomain.FlagToggle);
		$dumpfile("TaskAck_CrossDomain_test.vcd");
		//$dumpvars(0,Flag_CrossDomain_test);
		$dumpvars;
	end
endmodule
