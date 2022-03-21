////////////////////////////////////////////
//
// Project: Verilog Portfolio
//
// Purpose: LIFO
//
// Creator: Zhengfan Xia
//
// Version:
// 		v0.1 initial design 20190824 
////////////////////////////////////////////


module lifo #(
	parameter DW = 8, 	// Data Width
	parameter LD = 3 	// LIFO Depth
)(
	input  wire rst,
	input  wire clk,
	input  wire en,		// enable
	input  wire wr,		// 1: write; 0: read;
	input  wire [DW-1:0] wdat,
	output reg  [DW-1:0] rdat,
	output reg  [LD:0] count,
	output wire overflow,
	output wire underflow,
	output wire empty,
	output wire full
);

	reg [DW-1:0] mem[0:(1<<LD)-1];
	reg [LD:0] count;

	assign empty = count == 0;
	assign full = count == 1<<LD;
	assign overflow = en & full & wr;
	assign underflow = en & empty & ~wr;


	always @(posedge clk) begin
		if(rst) begin
			count <= 0;
		end else begin
			if(en & wr &~full ) count <= count + 1;
			if(en &~wr &~empty) count <= count - 1;
			//if(en) begin
			//	if(wr & ~full) count <= count + 1;
			//	else if(~wr&~empty) count <= count - 1;
			//end
		end
	end

	wire mem_wr;
	assign  mem_wr = en & wr & ~full;

	always @(posedge clk) begin
		if(mem_wr) mem[count[LD-1:0]] <= wdat;
		if(count>0) rdat <= mem[count-1];
	end

endmodule
