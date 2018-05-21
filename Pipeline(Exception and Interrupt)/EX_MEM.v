`timescale 1ns / 1ps

module EX_MEM(
	clk, reset, En, clr, int_clr, 
	pc8_E, instr_E, AO_E, RD1_E, RD2_E, RD3_E, pc_E, ExcCode_E,
	pc8_M, instr_M, AO_M, RD1_M, RD2_M, RD3_M, pc_M, ExcCode_M);
	
	input clk, reset, En, clr, int_clr;
	
	input [31:0] pc8_E, instr_E, AO_E, RD1_E, RD2_E, RD3_E, pc_E;
	input [4:0] ExcCode_E;
	output reg [31:0] pc8_M, instr_M, AO_M, RD1_M, RD2_M, RD3_M, pc_M;
	output reg [4:0] ExcCode_M;
	
	initial begin
		pc8_M = 0;
		instr_M = 0;
		AO_M = 0;
		RD1_M = 0;
		RD2_M = 0;
		RD3_M = 0;
		pc_M = 0;
		ExcCode_M = 0;
	end
	
	always @(posedge clk) begin
		if (reset | clr | int_clr) begin
			pc8_M <= 0;
			instr_M <= 0;
			AO_M <= 0;
			RD1_M <= 0;
			RD2_M <= 0;
			RD3_M <= 0;
			pc_M <= pc_E;
			ExcCode_M <= 0;
		end
		else begin
			if (En) begin
				pc8_M <= pc8_E;
				instr_M <= instr_E;
				AO_M <= AO_E;
				RD1_M <= RD1_E;
				RD2_M <= RD2_E;
				RD3_M <= RD3_E;
				pc_M <= pc_E;
				ExcCode_M <= ExcCode_E;
			end			
		end
	end


endmodule
