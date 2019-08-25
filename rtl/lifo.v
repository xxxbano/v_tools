module lifo #(
	parameter DSIZE = 8,
	parameter MSIZE = 3
)(
	input wire rst,
	input wire clk,
	input wire en,
	input wire wr,
	input wire [DSIZE-1:0] wdata,
	output reg [DSIZE-1:0] rdata,
	output wire [MSIZE:0] count,
	output wire overflow,
	output wire underflow,
	output wire empty,
	output wire full
);

	reg [DSIZE-1:0] m[0:(1<<MSIZE)-1];
	reg [MSIZE:0] SP;

	assign count = SP;
	assign empty = SP == 0;
	assign full = SP == 1<<MSIZE;
	assign overflow = en & full & wr;
	assign underflow = en & empty & ~wr;


	always @(posedge clk) begin
		if(rst) begin
			SP <= 0;
		end else begin
			if(en) begin
				if(wr & ~full) SP <= SP + 1;
				else if(~wr&~empty) SP <= SP - 1;
			end
		end
	end

	wire mem_wr;
	assign  mem_wr = en & wr & ~full;

	always @(posedge clk) begin
		if(mem_wr) m[SP] <= wdata;
		if(SP>0) rdata <= m[SP-1];
	end

endmodule
