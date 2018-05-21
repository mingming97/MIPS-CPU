`timescale 1ns / 1ps

module NPC(
	Imm32, Imm28, pc8_D, jr_pc_i, epc_i, 
	br_pc, j_pc, jr_pc, epc);
	
	input [31:0] pc8_D;
	input [31:0] Imm32;
	input [27:0] Imm28;
	input [31:0] jr_pc_i;
	input [31:0] epc_i;
	
	output [31:0] jr_pc;
	output [31:0] br_pc;
	output [31:0] j_pc;
	output [31:0] epc;
	
	wire [31:0] tmp;
	
	assign jr_pc = jr_pc_i;
	assign br_pc = pc8_D - 4 + (Imm32 << 2);
	
	assign tmp = pc8_D - 8;
	assign j_pc = {tmp[31:28], Imm28[27:0]};
	
	assign epc = epc_i;


endmodule
