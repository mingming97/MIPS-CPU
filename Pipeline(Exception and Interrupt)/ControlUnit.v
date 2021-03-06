`timescale 1ns / 1ps

`define Op 31:26
`define Funct 5:0
`define Br 20:16
`define C0 25:21

module ControlUnit(
	instr, 
	Comp, Branch, nPc_sel, ExtOp, clr_D,
	ALUctr, ALUsrc_A, ALUsrc_B, AO_Sel, MD_ctr, Start, EnOverflow, Enmultdiv, is_load_E, is_save_E, 
	MemWr, save_Sel, CP0_WE, is_load_M, is_save_M, is_loadb, is_saveb, EXLClr,
	load_Sel, RegWr, RegDst, MemtoReg, is_delay_slot);
	
	parameter 
	ADD   = 12'b000000_100000,
	ADDI  = 6'b001000,
	ADDIU = 6'b001001,
	ADDU  = 12'b000000_100001,
	AND   = 12'b000000_100100,
	ANDI  = 6'b001100,
	BEQ   = 6'b000100,
	BGEZ  = 11'b000001_00001,
	BGTZ  = 11'b000111_00000,
	BLEZ  = 11'b000110_00000,
	BLTZ  = 11'b000001_00000,
	BNE   = 6'b000101,
	J     = 6'b000010,
	JAL   = 6'b000011,
	JALR  = 12'b000000_001001,
	JR    = 12'b000000_001000,
	LB    = 6'b100000,
	LBU   = 6'b100100,
	LH    = 6'b100001,
	LHU   = 6'b100101,
	LUI   = 6'b001111,
	LW    = 6'b100011,
	NOR   = 12'b000000_100111,
	OR    = 12'b000000_100101,
	ORI   = 6'b001101,
	SB    = 6'b101000,
	SH    = 6'b101001,
	SLL   = 12'b000000_000000,
	SLLV  = 12'b000000_000100,
	SLT   = 12'b000000_101010,
	SLTI  = 6'b001010,
	SLTIU = 6'b001011,
	SLTU  = 12'b000000_101011,
	SRA   = 12'b000000_000011,
	SRAV  = 12'b000000_000111,
	SRL   = 12'b000000_000010,
	SRLV  = 12'b000000_000110,
	SUB   = 12'b000000_100010,
	SUBU  = 12'b000000_100011,
	SW    = 6'b101011,
	XOR   = 12'b000000_100110,
	XORI  = 6'b001110,
	
	MFHI  = 12'b000000_010000,
	MFLO  = 12'b000000_010010,
	MTHI  = 12'b000000_010001,
	MTLO  = 12'b000000_010011,
	MULT  = 12'b000000_011000,
	MULTU = 12'b000000_011001,
	DIV   = 12'b000000_011010,
	DIVU  = 12'b000000_011011,
	
	MFC0  = 11'b010000_00000,
	MTC0  = 11'b010000_00100,
	ERET  = 32'b010000_1000_0000_0000_0000_0000_011000;
	
	input [31:0] instr;
	
	wire [5:0] Op, Funct;
	wire [4:0] Brtype;
	wire [4:0] C0type;
	
	assign Op = instr[`Op];
	assign Funct = instr[`Funct];
	assign Brtype = instr[`Br];
	assign C0type = instr[`C0];
	
	wire add;
	assign add = ({Op, Funct} == ADD) ? 1 : 0;
	wire addu;
	assign addu = ({Op, Funct} == ADDU) ? 1 : 0;
	wire andd;
	assign andd = ({Op, Funct} == AND) ? 1 : 0;
	wire bgez;
	assign bgez = ({Op, Brtype} == BGEZ) ? 1 : 0;
	wire bgtz;
	assign bgtz = ({Op, Brtype} == BGTZ) ? 1 : 0;
	wire blez;
	assign blez = ({Op, Brtype} == BLEZ) ? 1 : 0;
	wire bltz;
	assign bltz = ({Op, Brtype} == BLTZ) ? 1 : 0;
	wire jalr;
	assign jalr = ({Op, Funct} == JALR) ? 1 : 0;
	wire jr;
	assign jr = ({Op, Funct} == JR) ? 1 : 0;
	wire norr;
	assign norr = ({Op, Funct} == NOR) ? 1 : 0;
	wire orr;
	assign orr = ({Op, Funct} == OR) ? 1 : 0;
	wire sll;
	assign sll = ({Op, Funct} == SLL) ? 1 : 0;
	wire sllv;
	assign sllv = ({Op, Funct} == SLLV) ? 1 : 0;
	wire slt;
	assign slt = ({Op, Funct} == SLT) ? 1 : 0;
	wire sltu;
	assign sltu = ({Op, Funct} == SLTU) ? 1 : 0;
	wire sra;
	assign sra = ({Op, Funct} == SRA) ? 1 : 0;
	wire srav;
	assign srav = ({Op, Funct} == SRAV) ? 1 : 0;
	wire srl;
	assign srl = ({Op, Funct} == SRL) ? 1 : 0;
	wire srlv;
	assign srlv = ({Op, Funct} == SRLV) ? 1 : 0;
	wire sub;
	assign sub = ({Op, Funct} == SUB) ? 1 : 0;
	wire subu;
	assign subu = ({Op, Funct} == SUBU) ? 1 : 0;
	wire xorr;
	assign xorr = ({Op, Funct} == XOR) ? 1 : 0;
	wire addi;
	assign addi = (Op == ADDI) ? 1 : 0;
	wire addiu;
	assign addiu = (Op == ADDIU) ? 1 : 0;
	wire andi;
	assign andi = (Op == ANDI) ? 1 : 0;
	wire beq;
	assign beq = (Op == BEQ) ? 1 : 0;
	wire bne;
	assign bne = (Op == BNE) ? 1 : 0;
	wire j;
	assign j = (Op == J) ? 1 : 0;
	wire jal;
	assign jal = (Op == JAL) ? 1 : 0;
	wire lb;
	assign lb = (Op == LB) ? 1 : 0;
	wire lbu;
	assign lbu = (Op == LBU) ? 1 : 0;
	wire lh;
	assign lh = (Op == LH) ? 1 : 0;
	wire lhu;
	assign lhu = (Op == LHU) ? 1 : 0;
	wire lui;
	assign lui = (Op == LUI) ? 1 : 0;
	wire lw;
	assign lw = (Op == LW) ? 1 : 0;
	wire ori;
	assign ori = (Op == ORI) ? 1 : 0;
	wire sb;
	assign sb = (Op == SB) ? 1 : 0;
	wire sh;
	assign sh = (Op == SH) ? 1 : 0;
	wire slti;
	assign slti = (Op == SLTI) ? 1 : 0;
	wire sltiu;
	assign sltiu = (Op == SLTIU) ? 1 : 0;
	wire sw;
	assign sw = (Op == SW) ? 1 : 0;
	wire xori;
	assign xori = (Op == XORI) ? 1 : 0;
	
	wire mfhi;
	assign mfhi = ({Op, Funct} == MFHI) ? 1 : 0;
	wire mflo;
	assign mflo = ({Op, Funct} == MFLO) ? 1 : 0;
	wire mthi;
	assign mthi = ({Op, Funct} == MTHI) ? 1 : 0;
	wire mtlo;
	assign mtlo = ({Op, Funct} == MTLO) ? 1 : 0;
	wire mult;
	assign mult = ({Op, Funct} == MULT) ? 1 : 0;
	wire multu;
	assign multu = ({Op, Funct} == MULTU) ? 1 : 0;
	wire div;
	assign div = ({Op, Funct} == DIV) ? 1 : 0;
	wire divu;
	assign divu = ({Op, Funct} == DIVU) ? 1 : 0;
	
	wire mtc0;
	assign mtc0 = ({Op, C0type} == MTC0) ? 1 : 0;
	wire mfc0;
	assign mfc0 = ({Op, C0type} == MFC0) ? 1 : 0;
	wire eret;
	assign eret = (instr == ERET) ? 1 : 0;
	
	output [2:0] Comp;
	assign Comp = {bltz|bgez, blez|bgtz, bne|bgtz|bgez};
	// 000:'beq' 001:'bne' 010:'blez' 011:'bgtz' 100:'bltz' 101:'bgez' 

	output Branch;
	assign Branch = beq|bne|blez|bgtz|bltz|bgez;
	
	output [1:0] nPc_sel;
	assign nPc_sel = {jr|jalr|eret, j|jal|eret}; //10: 'jr|jalr' 01:'j/jal' 11:'eret'
	// +Branch&Zero: 000:'pc+4' 100:'br_pc' 010:'jr|jalr'  001:'j/jal'
	
	output [1:0] ExtOp;
	assign ExtOp = {sll|srl|sra,
					lb|lbu|lh|lhu|lw|sb|sh|sw|addi|addiu|slti|sltiu|beq|bne|blez|bgez|bltz|bgez};
	// 00:'Zero' 01:'Sign' 10:'Shift'(for sll/srl/sra)
	
	output clr_D;
	assign clr_D = eret;
	
	output [3:0] ALUctr;
	assign ALUctr = {sra|srav|srl|srlv|slt|slti|sltu|sltiu,
					 xorr|xori|norr|sll|sllv|slt|slti|sltu|sltiu,
					 orr|ori|andd|andi|sll|sllv|srl|srlv,
					 sub|subu|andd|andi|norr|sllv|srav|srlv|sltu|sltiu};
	// 0000:'+' 0001:'-' 0010:'|' 0011:'&' 0100:'^' 0101:'nor' 0110:'<<'(sll) 0111:'<<'(sllv) 
	// 1000:'>>>'(sra) 1001:'>>>'(srav) 1010:'srl' 1011:'srlv' 1100:'slt/slti' 1101:'sltu/sltiu'
	
	output EnOverflow;
	assign EnOverflow = add | sub | addi | is_load_E | is_save_E ;
		
	output ALUsrc_A;
	assign ALUsrc_A = sll|sra|srl; 
	// 0:'RD1' 1:'RD2'(for sll/sra/srl instrs)
	
	output ALUsrc_B;
	assign ALUsrc_B = lb|lbu|lh|lhu|lw|sb|sh|sw|sll|srl|sra|addi|addiu|andi|ori|xori|slti|sltiu;
	// 0:'RD2' 1:'Imm32_lbit'
	
	output [2:0] AO_Sel;
	assign AO_Sel = {mflo, mfhi, lui|mfhi};
	// 000:'AO_tmp' 001:'Imm32_hbit_E' 011:'HIO' 100:'LOO'
	
	output Start;
	assign Start = mult|multu|div|divu;
	
	output Enmultdiv;
	assign Enmultdiv = mult|multu|div|divu|mthi|mtlo;
	
	output [2:0] MD_ctr;
	assign MD_ctr = {mthi|mtlo, div|divu, multu|divu|mtlo}; 
	// 000:'mult' 001:'multu' 010:'div' 011:'divu' 100:'mthi' 101:'mtlo'
	
	output is_load_E;
	assign is_load_E = lw|lb|lbu|lh|lhu;
	
	output is_save_E;
	assign is_save_E = sw|sb|sh;
	
	output MemWr;
	assign MemWr = sw|sb|sh;
	
	output [1:0] save_Sel;
	assign save_Sel = {sh, sb}; 
	// 00:'sw', 01:'sb', 10:'sh'
	
	output [2:0] load_Sel;
	assign load_Sel = {lhu, lh|lbu, lb|lbu};
	// 000:'lw' 001:'lb' 010:'lh' 011:'lbu' 100:'lhu'
	
	output is_load_M;
	assign is_load_M = lw|lb|lbu|lh|lhu;
	
	output is_loadb;
	assign is_loadb = lb|lbu|lh|lhu;
	
	output is_save_M;
	assign is_save_M = sw|sb|sh;
	
	output is_saveb;
	assign is_saveb = sb|sh;
	
	output [1:0] MemtoReg;
	assign MemtoReg = {jal|jalr|mfc0, lw|lb|lh|lbu|lhu|mfc0};
	// 00:'AO' 01:'DM' 10: 'PC8' 11:'mfc0'
	
	output CP0_WE;
	assign CP0_WE = mtc0;

	output EXLClr;
	assign EXLClr = eret;
	
	output [1:0] RegDst;
	assign RegDst = {jal, 
					 jalr|add|addu|sub|subu|slt|sltu|sll|srl|sra|sllv|srlv|srav|andd|orr|xorr|norr|mfhi|mflo};
	// 00:'rt' 01:'rd' 10:'$ra'(for jal)
	
	output RegWr;
	assign RegWr = !(sb|sh|sw|beq|bne|blez|bgtz|bltz|bgez|j|mthi|mtlo|mult|multu|div|divu|mtc0|eret);
	
	output is_delay_slot;
	assign is_delay_slot = j|jr|jalr|jal|beq|bne|blez|bgtz|bltz|bgez;
	
	
endmodule
