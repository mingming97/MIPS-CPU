`timescale 1ns / 1ps

module EX_MEM(
	clk, reset, En, clr,
	pc8_E, instr_E, AO_E, RD1_E, RD2_E, RD3_E, Zero_E,
	pc8_M, instr_M, AO_M, RD1_M, RD2_M, RD3_M, Zero_M);
	
	input clk, reset, En, clr;
	
	input [31:0] pc8_E, instr_E, AO_E, RD1_E, RD2_E, RD3_E;
	input Zero_E;
	output reg [31:0] pc8_M, instr_M, AO_M, RD1_M, RD2_M, RD3_M;
	output reg Zero_M;
	
	initial begin
		pc8_M = 0;
		instr_M = 0;
		AO_M = 0;
		RD1_M = 0;
		RD2_M = 0;
		RD3_M = 0;
		Zero_M = 0;
	end
	
	always @(posedge clk) begin
		if (reset | clr) begin
			pc8_M <= 0;
			instr_M <= 0;
			AO_M <= 0;
			RD1_M <= 0;
			RD2_M <= 0;
			RD3_M <= 0;
			Zero_M <= 0;
		end
		else begin
			if (En) begin
				pc8_M <= pc8_E;
				instr_M <= instr_E;
				AO_M <= AO_E;
				RD1_M <= RD1_E;
				RD2_M <= RD2_E;
				RD3_M <= RD3_E;
				Zero_M <= Zero_E;
			end			
		end
	end


endmodule
