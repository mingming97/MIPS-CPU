`timescale 1ns / 1ps

module ALU(A, B, ALUctr, EnOverflow, is_save_E, is_load_E, AO, ExcCode);
	
	input signed [31:0] A;
	input signed [31:0] B;
	input [3:0] ALUctr;
	input EnOverflow;
	input is_save_E;
	input is_load_E;
	
	output [4:0] ExcCode;
	
	output reg [31:0] AO;
	
	reg [32:0] temp;
	reg overflow;
	
	assign ExcCode = (EnOverflow & overflow & is_load_E) ? 5'h4 : 
					 (EnOverflow & overflow & is_save_E) ? 5'h5 :
					 (EnOverflow & overflow) ? 5'hc : 5'b0;
	
	always @(*) begin
		case (ALUctr)
			4'b0000: begin
				AO = A + B;
				temp = {A[31], A} + {B[31], B};
				overflow = EnOverflow & (temp[32] != temp[31]);
			end
			4'b0001: begin
				AO = A - B;
				temp = {A[31], A} - {B[31], B};
				overflow = EnOverflow & (temp[32] != temp[31]);
			end		
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
