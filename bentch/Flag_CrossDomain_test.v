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

	always #10 clkA = !clkA;
	always #20 clkB = !clkB;


	Flag_CrossDomain i_fc(
		.clkA(clkA),
		.clkB(clkB),
		.FlagIn(FlagIn),
		.FlagOut(FlagOut)
	);

	initial begin
		#100 FlagIn = 1;
		#40 FlagIn = 0;
		#300 $finish;
	end

	initial begin
		//$monitor("%d, %b, %b, %b, %b, %b",$stime,clkA, clkB, FlagIn,FlagOut,my_Flag_CrossDomain.FlagToggle);
		$dumpfile("Flag_CrossDomain_test.vcd");
		//$dumpvars(0,Flag_CrossDomain_test);
		$dumpvars;
	end
endmodule
