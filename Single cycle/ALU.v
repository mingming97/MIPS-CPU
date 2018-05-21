`timescale 1ns / 1ps

module ALU(A, B, ALUctr, 
		   ALUResult);
	
	input signed [31:0] A;
	input signed [31:0] B;
	input [2:0] ALUctr;
	
	output reg[31:0] ALUResult;
	
	always @(*) begin
		case (ALUctr)
			3'b000: ALUResult = A + B;
			3'b001: ALUResult = A - B;
			3'b010: ALUResult = A | B;
			3'b011: ALUResult = A & B;
			3'b100: ALUResult = (A < B) ? 32'h0000_0001 : 32'h0000_0000;
			3'b101: ALUResult = A >>> B[4:0];
			default: ALUResult = 32'h0000_0000;
		endcase
	end

endmodule
