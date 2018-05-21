`timescale 1ns / 1ps

`define rs 25:21
`define rt 20:16
`define rd 15:11
`define imm16 15:0
`define imm26 25:0
`define funct 5:0
`define op 31:26

module mips(clk, reset);
	
	input clk, reset;

	//pc
	wire [31:0] now_pc;

	//im
	wire [31:0] instr;

	//cu
	wire [1:0] ExtOp;
	wire ALUsrcA;
	wire ALUsrcB;
	wire MemWr;
	wire [1:0] MemtoReg;
	wire RegWr;
	wire [1:0] RegDst;
	wire [1:0] nPc_sel;
	wire [2:0] ALUctr;
	wire Branch;
	wire Comp;
	wire [1:0] save_Sel;
	wire [2:0] load_Sel;

	//WRAmux
	wire [4:0] A3;

	//grf
	wire [31:0] RD1, RD2;

	//ext
	wire [27:0] Imm28;
	wire [31:0] Imm32_lbit, Imm32_hbit;

	//alu_src_mux
	wire [31:0] A, B;

	//alu
	wire [31:0] ALUResult;
	wire Zero;

	//npc
	wire [31:0] pc4, br_pc, j_pc, jr_pc;

	//pcmux
	wire [31:0] next_pc;

	//dm
	wire [31:0] RD;

	//WRDmux
	wire [31:0] WD;

	
	PC pc(
		.clk(clk),
		.reset(reset),
		.next_pc(next_pc),
		
		.now_pc(now_pc));
	
	IM im(
		.Addr(now_pc),
		
		.instr(instr));
		
	ControlUnit cu(
		.Op(instr[`op]),
		.Funct(instr[`funct]),
		
		.ExtOp(ExtOp), 
		.ALUsrcA(ALUsrcA),
		.ALUsrcB(ALUsrcB), 
		.ALUctr(ALUctr), 
		.MemWr(MemWr), 
		.MemtoReg(MemtoReg), 
		.RegDst(RegDst), 
		.RegWr(RegWr), 
		.nPc_sel(nPc_sel),
		.Branch(Branch),
		.Comp(Comp),
		.load_Sel(load_Sel),
		.save_Sel(save_Sel));
	
	WrRegAddrMux WRAmux(
		.RegDst(RegDst),
		.rt(instr[`rt]),
		.rd(instr[`rd]),
		
		.A3(A3));
	
	GRF grf(
		.clk(clk),
		.reset(reset),
		.RegWr(RegWr),
		.A1(instr[`rs]),
		.A2(instr[`rt]),
		.A3(A3),
		.WD(WD),
		.now_pc(now_pc),
		
		.RD1(RD1),
		.RD2(RD2));
	
	Compare cmp(
		.RD1(RD1),
		.RD2(RD2),
		.Comp(Comp),
		
		.Zero(Zero));
	
	EXT ext(
		.Imm16(instr[`imm16]),
		.Imm26(instr[`imm26]),
		.ExtOp(ExtOp),
		
		.Imm28(Imm28),
		.Imm32_lbit(Imm32_lbit),
		.Imm32_hbit(Imm32_hbit));
	
	ALUsrc_AMux alu_srca_mux(
		.ALUsrcA(ALUsrcA),
		.RD1(RD1),
		.RD2(RD2),
		
		.A(A));
	
	ALUsrc_BMux alu_srcb_mux(
		.ALUsrcB(ALUsrcB),
		.RD2(RD2),
		.Imm32_lbit(Imm32_lbit),
		
		.B(B));
	
	ALU alu(
		.A(A),
		.B(B),
		.ALUctr(ALUctr),
		
		.ALUResult(ALUResult));
	
	NPC npc(
		.Imm32(Imm32_lbit),
		.Imm28(Imm28),
		.now_pc(now_pc),
		.jr_pc_i(RD1),
		
		.pc4(pc4),
		.br_pc(br_pc),
		.j_pc(j_pc),
		.jr_pc(jr_pc));
	
	PCMux pcmux(
		.nPc_sel(nPc_sel),
		.Branch(Branch),
		.Zero(Zero),
		.pc4(pc4),
		.br_pc(br_pc),
		.jr_pc(jr_pc),
		.j_pc(j_pc),
		
		.next_pc(next_pc));
	
	DM dm(
		.clk(clk),
		.reset(reset),
		.Addr(ALUResult),
		.WD(RD2),
		.MemWr(MemWr),
		.now_pc(now_pc),
		.load_Sel(load_Sel),
		.save_Sel(save_Sel),
		
		.RD(RD));
	
	WrRegDataMux WRDmux(
		.MemtoReg(MemtoReg),
		.ALUResult(ALUResult),
		.RD(RD),
		.Imm32_hbit(Imm32_hbit),
		.pc4(pc4),
		
		.WD(WD));
	
	
endmodule
