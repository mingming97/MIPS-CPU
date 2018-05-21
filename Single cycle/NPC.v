`timescale 1ns / 1ps

module NPC(now_pc, Imm32, Imm28, jr_pc_i,
		   pc4, br_pc, j_pc, jr_pc);

	input [31:0] now_pc;
	input [27:0] Imm28;
	input [31:0] Imm32, jr_pc_i;
	
	output [31:0] pc4, br_pc, j_pc, jr_pc;
	
	assign pc4 = now_pc + 4;
	assign br_pc = pc4 + (Imm32 << 2);
	assign j_pc = {now_pc[31:28], Imm28};  //j/jal
	assign jr_pc = jr_pc_i;

endmodule
