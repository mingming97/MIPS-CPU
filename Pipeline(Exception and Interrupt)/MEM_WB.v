`timescale 1ns / 1ps

module MEM_WB(
	clk, reset, int_clr, 
	pc8_M, instr_M, AO_M, RD1_M, RD2_M, RD3_M, RD_M, CP0O_M,
	pc8_W, instr_W, AO_W, RD1_W, RD2_W, RD3_W, RD_W, CP0O_W);
	
	input clk, reset, int_clr;
	input [31:0] pc8_M, instr_M, AO_M, RD1_M, RD2_M, RD3_M, RD_M, CP0O_M;
	output reg [31:0] pc8_W, instr_W, AO_W, RD1_W, RD2_W, RD3_W, RD_W, CP0O_W;
	
	initial begin
		pc8_W = 0;
		instr_W = 0;
		AO_W = 0;
		RD1_W = 0;
		RD2_W = 0;
		RD3_W = 0;
		RD_W = 0;
		CP0O_W = 0;
	end
	
	always @(posedge clk) begin
		if (reset | int_clr) begin
			pc8_W <= 0;
			instr_W <= 0;
			AO_W <= 0;
			RD1_W <= 0;
			RD2_W <= 0;
			RD3_W <= 0;
			RD_W <= 0;
			CP0O_W <= 0;
		end
		else begin
			pc8_W <= pc8_M;
			instr_W <= instr_M;
			AO_W <= AO_M;
			RD1_W <= RD1_M;
			RD2_W <= RD2_M;
			RD3_W <= RD3_M;
			RD_W <= RD_M;
			CP0O_W <= CP0O_M;	
		end
	end
	
endmodule
