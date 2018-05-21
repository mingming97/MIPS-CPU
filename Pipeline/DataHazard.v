`timescale 1ns / 1ps

`define Op 31:26
`define Funct 5:0
`define Rs 25:21
`define Rt 20:16
`define Rd 15:11
`define Br 20:16

`define BR    4'h1
`define JR    4'h2
`define JAL   4'h3
`define JALR  4'h4
`define LOAD  4'h5
`define STORE 4'h6
`define CAL_R 4'h7
`define CAL_I 4'h8
`define BRL   4'h9
`define MOV   4'ha

module TypeDef(instr, type, is_mul_div);
	
	input [31:0] instr;
	output [3:0] type;
	output is_mul_div;
	
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
	MOVZ  = 12'b000000_001010,
	BGEZAL = 11'b000001_10001,
	
	MFHI  = 12'b000000_010000,
	MFLO  = 12'b000000_010010,
	MTHI  = 12'b000000_010001,
	MTLO  = 12'b000000_010011,
	MULT  = 12'b000000_011000,
	MULTU = 12'b000000_011001,
	DIV   = 12'b000000_011010,
	DIVU  = 12'b000000_011011,
	
	MADD = 6'b011100;
	
	wire [5:0] Op, Funct;
	wire [4:0] Brtype;
	
	assign Op = instr[`Op];
	assign Funct = instr[`Funct];
	assign Brtype = instr[`Br];
	
	//instruction define
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
	wire movz;
	assign movz = ({Op, Funct} == MOVZ) ? 1 : 0;
	wire bgezal;
	assign bgezal = ({Op, Brtype} == BGEZAL) ? 1 : 0;
	
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
	
	wire madd;
	assign madd = (Op == MADD) ? 1 : 0;
	
	//type define
	wire br;
	assign br = beq|bne|blez|bgtz|bltz|bgez;
	wire jrr;
	assign jrr = jr;
	wire jall;
	assign jall = jal;
	wire jalrr;
	assign jalrr = jalr;
	wire load;
	assign load = lb|lbu|lh|lhu|lw;
	wire store;
	assign store = sb|sh|sw;
	wire cal_r;
	assign cal_r = add|addu|sub|subu|andd|orr|xorr|norr|
				   sll|srl|sra|sllv|srlv|srav|slt|sltu|
				   mult|multu|div|divu|mfhi|mflo|madd;
	wire cal_i;
	assign cal_i = addi|addiu|andi|ori|xori|
				   slti|sltiu|lui|mthi|mtlo;
	
	wire brl;
	assign brl = bgezal;
	
	wire mov;
	assign mov = movz;
	
	assign type = br    ? `BR :
				  jrr   ? `JR :
				  jall  ? `JAL :
				  jalrr ? `JALR :
				  load  ? `LOAD :
				  store ? `STORE :
				  cal_r ? `CAL_R :
				  cal_i ? `CAL_I : 
				  brl   ? `BRL   : 
				  mov   ? `MOV  : 0;
	
	assign is_mul_div = mult|multu|div|divu|mfhi|mflo|mthi|mtlo;

endmodule


module Stall(instr_D, instr_E, instr_M, Busy, Start, IF_ID_En, ID_EX_clr, PC_En);
	
	input [31:0] instr_D, instr_E, instr_M;
	input Busy, Start;
	output IF_ID_En, ID_EX_clr, PC_En;
	
	wire [3:0] type_D;
	wire is_mul_div_D;
	TypeDef t1(.instr(instr_D), .type(type_D), .is_mul_div(is_mul_div_D));

	wire [3:0] type_E;
	TypeDef t2(.instr(instr_E), .type(type_E));

	wire [3:0] type_M;
	TypeDef t3(.instr(instr_M), .type(type_M));
	
	wire stall_BR;
	assign stall_BR = type_D == `BR & (
					 (type_E == `CAL_R  & (instr_D[`Rs] == instr_E[`Rd] | instr_D[`Rt] == instr_E[`Rd]) & instr_E[`Rd] != 5'b00000) |
					 (type_E == `MOV    & (instr_D[`Rs] == instr_E[`Rd] | instr_D[`Rt] == instr_E[`Rd]) & instr_E[`Rd] != 5'b00000) |
					 (type_E == `CAL_I  & (instr_D[`Rs] == instr_E[`Rt] | instr_D[`Rt] == instr_E[`Rt]) & instr_E[`Rt] != 5'b00000) |
					 (type_E == `LOAD   & (instr_D[`Rs] == instr_E[`Rt] | instr_D[`Rt] == instr_E[`Rt]) & instr_E[`Rt] != 5'b00000) |
					 (type_M == `LOAD   & (instr_D[`Rs] == instr_M[`Rt] | instr_D[`Rt] == instr_M[`Rt]) & instr_M[`Rt] != 5'b00000) );
	
	wire stall_JR;
	assign stall_JR = type_D == `JR & (
					 (type_E == `CAL_R  & instr_D[`Rs] == instr_E[`Rd] & instr_E[`Rd] != 5'b00000) |
					 (type_E == `MOV    & instr_D[`Rs] == instr_E[`Rd] & instr_E[`Rd] != 5'b00000) |
					 (type_E == `CAL_I  & instr_D[`Rs] == instr_E[`Rt] & instr_E[`Rt] != 5'b00000) |
					 (type_E == `LOAD   & instr_D[`Rs] == instr_E[`Rt] & instr_E[`Rt] != 5'b00000) |
					 (type_M == `LOAD   & instr_D[`Rs] == instr_M[`Rt] & instr_M[`Rt] != 5'b00000) );
	
	wire stall_JALR;
	assign stall_JALR = type_D == `JALR & (
					   (type_E == `CAL_R  & instr_D[`Rs] == instr_E[`Rd] & instr_E[`Rd] != 5'b00000) |
					   (type_E == `MOV    & instr_D[`Rs] == instr_E[`Rd] & instr_E[`Rd] != 5'b00000) |
					   (type_E == `CAL_I  & instr_D[`Rs] == instr_E[`Rt] & instr_E[`Rt] != 5'b00000) |
					   (type_E == `LOAD   & instr_D[`Rs] == instr_E[`Rt] & instr_E[`Rt] != 5'b00000) |
					   (type_M == `LOAD   & instr_D[`Rs] == instr_M[`Rt] & instr_M[`Rt] != 5'b00000) );
					   
	wire stall_LOAD;
	assign stall_LOAD = type_D == `LOAD & (
					   (type_E == `LOAD & instr_D[`Rs] == instr_E[`Rt] & instr_E[`Rt] != 5'b00000) );

	wire stall_STORE;
	assign stall_STORE = type_D == `STORE & (
					    (type_E == `LOAD & instr_D[`Rs] == instr_E[`Rt] & instr_E[`Rt] != 5'b00000) );
	
	wire stall_CAL_R;  
	assign stall_CAL_R = type_D == `CAL_R & (
						(type_E == `LOAD & (instr_D[`Rs] == instr_E[`Rt] | instr_D[`Rt] == instr_E[`Rt]) & instr_E[`Rt] != 5'b00000) );

	wire stall_CAL_I;
	assign stall_CAL_I = type_D == `CAL_I & (
						(type_E == `LOAD & instr_D[`Rs] == instr_E[`Rt] & instr_E[`Rt] != 5'b00000) );
	
	wire stall_BRL;
	assign stall_BRL = type_D == `BRL & (
					  (type_E == `CAL_R  & instr_D[`Rs] == instr_E[`Rd] & instr_E[`Rd] != 5'b00000) |
					  (type_E == `MOV    & instr_D[`Rs] == instr_E[`Rd] & instr_E[`Rd] != 5'b00000) |
					  (type_E == `CAL_I  & instr_D[`Rs] == instr_E[`Rt] & instr_E[`Rt] != 5'b00000) |
					  (type_E == `LOAD   & instr_D[`Rs] == instr_E[`Rt] & instr_E[`Rt] != 5'b00000) |
					  (type_M == `LOAD   & instr_D[`Rs] == instr_M[`Rt] & instr_M[`Rt] != 5'b00000) );
	
	wire stall_MOV_rt;
	assign stall_MOV_rt = type_D == `MOV & (
					   (type_E == `CAL_R  & instr_D[`Rt] == instr_E[`Rd] & instr_E[`Rd] != 5'b00000) |
					   (type_E == `MOV    & instr_D[`Rt] == instr_E[`Rd] & instr_E[`Rd] != 5'b00000) |
					   (type_E == `CAL_I  & instr_D[`Rt] == instr_E[`Rt] & instr_E[`Rt] != 5'b00000) |
					   (type_E == `LOAD   & instr_D[`Rt] == instr_E[`Rt] & instr_E[`Rt] != 5'b00000) |
					   (type_M == `LOAD   & instr_D[`Rt] == instr_M[`Rt] & instr_M[`Rt] != 5'b00000) );
	
	wire stall_MOV_rs;
	assign stall_MOV_rs = type_D == `MOV & (
						 (type_E == `LOAD & instr_D[`Rs] == instr_E[`Rt] & instr_E[`Rt] != 5'b00000) );
	
	wire stall_hi_lo;
	assign stall_hi_lo = (Start | Busy) & is_mul_div_D;
					 	
	wire stall;
	assign stall = stall_BR | stall_JR | stall_JALR | stall_LOAD | stall_STORE | stall_CAL_R | stall_CAL_I | stall_BRL | 
				   stall_MOV_rt | stall_MOV_rs | stall_hi_lo;
	
	assign IF_ID_En = !stall;
	assign ID_EX_clr = stall;
	assign PC_En = !stall;

endmodule 

module Forward(
	instr_D, instr_E, instr_M, instr_W, // input
	ForwardRSD, ForwardRTD, ForwardRDD, ForwardRSE, ForwardRTE, ForwardRDE, ForwardRSM, ForwardRTM, ForwardRDM); //output 
	
	input [31:0] instr_D, instr_E, instr_M, instr_W;

	/*wire [3:0] type_D;
	TypeDef t7(.instr(instr_D), .type(type_D));*/

	wire [3:0] type_E;
	TypeDef t4(.instr(instr_E), .type(type_E));

	wire [3:0] type_M;
	TypeDef t5(.instr(instr_M), .type(type_M)); 

	wire [3:0] type_W;
	TypeDef t6(.instr(instr_W), .type(type_W));
	
	output [2:0] ForwardRSD;
	assign ForwardRSD = (type_E == `JALR  && instr_D[`Rs] == instr_E[`Rd] && instr_E[`Rd] != 5'b00000) ? 1 : //pc8_E
						(type_E == `JAL   && instr_D[`Rs] == 5'b11111)								   ? 1 : //pc8_E
						(type_E == `BRL   && instr_D[`Rs] == 5'b11111)								   ? 1 : //pc8_E
						(type_M == `JALR  && instr_D[`Rs] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 2 : //pc8_M
						(type_M == `JAL   && instr_D[`Rs] == 5'b11111)								   ? 2 : //pc8_M
						(type_M == `BRL   && instr_D[`Rs] == 5'b11111)								   ? 2 : //pc8_M
						(type_M == `CAL_R && instr_D[`Rs] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 3 : //AO_M
						(type_M == `MOV   && instr_D[`Rs] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 3 : //AO_M
						(type_M == `CAL_I && instr_D[`Rs] == instr_M[`Rt] && instr_M[`Rt] != 5'b00000) ? 3 : //AO_M
																										 0 ; //RD1_tmp

	output [2:0] ForwardRTD;
	assign ForwardRTD = (type_E == `JALR  && instr_D[`Rt] == instr_E[`Rd] && instr_E[`Rd] != 5'b00000) ? 1 : //pc8_E
						(type_E == `JAL   && instr_D[`Rt] == 5'b11111)								   ? 1 : //pc8_E
						(type_E == `BRL   && instr_D[`Rt] == 5'b11111)								   ? 1 : //pc8_E
						(type_M == `JALR  && instr_D[`Rt] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 2 : //pc8_M
						(type_M == `JAL   && instr_D[`Rt] == 5'b11111)								   ? 2 : //pc8_M
						(type_M == `BRL   && instr_D[`Rt] == 5'b11111)								   ? 2 : //pc8_M						
						(type_M == `CAL_R && instr_D[`Rt] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 3 : //AO_M
						(type_M == `MOV   && instr_D[`Rt] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 3 : //AO_M
						(type_M == `CAL_I && instr_D[`Rt] == instr_M[`Rt] && instr_M[`Rt] != 5'b00000) ? 3 : //AO_M
																										 0 ; //RD2_tmp
	
	output [2:0] ForwardRDD;
	assign ForwardRDD = (type_E == `JALR  && instr_D[`Rd] == instr_E[`Rd] && instr_E[`Rd] != 5'b00000) ? 1 : //pc8_E
						(type_E == `JAL   && instr_D[`Rd] == 5'b11111)								   ? 1 : //pc8_E
						(type_E == `BRL   && instr_D[`Rd] == 5'b11111)								   ? 1 : //pc8_E
						(type_M == `JALR  && instr_D[`Rd] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 2 : //pc8_M
						(type_M == `JAL   && instr_D[`Rd] == 5'b11111)								   ? 2 : //pc8_M
						(type_M == `BRL   && instr_D[`Rd] == 5'b11111)								   ? 2 : //pc8_M
						(type_M == `CAL_R && instr_D[`Rd] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 3 : //AO_M
						(type_M == `MOV   && instr_D[`Rd] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 3 : //AO_M
						(type_M == `CAL_I && instr_D[`Rd] == instr_M[`Rt] && instr_M[`Rt] != 5'b00000) ? 3 : //AO_M
																										 0 ; //RD2_tmp
	

	output [2:0] ForwardRSE;
	assign ForwardRSE = (type_M == `JALR  && instr_E[`Rs] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 1 : //pc8_M
						(type_M == `JAL   && instr_E[`Rs] == 5'b11111)								   ? 1 : //pc8_M
						(type_M == `BRL   && instr_E[`Rs] == 5'b11111)								   ? 1 : //pc8_M
						(type_M == `CAL_R && instr_E[`Rs] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 2 : //AO_M
						(type_M == `MOV   && instr_E[`Rs] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 2 : //AO_M
						(type_M == `CAL_I && instr_E[`Rs] == instr_M[`Rt] && instr_M[`Rt] != 5'b00000) ? 2 : //AO_M	
						(type_W == `JALR  && instr_E[`Rs] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 3 : //pc8_W
						(type_W == `JAL   && instr_E[`Rs] == 5'b11111)								   ? 3 : //pc8_W
						(type_W == `BRL   && instr_E[`Rs] == 5'b11111)								   ? 3 : //pc8_W
						(type_W == `CAL_R && instr_E[`Rs] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 3 : //AO_W
						(type_W == `MOV   && instr_E[`Rs] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 3 : //AO_W
						(type_W == `CAL_I && instr_E[`Rs] == instr_W[`Rt] && instr_W[`Rt] != 5'b00000) ? 3 : //AO_W	
						(type_W == `LOAD  && instr_E[`Rs] == instr_W[`Rt] && instr_W[`Rt] != 5'b00000) ? 3 : //RD_W	
																										 0 ; //RD1_E

	output [2:0] ForwardRTE;
	assign ForwardRTE = (type_M == `JALR  && instr_E[`Rt] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 1 : //pc8_M
						(type_M == `JAL   && instr_E[`Rt] == 5'b11111)								   ? 1 : //pc8_M
						(type_M == `BRL   && instr_E[`Rt] == 5'b11111)								   ? 1 : //pc8_M
						(type_M == `CAL_R && instr_E[`Rt] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 2 : //AO_M
						(type_M == `MOV   && instr_E[`Rt] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 2 : //AO_M
						(type_M == `CAL_I && instr_E[`Rt] == instr_M[`Rt] && instr_M[`Rt] != 5'b00000) ? 2 : //AO_M	
						(type_W == `JALR  && instr_E[`Rt] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 3 : //pc8_W
						(type_W == `JAL   && instr_E[`Rt] == 5'b11111)								   ? 3 : //pc8_W
						(type_W == `BRL   && instr_E[`Rt] == 5'b11111)								   ? 3 : //pc8_W
						(type_W == `CAL_R && instr_E[`Rt] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 3 : //AO_W
						(type_W == `MOV   && instr_E[`Rt] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 3 : //AO_W
						(type_W == `CAL_I && instr_E[`Rt] == instr_W[`Rt] && instr_W[`Rt] != 5'b00000) ? 3 : //AO_W	
						(type_W == `LOAD  && instr_E[`Rt] == instr_W[`Rt] && instr_W[`Rt] != 5'b00000) ? 3 : //RD_W	
																										 0 ; //RD2_E

	output [2:0] ForwardRDE;
	assign ForwardRDE = (type_M == `JALR  && instr_E[`Rd] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 1 : //pc8_M
						(type_M == `JAL   && instr_E[`Rd] == 5'b11111)								   ? 1 : //pc8_M
						(type_M == `BRL   && instr_E[`Rd] == 5'b11111)								   ? 1 : //pc8_M
						(type_M == `CAL_R && instr_E[`Rd] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 2 : //AO_M
						(type_M == `MOV   && instr_E[`Rd] == instr_M[`Rd] && instr_M[`Rd] != 5'b00000) ? 2 : //AO_M
						(type_M == `CAL_I && instr_E[`Rd] == instr_M[`Rt] && instr_M[`Rt] != 5'b00000) ? 2 : //AO_M	
						(type_W == `JALR  && instr_E[`Rd] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 3 : //pc8_W
						(type_W == `JAL   && instr_E[`Rd] == 5'b11111)								   ? 3 : //pc8_W
						(type_W == `BRL   && instr_E[`Rd] == 5'b11111)								   ? 3 : //pc8_W
						(type_W == `CAL_R && instr_E[`Rd] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 3 : //AO_W
						(type_W == `MOV   && instr_E[`Rd] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 3 : //AO_W
						(type_W == `CAL_I && instr_E[`Rd] == instr_W[`Rt] && instr_W[`Rt] != 5'b00000) ? 3 : //AO_W	
						(type_W == `LOAD  && instr_E[`Rd] == instr_W[`Rt] && instr_W[`Rt] != 5'b00000) ? 3 : //RD_W	
																										 0 ; //RD2_E	

	output [2:0] ForwardRSM;
	assign ForwardRSM = (type_W == `JALR  && instr_M[`Rs] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 1 : //pc8_W
						(type_W == `JAL   && instr_M[`Rs] == 5'b11111)								   ? 1 : //pc8_W
						(type_W == `BRL   && instr_M[`Rs] == 5'b11111)								   ? 1 : //pc8_W
						(type_W == `CAL_R && instr_M[`Rs] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 1 : //AO_W
						(type_W == `MOV   && instr_M[`Rs] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 1 : //AO_W
						(type_W == `CAL_I && instr_M[`Rs] == instr_W[`Rt] && instr_W[`Rt] != 5'b00000) ? 1 : //AO_W	
						(type_W == `LOAD  && instr_M[`Rs] == instr_W[`Rt] && instr_W[`Rt] != 5'b00000) ? 1 : //RD_W	
																										 0 ; //RD1_M

	output [2:0] ForwardRTM;
	assign ForwardRTM = (type_W == `JALR  && instr_M[`Rt] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 1 : //pc8_W
						(type_W == `JAL   && instr_M[`Rt] == 5'b11111)								   ? 1 : //pc8_W
						(type_W == `BRL   && instr_M[`Rt] == 5'b11111)								   ? 1 : //pc8_W
						(type_W == `CAL_R && instr_M[`Rt] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 1 : //AO_W
						(type_W == `MOV   && instr_M[`Rt] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 1 : //AO_W
						(type_W == `CAL_I && instr_M[`Rt] == instr_W[`Rt] && instr_W[`Rt] != 5'b00000) ? 1 : //AO_W	
						(type_W == `LOAD  && instr_M[`Rt] == instr_W[`Rt] && instr_W[`Rt] != 5'b00000) ? 1 : //RD_W	
																										 0 ; //RD2_M

	output [2:0] ForwardRDM;
	assign ForwardRDM = (type_W == `JALR  && instr_M[`Rd] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 1 : //pc8_W
						(type_W == `JAL   && instr_M[`Rd] == 5'b11111)								   ? 1 : //pc8_W
						(type_W == `BRL   && instr_M[`Rd] == 5'b11111)								   ? 1 : //pc8_W
						(type_W == `CAL_R && instr_M[`Rd] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 1 : //AO_W
						(type_W == `MOV   && instr_M[`Rd] == instr_W[`Rd] && instr_W[`Rd] != 5'b00000) ? 1 : //AO_W
						(type_W == `CAL_I && instr_M[`Rd] == instr_W[`Rt] && instr_W[`Rt] != 5'b00000) ? 1 : //AO_W	
						(type_W == `LOAD  && instr_M[`Rd] == instr_W[`Rt] && instr_W[`Rt] != 5'b00000) ? 1 : //RD_W	
																										 0 ; //RD2_M
endmodule																								 



