`timescale 1ns/100ps

// clkA should be slower than clkB

module TaskAck_CrossDomain(
	input wire clkA,
	input wire TaskA_start,
	output wire TaskA_busy,
	output wire TaskA_done,

	input wire clkB,
	output wire TaskB_start,
	output wire TaskB_busy,
	input wire TaskB_done
);

	reg FlagToggleA;
	reg FlagToggleB;
	reg Busyhold;
	reg [2:0] SyncA;
	reg [2:0] SyncB;
	initial FlagToggleA = 0;
	initial FlagToggleB = 0;
	initial Busyhold = 0;
	initial SyncA = 0;
	initial SyncB = 0;

	always @(posedge clkA) FlagToggleA <= FlagToggleA ^ (TaskA_start&~TaskA_busy);
	always @(posedge clkB) SyncA <= {SyncA[1:0], FlagToggleA};
	assign TaskB_start = SyncA[2] ^ SyncA[1];
	assign TaskB_busy = TaskB_start | Busyhold; 

	always @(posedge clkB) Busyhold <= ~TaskB_done & TaskB_busy;
	always @(posedge clkB) 
		if(TaskB_busy & TaskB_done) FlagToggleB <= FlagToggleA;

	always @(posedge clkA) SyncB <= {SyncB[1:0], FlagToggleB};
	assign TaskA_busy = FlagToggleA ^ SyncB[2];
	assign TaskA_done = SyncB[2] ^ SyncB[1];

endmodule
