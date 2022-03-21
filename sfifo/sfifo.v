////////////////////////////////////////////
//
// Project: Verilog Portfolio
//
// Purpose: synchronous FIFO
//
// Creator: Zhengfan Xia
//
// Version:
// 		v0.1 initial design 20190824 
// 		v0.2 formal verification 20220317
////////////////////////////////////////////
module sfifo #(
	parameter DW = 8, // Data Width
	parameter FD = 3  // FIFO Depth
) (
	input  wire rst,
	input  wire clk,
	input  wire wr,	// 1 request write
	input  wire rd, // 1 request read
	input  wire [DW-1:0] wdat,	// write data
	output reg  [DW-1:0] rdat,	// read data
	output wire [FD:0] count,	// data count in fifo
	output wire full,
	output wire empty,
	output wire overflow,	// overflow flag
	output wire underflow	// underflow flag
);


	reg [DW-1:0] mem[0:(1<<FD)-1];
	reg [FD:0] wr_cnt;
	reg [FD:0] rd_cnt;
	wire equal;

	assign equal = wr_cnt[FD-1:0] == rd_cnt[FD-1:0];
	// when equal and no race, fifo is empty
	assign empty = ~(wr_cnt[FD]^rd_cnt[FD]) & equal;
	// when equal and in race, fifo is full
	assign full = (wr_cnt[FD]^rd_cnt[FD]) & equal;
	assign overflow = full & wr;
	assign underflow = empty & rd;
	assign count = wr_cnt - rd_cnt;

	always @(posedge clk) begin
		if(rst) begin
			wr_cnt <= 0;
			rd_cnt <= 0;
		end else begin
			//if(wr&~overflow) wr_cnt <= wr_cnt + 1;
			//if(rd&~underflow) rd_cnt <= rd_cnt + 1;
			if(wr&~full) wr_cnt <= wr_cnt + 1;
			if(rd&~empty) rd_cnt <= rd_cnt + 1;
		end
	end

	// stand
	always @(posedge clk) begin
		//if(wr) mem[wr_cnt[FD-1:0]] <= wdat;  // overwrite
		//if(wr&~overflow) mem[wr_cnt[FD-1:0]] <= wdat; // no overwrite
		if(wr&~full) mem[wr_cnt[FD-1:0]] <= wdat; // no overwrite
		rdat <= mem[rd_cnt[FD-1:0]];
	end

	// first word fall through 
	//always @(posedge clk) begin
	//	if(wr) mem[wr_cnt[FD-1:0]] <= wdat; 
	//end
	//assign rdat = mem[rd_cnt[FD-1:0]];

// To keep formal verification logic from being synthesized
`ifdef FORMAL
	// not complete yet

	// setup valid condition
	reg f_valid, f_valid_s1;
	initial f_valid = 0;
	initial f_valid_s1 = 0;
	always @(posedge clk) begin
		if(rst) begin
			f_valid_s1 <=1;
			f_valid    <=0;
		end else if((f_valid_s1&~full&empty&~wr&~rd&equal)&&(rd_cnt==0)&&(wr_cnt==0)) begin
			f_valid_s1 <=0;
			f_valid    <=1;
		end
	end

	always @(*) begin
		if(f_valid) begin
			assert(count <= 1<<FD);
			if(count==0) assert(empty==1);
			if(count!=0) assert(empty==0);
			if(count==1<<FD) assert(full==1);
			if(count!=1<<FD) assert(full==0);
		end
	end

`endif

endmodule
