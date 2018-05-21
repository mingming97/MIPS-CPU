`timescale 1ns / 1ps

module IF_ID(
	clk, reset, En, clr,
	pc8, instr,
	pc8_D, instr_D);
	
	input clk, reset, En, clr;
	input [31:0] pc8, instr;
	
	output reg [31:0] pc8_D, instr_D;
	
	initial begin
		pc8_D = 0;
		instr_D = 0;
	end
	
	always @(posedge clk) begin
		if (reset | clr) begin
			pc8_D <= 0;
			instr_D <= 0;
		end
		else begin
			if (En) begin
				pc8_D <= pc8;
				instr_D <= instr;
			end
		end
	end


endmodule
