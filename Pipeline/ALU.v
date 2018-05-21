`timescale 1ns / 1ps

module ALU(A, B, ALUctr, AO);
	
	input signed [31:0] A;
	input signed [31:0] B;
	input [3:0] ALUctr;
	
	output reg [31:0] AO;
	
	always @(*) begin
		case (ALUctr)
			4'b0000: AO = A + B;
			4'b0001: AO = A - B;
			4'b0010: AO = A | B;
			4'b0011: AO = A & B;
			4'b0100: AO = A ^ B;
			4'b0101: AO = ~(A | B);
			4'b0110: AO = A << B[4:0]; //sll
			4'b0111: AO = B << A[4:0]; //sllv
			4'b1000: AO = A >>> B[4:0]; //sra
			4'b1001: AO = B >>> A[4:0]; //srav
			4'b1010: AO = A >> B[4:0]; //srl
			4'b1011: AO = B >> A[4:0]; //srlv
			4'b1100: AO = (A < B) ? 32'h0000_0001 : 32'h0000_0000; //slt/slti
			4'b1101: AO = ({1'b0, A} < {1'b0, B}) ? 32'h0000_0001 : 32'h0000_0000; //sltu/sltiu
			default: AO = 32'h0000_0000;
		endcase
	end


endmodule
