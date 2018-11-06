module Flag_CrossDomain(
	input wire clkA,
	input wire FlagIn,
	input wire clkB,
	output wire FlagOut
);

	reg FlagToggle;
	initial FlagToggle = 0;
	always @(posedge clkA) FlagToggle <= FlagToggle ^ FlagIn;

	reg [2:0] SyncA;
	initial SyncA = 0;
	always @(posedge clkB) SyncA <= {SyncA[1:0], FlagToggle};
	
	assign FlagOut = SyncA[2] ^ SyncA[1];

endmodule
