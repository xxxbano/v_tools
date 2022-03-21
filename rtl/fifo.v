////////////////////////////////////////////
// Project: synchronous FIFO
//
// Purpose:
//
// Specification:
//  DW: data width
//  FD: FIFO depth 
// 	wr: high when data on wdata valid else low
// 	rd: high when data on rdata valid else low
// 	count: show data count in FIFO (e.g. threshold control)
// 	wdat: write data
// 	rdat: read data
// 	full: high when FIFO is full else low
// 	empty: high when FIFO is empty else low
// 	overflow: high when FIFO is full and still writing data into FIFO, else low
// 	underflow: high when FIFO is empty and still reading data from FIFO, else low
//
// Creator: Zhengfan Xia
//
// Version:
// 		v0.1 initial design 20190824 
// 		v0.2 formal verification 20220317
////////////////////////////////////////////
module fifo #(
	parameter DW = 8,
	parameter FD = 3,
) (
	input  wire rst,
	input  wire clk,
	input  wire wr,
	input  wire rd,
	input  wire [DW-1:0] wdat,
	output reg  [DW-1:0] rdat,
	output wire [FD:0] count,
	output wire full,
	output wire empty,
	output wire overflow,
	output wire underflow
);


	reg [DW-1:0] mem[0:(1<<FD)-1];
	reg [FD:0] wr_cnt;
	reg [FD:0] rd_cnt;
	wire equal;

	assign equal = wr_cnt[FD-1:0] == rd_cnt[FD-1:0];
	assign empty = ~(wr_cnt[FD]^rd_cnt[FD]) & equal;
	assign full = (wr_cnt[FD]^rd_cnt[FD]) & equal;
	assign overflow = full & wr;
	assign underflow = empty & rd;
	assign count = wr_cnt - rd_cnt;

	always @(posedge clk) begin
		if(rst) begin
			wr_cnt <= 0;
			rd_cnt <= 0;
		end else begin
			if(wr&~overflow) wr_cnt <= wr_cnt + 1;
			if(rd&~underflow) rd_cnt <= rd_cnt + 1;
		end
	end

	// stand
	always @(posedge clk) begin
		if(wr) mem[wr_cnt[FD-1:0]] <= wdat; 
		rdat <= mem[rd_cnt[FD-1:0]];
	end

	// first word fall through 
	//always @(posedge clk) begin
	//	if(wr) mem[wr_cnt[FD-1:0]] <= wdat; 
	//end
	//assign rdat = mem[rd_cnt[FD-1:0]];

// To keep formal verification logic from being synthesized
`ifdef FORMAL

	always @(*)
		//assert(count <= (1<<FD)-1);
		assert(count <= (1<<FD)-10);

	always @(*) begin
		if(full) assert(wr);
		if(empty) assert(rd);
		if(count==0) begin
			assert(empty);
			if(rd) assert(underflow);
		end
		if(count==(1<<FD)-1) begin
			assert(full);
			if(wr) assert(overflow);
		end
	end

`endif

endmodule
