`timescale 1ns / 1ps

module PCadd(now_pc, pc4, pc8);
	
	input [31:0] now_pc;
	output [31:0] pc4;
	output [31:0] pc8;
	
	assign pc4 = now_pc + 4;
	assign pc8 = now_pc + 8;

endmodule
