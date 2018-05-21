`timescale 1ns / 1ps

`define ip 15:10
`define exc_code 6:2
`define im 15:10
`define exl 1
`define ie 0
`define bd 31

module CP0(
	clk, reset, 
    A1, A2, DIn, PC, ExcCode, HWInt, We, EXLSet, EXLClr, is_delay_slot, 
	IntReq, ExcReq, EPC, DOut);
	
	input clk, reset;
	input [4:0] A1, A2;
	input [31:0] DIn;
	input [31:0] PC;
	input [6:2] ExcCode;
	input [5:0] HWInt;
	input We;
	input EXLSet;
	input EXLClr;
	input is_delay_slot;
	
	output IntReq;
	output ExcReq;
	output [31:0] EPC;
	output [31:0] DOut;
	
	reg [31:0] epc;
	reg [31:0] SR;
	reg [31:0] CAUSE;
	reg [31:0] PrID;
	
	initial begin
		epc = 0;
		SR = 0;
		CAUSE = 0;
		PrID = 32'h16061131;
	end
	
	assign EPC = epc;
	assign DOut = (A1 == 12) ? SR : 
				  (A1 == 13) ? CAUSE :
				  (A1 == 14) ? epc :
				  (A1 == 15) ? PrID :
				  32'b0;
	
	wire [5:0] IM;
	assign IM = SR[`im];
	wire IE;
	assign IE = SR[`ie];
	wire EXL;
	assign EXL = SR[`exl];
	
	assign IntReq = |(HWInt & IM) & IE & !EXL;
	assign ExcReq = (ExcCode != 5'b00000) & !EXL;
	
	always @(posedge clk) begin
		if (reset) begin
			epc <= 0;
			SR <= 0;
			CAUSE <= 0;
			PrID <= 32'h16061131;
		end
		else begin
			
			CAUSE[`ip] <= HWInt;
			
			if (We & !IntReq) begin
				case (A2)
					12: {SR[`im], SR[`exl], SR[`ie]} <= {DIn[15:10], DIn[1], DIn[0]};
					14: epc <= DIn;
				endcase
			end
			
			if (EXLSet)
				SR[`exl] <= 1'b1;
			else if (EXLClr)
				SR[`exl] <= 1'b0;
			
			if (IntReq) begin
				epc <= is_delay_slot ? PC-4 : PC;
				CAUSE[`exc_code] <= 5'b0;
				CAUSE[`bd] <= is_delay_slot;
				SR[`exl] <= 1'b1;				
			end
			else if (ExcReq) begin
				epc <= is_delay_slot ? PC-4 : PC;
				CAUSE[`exc_code] <= ExcCode;
				CAUSE[`bd] <= is_delay_slot;
				SR[`exl] <= 1'b1;
			end
			
		end
	end
	
endmodule
