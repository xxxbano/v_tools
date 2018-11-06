`timescale 1ns/100ps

// clkA should be slower than clkB

module FlagAck_CrossDomain(
	input wire clkA,
	input wire FlagIn,
	output wire busy,
	input wire clkB,
	output wire FlagOut
);

	reg FlagToggle;
	initial FlagToggle = 0;
	always @(posedge clkA) FlagToggle <= FlagToggle ^ (FlagIn&~busy);

	reg [2:0] SyncA;
	initial SyncA = 0;
	always @(posedge clkB) SyncA <= {SyncA[1:0], FlagToggle};
	
	reg [1:0] SyncB;
	initial SyncB = 0;
	always @(posedge clkA) SyncB <= {SyncB[0], SyncA[2]};
	
	assign FlagOut = SyncA[2] ^ SyncA[1];
	assign busy = FlagToggle ^SyncB[1]

endmodule
