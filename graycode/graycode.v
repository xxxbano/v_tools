////////////////////////////////////////////
//
// Project: Verilog Portfolio
//
// Purpose: Gray code
//
// Creator: Zhengfan Xia
//
// Version:
// 		v0.1 initial design 20220320 
////////////////////////////////////////////

`timescale 1ns/1ps

module graycode #(
	parameter   DW = 4 // Data Width
)(
	output reg  [DW-1:0]   out,		//Gray code output
    input  wire            en,  	//enable
    input  wire            rst,  
    input  wire            clk
);

    /////////Internal connections & variables///////
    reg    [DW-1:0]         cnt;

    /////////Code///////////////////////
    
	always @ (posedge clk) begin
        if (rst) begin
            out	<= {DW{1'b 0}};   // init gray code
            cnt <= {DW{1'b 0}} + 1;   // counter begins wth '1'
        end else if (en) begin
            cnt <= cnt + 1;
            out <= {cnt[DW-1], cnt[DW-2:0] ^ cnt[DW-1:1]};
        end
	end

	`ifdef FORMAL
		/////////////////////////////////////////////////////////
		// set up formal valid condition
		// rule out unusual conditions
		// the output becomes vilad after going through ->rst->en
		reg f_valid;
		reg f_valid_s1;
		initial f_valid = 0;
		initial f_valid_s1 = 0;
		always @(posedge clk) begin
			if(rst) begin
				f_valid_s1 <= 1;
				f_valid   <= 0;
			end
			if(f_valid_s1&en) begin
				f_valid_s1 <= 0;
				f_valid   <= 1;
			end
		end

		/////////////////////////////////////////////////////////
		// global check
		always @(*) 
			assert(cnt < 1<<DW);

		/////////////////////////////////////////////////////////
		// graycode has only 1-bit change
    	reg  [DW-1:0] f_out_pre;
		always @(posedge clk) begin
			f_out_pre <= out;

			if(f_valid && $changed(out)) begin
				assert(OneBitIsSet(f_out_pre^out));
			end
		end

		// Check there is only 1 bit set in the sequence
		function OneBitIsSet;
			input [DW-1:0] raw;
			begin
				OneBitIsSet = !(raw&(raw-1'b1));
			end
		endfunction

	`endif
    
endmodule
