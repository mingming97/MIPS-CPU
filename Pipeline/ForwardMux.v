`timescale 1ns / 1ps

module MFRSD(
	ForwardRSD,
	RD1_tmp, pc8_E, pc8_M, AO_M,
	RD1_D);
	
	input [2:0] ForwardRSD;
	input [31:0] RD1_tmp, pc8_E, pc8_M, AO_M;
	
	output reg [31:0] RD1_D;

	always @(*) begin
		case(ForwardRSD)
			3'h0: RD1_D = RD1_tmp;
			3'h1: RD1_D = pc8_E;
			3'h2: RD1_D = pc8_M;
			3'h3: RD1_D = AO_M;
			default: RD1_D = RD1_tmp;
		endcase
	end

endmodule


module MFRTD(
	ForwardRTD,
	RD2_tmp, pc8_E, pc8_M, AO_M,
	RD2_D);
	
	input [2:0] ForwardRTD;
	input [31:0] RD2_tmp, pc8_E, pc8_M, AO_M;
	
	output reg [31:0] RD2_D;

	always @(*) begin
		case(ForwardRTD)
			3'h0: RD2_D = RD2_tmp;
			3'h1: RD2_D = pc8_E;
			3'h2: RD2_D = pc8_M;
			3'h3: RD2_D = AO_M;
			default: RD2_D = RD2_tmp;
		endcase
	end

endmodule

module MFRDD(
	ForwardRDD,
	RD3_tmp, pc8_E, pc8_M, AO_M,
	RD3_D);
	
	input [2:0] ForwardRDD;
	input [31:0] RD3_tmp, pc8_E, pc8_M, AO_M;
	
	output reg [31:0] RD3_D;

	always @(*) begin
		case(ForwardRDD)
			3'h0: RD3_D = RD3_tmp;
			3'h1: RD3_D = pc8_E;
			3'h2: RD3_D = pc8_M;
			3'h3: RD3_D = AO_M;
			default: RD3_D = RD3_tmp;
		endcase
	end

endmodule


module MFRSE(
	ForwardRSE,
	RD1_E_tmp, pc8_M, AO_M, WD, 
	RD1_E);
	
	input [2:0] ForwardRSE;
	input [31:0] RD1_E_tmp, pc8_M, AO_M, WD;

	output reg [31:0] RD1_E;

	always @(*) begin
		case(ForwardRSE)
			3'h0: RD1_E = RD1_E_tmp;
			3'h1: RD1_E = pc8_M;
			3'h2: RD1_E = AO_M;
			3'h3: RD1_E = WD;
			default: RD1_E = RD1_E_tmp;
		endcase
	end
endmodule


module MFRTE(
	ForwardRTE,
	RD2_E_tmp, pc8_M, AO_M, WD,
	RD2_E);
	
	input [2:0] ForwardRTE;
	input [31:0] RD2_E_tmp, pc8_M, AO_M, WD;

	output reg [31:0] RD2_E;

	always @(*) begin
		case(ForwardRTE)
			3'h0: RD2_E = RD2_E_tmp;
			3'h1: RD2_E = pc8_M;
			3'h2: RD2_E = AO_M;
			3'h3: RD2_E = WD;
			default: RD2_E = RD2_E_tmp;
		endcase
	end
endmodule

module MFRDE(
	ForwardRDE,
	RD3_E_tmp, pc8_M, AO_M, WD,
	RD3_E);
	
	input [2:0] ForwardRDE;
	input [31:0] RD3_E_tmp, pc8_M, AO_M, WD;

	output reg [31:0] RD3_E;

	always @(*) begin
		case(ForwardRDE)
			3'h0: RD3_E = RD3_E_tmp;
			3'h1: RD3_E = pc8_M;
			3'h2: RD3_E = AO_M;
			3'h3: RD3_E = WD;
			default: RD3_E = RD3_E_tmp;
		endcase
	end
endmodule


module MFRSM(
	ForwardRSM,
	RD1_M_tmp, WD,
	RD1_M);
	
	input [2:0] ForwardRSM;
	input [31:0] RD1_M_tmp, WD;

	output reg [31:0] RD1_M;

	always @(*) begin
		case(ForwardRSM)
			3'h0: RD1_M = RD1_M_tmp;
			3'h1: RD1_M = WD;
			default: RD1_M = RD1_M_tmp;
		endcase
	end
endmodule


module MFRTM(
	ForwardRTM,
	RD2_M_tmp, WD,
	RD2_M);
	
	input [2:0] ForwardRTM;
	input [31:0] RD2_M_tmp, WD;

	output reg [31:0] RD2_M;

	always @(*) begin
		case(ForwardRTM)
			3'h0: RD2_M = RD2_M_tmp;
			3'h1: RD2_M = WD;
			default: RD2_M = RD2_M_tmp;
		endcase
	end
endmodule

module MFRDM(
	ForwardRDM,
	RD3_M_tmp, WD,
	RD3_M);
	
	input [2:0] ForwardRDM;
	input [31:0] RD3_M_tmp, WD;

	output reg [31:0] RD3_M;

	always @(*) begin
		case(ForwardRDM)
			3'h0: RD3_M = RD3_M_tmp;
			3'h1: RD3_M = WD;
			default: RD3_M = RD3_M_tmp;
		endcase
	end
endmodule
