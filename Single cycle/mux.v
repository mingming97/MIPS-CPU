`timescale 1ns / 1ps

module PCMux(nPc_sel, Zero, Branch, pc4, br_pc, jr_pc, j_pc, next_pc);
	
	input [1:0] nPc_sel;
	input Zero, Branch;
	input [31:0] pc4, br_pc, jr_pc, j_pc;

	output reg[31:0] next_pc;
	
	wire [2:0] pcsel;
	assign pcsel = {Zero&Branch, nPc_sel};

	always @(*) begin
		case (pcsel)
			3'b000 : next_pc = pc4;
			3'b100 : next_pc = br_pc;
			3'b010 : next_pc = jr_pc;
			3'b001 : next_pc = j_pc;
			default : next_pc = pc4;
		endcase
	end

endmodule


module WrRegAddrMux(RegDst, rt, rd, A3);

	input [1:0] RegDst;
	input [4:0] rt, rd;

	output reg[4:0] A3;

	always @(*) begin
		case (RegDst)
			2'b00 : A3 = rt;
			2'b01 : A3 = rd;
			2'b10 : A3 = 5'b11111;
			default : A3 = rt;
		endcase
	end

endmodule


module WrRegDataMux(MemtoReg, ALUResult, RD, Imm32_hbit, pc4, WD);
	
	input [1:0] MemtoReg;
	input [31:0] ALUResult, RD, Imm32_hbit, pc4;

	output reg[31:0] WD;

	always @(*) begin
		case (MemtoReg)
			2'b00 : WD = ALUResult;
			2'b01 : WD = RD;
			2'b10 : WD = Imm32_hbit;
			2'b11 : WD = pc4;
			default : WD = 32'h0000_0000;	
		endcase
	end

endmodule

module ALUsrc_AMux(ALUsrcA, RD1, RD2, A);
	
	input ALUsrcA;
	input [31:0] RD1, RD2;
	
	output [31:0] A;
	
	assign A = ALUsrcA ? RD2 : RD1;

endmodule

module ALUsrc_BMux(ALUsrcB, RD2, Imm32_lbit, B);

	input ALUsrcB;
	input [31:0] RD2, Imm32_lbit;

	output [31:0] B;

	assign B = ALUsrcB ? Imm32_lbit : RD2;
	
endmodule

