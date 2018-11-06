`include "../rtl/Flag_CrossDomain.v"
`timescale 1ns/100ps

module Flag_CrossDomain_test();

	reg clkA;
	reg clkB;
	reg FlagIn;
	wire FlagOut;

	
	initial clkA = 0;
	initial clkB = 0;
	initial FlagIn = 0;

	always #20 clkA = !clkA;
	always #10 clkB = !clkB;


	Flag_CrossDomain i_fc(
		.clkA(clkA),
		.clkB(clkB),
		.FlagIn(FlagIn),
		.FlagOut(FlagOut)
	);

	initial begin

		#100;
		@(negedge clkA) FlagIn = 1;
		@(negedge clkA) FlagIn = 0;
		#100;
		@(negedge clkA) FlagIn = 1;
		@(negedge clkA) FlagIn = 0;
		#300 $finish;
	end

	initial begin
		//$monitor("%d, %b, %b, %b, %b, %b",$stime,clkA, clkB, FlagIn,FlagOut,my_Flag_CrossDomain.FlagToggle);
		$dumpfile("Flag_CrossDomain_test.vcd");
		//$dumpvars(0,Flag_CrossDomain_test);
		$dumpvars;
	end
endmodule
