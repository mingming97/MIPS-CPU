`timescale 1ns / 1ps

module IF_ID(
	clk, reset, En, clr_D, int_clr, 
	pc8, instr, pc, ExcCode,
	pc8_D, instr_D, pc_D, ExcCode_D);
	
	input clk, reset, En, clr_D, int_clr;
	input [31:0] pc8, instr, pc;
	input [4:0] ExcCode;
	
	output reg [31:0] pc8_D, instr_D, pc_D;
	output reg [4:0] ExcCode_D;
	
	initial begin
		pc8_D = 0;
		instr_D = 0;
		pc_D = 0;
		ExcCode_D = 0;
	end
	
	always @(posedge clk) begin
		if (reset | (clr_D & En) | int_clr) begin
			pc8_D <= 0;
			instr_D <= 0;
			pc_D <= pc;
			ExcCode_D <= 0;
		end
		else begin
			if (En) begin
				pc8_D <= pc8;
				instr_D <= instr;
				pc_D <= pc;
				ExcCode_D <= ExcCode;
			end
		end
	end


endmodule
