`timescale 1ns / 1ps

module EXT(Imm16, Imm26, ExtOp, Imm28, Imm32_lbit, Imm32_hbit);
	
	input [15:0] Imm16;
	input [25:0] Imm26;
	input [1:0] ExtOp;
	
	output [27:0] Imm28;
	output reg [31:0] Imm32_lbit;
	output [31:0] Imm32_hbit;
	
	assign Imm28 = {Imm26, 2'b00};
	assign Imm32_hbit = {Imm16, 16'h0000};
	
	always @(*) begin
		case (ExtOp)
			2'b00: Imm32_lbit = {16'h0000, Imm16}; //00: 'Zero'
			2'b01: Imm32_lbit = {{16{Imm16[15]}}, Imm16}; //01: 'Sign
			2'b10: Imm32_lbit = {{27{1'b0}}, Imm16[10:6]}; //10: 'sll/shamt
			default: Imm32_lbit = {16'h0000, Imm16};
		endcase
	end


endmodule
