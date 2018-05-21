`timescale 1ns / 1ps

`define Op 31:26
`define Funct 5:0
`define Br 20:16
`define C0 25:21

module InstrDetect(instr_D_tmp, ExcCode, instr_D);

	
	input [31:0] instr_D_tmp;
	
	output [31:0] instr_D;
	output [4:0] ExcCode;
	
	assign instr_D = is_legal ? instr_D_tmp : 32'b0;
	
	assign ExcCode = is_legal ? 5'b0 : 5'ha;
	
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
	
	wire [5:0] Op, Funct;
	wire [4:0] Brtype;
	wire [4:0] C0type;
	
	assign Op = instr_D_tmp[`Op];
	assign Funct = instr_D_tmp[`Funct];
	assign Brtype = instr_D_tmp[`Br];
	assign C0type = instr_D_tmp[`C0];
	
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
	assign eret = (instr_D_tmp == ERET) ? 1 : 0;
	

	wire is_legal;
	assign is_legal = add|addi|addiu|addu|andd|andi|beq|bgez|bgtz|blez|
					  bltz|bne|j|jal|jalr|jr|lb|lbu|lh|lhu|lui|lw|norr|
					  orr|ori|sb|sh|sll|sllv|slt|slti|sltiu|sltu|sra|srav|
					  srl|srlv|sub|subu|sw|xorr|xori|mfhi|mflo|mthi|mtlo|
					  mult|multu|div|divu|mfc0|mtc0|eret;

	
endmodule
