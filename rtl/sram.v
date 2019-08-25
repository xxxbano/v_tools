
module sram(
	input wire clk,
	input wire rd,
	input wire wr,
	input wire [DSIZE-1:0] wdata;
	input wire [MSIZE:0] addr,
	output reg [DSIZE-1:0] rdata
);
	parameter DSIZE = 8; // data width
	parameter MSIZE = 8; // depth factor

	reg [DSIZE-1:0] m[0:1<<MSIZE-1]

	always @(posedge clk) begin
		if(wr) m[addr] <= wdata;
		rdata <= m[addr];
	end

endmodule
