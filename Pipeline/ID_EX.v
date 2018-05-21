`timescale 1ns / 1ps

module ID_EX(
    clk, reset, En, clr,
	pc8_D, instr_D, RD1_D, RD2_D, RD3_D, Imm32_lbit_D, Imm32_hbit_D, Zero_D,
	pc8_E, instr_E, RD1_E, RD2_E, RD3_E, Imm32_lbit_E, Imm32_hbit_E, Zero_E);
	
	input clk, reset, En, clr;
	input [31:0] pc8_D, instr_D, RD1_D, RD2_D, RD3_D, Imm32_lbit_D, Imm32_hbit_D;
	input Zero_D;
	output reg [31:0] pc8_E, instr_E, RD1_E, RD2_E, RD3_E, Imm32_lbit_E, Imm32_hbit_E;
	output reg Zero_E;
	
	initial begin
		pc8_E = 0;
		instr_E = 0;
		RD1_E = 0;
		RD2_E = 0;
		RD3_E = 0;
		Imm32_lbit_E = 0;
		Imm32_hbit_E = 0;
		Zero_E = 0;
	end
	
	always @(posedge clk) begin
		if (reset | clr) begin
			pc8_E <= 0;
			instr_E <= 0;
			RD1_E <= 0;
			RD2_E <= 0;
			RD3_E <= 0;
			Imm32_lbit_E <= 0;
			Imm32_hbit_E <= 0;
			Zero_E <= 0;
		end
		else begin
			if (En) begin
				pc8_E <= pc8_D;
				instr_E <= instr_D;
				RD1_E <= RD1_D;
				RD2_E <= RD2_D;
				RD3_E <= RD3_D;
				Imm32_lbit_E <= Imm32_lbit_D;
				Imm32_hbit_E <= Imm32_hbit_D;
				Zero_E <= Zero_D;
			end
		end
	end


endmodule
