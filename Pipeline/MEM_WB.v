`timescale 1ns / 1ps

module MEM_WB(
	clk, reset,
	pc8_M, instr_M, AO_M, RD1_M, RD2_M, RD3_M, RD_M, Zero_M,
	pc8_W, instr_W, AO_W, RD1_W, RD2_W, RD3_W, RD_W, Zero_W);
	
	input clk, reset;
	input [31:0] pc8_M, instr_M, AO_M, RD1_M, RD2_M, RD3_M, RD_M;
	input Zero_M;
	output reg [31:0] pc8_W, instr_W, AO_W, RD1_W, RD2_W, RD3_W, RD_W;
	output reg Zero_W;
	
	initial begin
		pc8_W = 0;
		instr_W = 0;
		AO_W = 0;
		RD1_W = 0;
		RD2_W = 0;
		RD3_W = 0;
		RD_W = 0;
		Zero_W = 0;
	end
	
	always @(posedge clk) begin
		if (reset) begin
			pc8_W <= 0;
			instr_W <= 0;
			AO_W <= 0;
			RD1_W <= 0;
			RD2_W <= 0;
			RD3_W <= 0;
			RD_W <= 0;
			Zero_W <= 0;
		end
		else begin
			pc8_W <= pc8_M;
			instr_W <= instr_M;
			AO_W <= AO_M;
			RD1_W <= RD1_M;
			RD2_W <= RD2_M;
			RD3_W <= RD3_M;
			RD_W <= RD_M;
			Zero_W <= Zero_M;
		end
	end
	


endmodule
