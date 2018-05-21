`timescale 1ns / 1ps

module PCMux(nPc_sel, Zero, Branch, pc4, br_pc, jr_pc, j_pc, next_pc);
	
	input [1:0] nPc_sel;
	input Branch;
	input Zero;
	input [31:0] pc4, br_pc, jr_pc, j_pc;
	
	output reg [31:0] next_pc;
	
	wire [2:0] pcsel;
	assign pcsel = {Zero&Branch, nPc_sel};
	
	always @(*) begin
		case (pcsel)
			3'b000: next_pc = pc4;
			3'b100: next_pc = br_pc;
			3'b010: next_pc = jr_pc;
			3'b001: next_pc = j_pc;
			default: next_pc = pc4;
		endcase
	end

endmodule


module ALUsrc_AMux(ALUsrc_A, RD1, RD2, A);
	
	input ALUsrc_A;
	input [31:0] RD1, RD2;
	
	output [31:0] A;
	
	assign A = ALUsrc_A ? RD2 : RD1;

endmodule


module ALUsrc_BMux(ALUsrc_B, RD2, Imm32_lbit, B);
	
	input ALUsrc_B;
	input [31:0] RD2, Imm32_lbit;
	
	output [31:0] B;
	
	assign B = ALUsrc_B ? Imm32_lbit : RD2;
		
endmodule


module AO_Mux(AO_Sel, AO_tmp, Imm32_hbit_E, RD1_E, HIO, LOO, AO_E);
	
	input [2:0] AO_Sel;
	input [31:0] AO_tmp, Imm32_hbit_E, RD1_E, HIO, LOO;
	
	output reg [31:0] AO_E;
	
	always @(*) begin
		case (AO_Sel)
			3'b000: AO_E = AO_tmp;
			3'b001: AO_E = Imm32_hbit_E;
			3'b010: AO_E = RD1_E;
			3'b011: AO_E = HIO;
			3'b100: AO_E = LOO;
			default: AO_E = AO_tmp;
		endcase
	end

endmodule


module WrRegAddrMux(RegDst, rt, rd, A3);
	
	input [1:0] RegDst;
	input [4:0] rt, rd;
	
	output reg [4:0] A3;
	
	always @(*) begin
		case (RegDst)
			2'b00 : A3 = rt;
			2'b01 : A3 = rd;
			2'b10 : A3 = 5'b11111;
			default : A3 = rt;
		endcase
	end
	
endmodule


module WrRegDataMux(MemtoReg, AO, RD, pc8, WD);
	
	input [1:0] MemtoReg;
	input [31:0] AO, RD, pc8;
	
	output reg [31:0] WD;
	
	always @(*) begin
		case (MemtoReg)
			2'b00: WD = AO;
			2'b01: WD = RD;
			2'b10: WD = pc8;
			default: WD = 32'h0000_0000;
		endcase
	end
	
endmodule

module RegWrMux(RegWr_tmp, Zero, RegWr_sel, RegWr);
	
	input RegWr_tmp, Zero;
	input RegWr_sel;
	output RegWr;
	
	assign RegWr = RegWr_sel ? Zero : RegWr_tmp;
	
endmodule
	
	
	