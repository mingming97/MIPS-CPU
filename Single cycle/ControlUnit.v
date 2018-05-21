`timescale 1ns / 1ps

module ControlUnit( 
	Op, Funct,//input 
	ExtOp, ALUsrcA, ALUsrcB, ALUctr, MemWr, MemtoReg, RegDst, RegWr, nPc_sel, Branch, Comp, save_Sel, load_Sel); //output
	parameter 
	ADDU =12'b000000_100001,
	SUBU =12'b000000_100011,
	JR   =12'b000000_001000,
	SRA  =12'b000000_000011, 
	SW   =6'b101011,
	LW 	 =6'b100011,
	ORI  =6'b001101,
	BEQ  =6'b000100,
	LUI  =6'b001111,
	J 	 =6'b000010,
	JAL  =6'b000011,
	LB    = 6'b100000,
	LBU   = 6'b100100,
	LH    = 6'b100001,
	LHU   = 6'b100101,
	SB    = 6'b101000,
	SH    = 6'b101001;
	
	input [5:0] Op, Funct;
	
	wire addu;
	assign addu = ({Op, Funct} == ADDU) ? 1 : 0;
	wire subu;
	assign subu = ({Op, Funct} == SUBU) ? 1 : 0;
	wire jr;
	assign jr = ({Op, Funct} == JR) ? 1 : 0;
	wire sw;
	assign sw = (Op == SW) ? 1 : 0;
	wire lw;
	assign lw = (Op == LW) ? 1 : 0;
	wire ori;
	assign ori = (Op == ORI) ? 1 : 0;
	wire beq;
	assign beq = (Op == BEQ) ? 1 : 0;
	wire lui;
	assign lui = (Op == LUI) ? 1 : 0;
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
	wire sb;
	assign sb = (Op == SB) ? 1 : 0;
	wire sh;
	assign sh = (Op == SH) ? 1 : 0;
	wire sra;
	assign sra = ({Op, Funct} == SRA) ? 1 : 0;
	
	
	output [1:0] ExtOp; 
	assign ExtOp = {sra, lw|sw|beq|sb|sh|lb|lbu|lh|lhu}; //00:'Zero' 01:'Sign' 10:'for shift'
	
	output ALUsrcA;
	assign ALUsrcA = sra;//0:'RD1'  1: 'RD2'
	
	output ALUsrcB; 
	assign ALUsrcB = ori|lw|sw|sb|sh|lhu|lh|lbu|lb|sra; //0:'RD2' 1:'EXT'
	
	output MemWr; 
	assign MemWr = sw|sb|sh;
	
	output [1:0] MemtoReg; 
	assign MemtoReg = {lui|jal, lw|jal|lb|lbu|lh|lhu}; //00:'ALU' 01:'Mem' 10:'EXT'(for lui) 11:'PC+4'
	
	output RegWr; 
	assign RegWr = addu|subu|ori|lw|jal|lui|lb|lbu|lh|lhu|sra;
	
	output [1:0] RegDst; 
	assign RegDst = {jal, addu|subu|sra}; //00:'rt' 01:'rd' 10:'$ra'
	
	output [1:0] nPc_sel; 
	assign nPc_sel =  {jr, j|jal}; //10:'jr' 01:'j, jal'
								   //+Branch&Zero: 000:'+4' 100:'br_pc' 010:'jr' 001:'j/jal'	
	
	output Branch;
	assign Branch = beq;
	
	output [2:0] ALUctr; 
	assign ALUctr = {sra, ori, subu|sra}; //000:'+' 001:'-' 010:'|' 011:'&' 100:"slt" 101:'sra'
	
	output Comp;
	assign Comp = beq;
	
	output [1:0] save_Sel;
	assign save_Sel = {sh, sb}; // 00:'sw' 01:'sb' 10:'sh'

	output [2:0] load_Sel;
	assign load_Sel = {lhu, lh|lbu, lb|lbu}; // 000:'lw' 001:'lb' 010:'lh' 011:'lbu' 100:'lhu'

endmodule
