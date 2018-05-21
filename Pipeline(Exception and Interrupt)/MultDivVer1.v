`timescale 1ns / 1ps

module MultDivVer1(
	clk, reset, Start, IntReq, ExcReq, Enmultdiv, 
	RD1, RD2, MD_ctr, lock_muldiv, 
	Busy, HIO, LOO);
	
	input clk, reset;
    input signed [31:0] RD1, RD2;
    input [2:0] MD_ctr;
    input Start;
	input lock_muldiv;
	input Enmultdiv;
	input IntReq;
	input ExcReq;

    output [31:0] HIO;
    output [31:0] LOO;
    output reg Busy;

    reg [31:0] HI, LO;
	reg [31:0] HI_tmp, LO_tmp;
	reg [31:0] HI_back, LO_back;
    reg [3:0] cycle_num;
	reg signed [31:0] A, B;
	reg [2:0] Op;
	reg five_or_ten;
	reg cnt;
	
	// 000:'mult' 001:'multu' 010:'div' 011:'divu' 100:'mthi' 101:'mtlo'
	
	parameter
	MULT = 3'b000,
	MULTU = 3'b001,
	DIV = 3'b010,
	DIVU = 3'b011,
	MTHI = 3'b100,
	MTLO = 3'b101;
	

    initial begin
    	HI = 32'h0000_0000;
    	LO = 32'h0000_0000;
    	cycle_num = 4'b0000;
		HI_tmp = 32'h0000_0000;
		LO_tmp = 32'h0000_0000;
		Busy = 1'b0;
		A = 32'h0000_0000;
		B = 32'h0000_0000;
		five_or_ten = 1'b0;
		Op = 3'b000;
		cnt = 0;
    end

    assign HIO = HI;  //mfhi
    assign LOO = LO;  //mflo
	
	always @(*) begin
		/*if (Start) begin
			A = RD1;
			B = RD2;
			Op = MD_ctr;
			Busy = 1;
			if (MD_ctr == MULT | MD_ctr == MULTU) 
				five_or_ten = 1'b0;
			else if(MD_ctr == DIV | MD_ctr == DIVU)
				five_or_ten = 1'b1;			
		end*/
		case (Op)

    		MULT: {HI_tmp, LO_tmp} = A * B;	//MULT

    		MULTU: {HI_tmp, LO_tmp} = {1'b0, A} * {1'b0, B}; //MULTU

    		DIV: begin		//DIV
    			if (B != 32'h0000_0000) begin
    				HI_tmp = A % B;
    				LO_tmp = A / B;
				end
				else begin
					HI_tmp = HI;
					LO_tmp = LO;
				end
			end

    		DIVU: begin		//DIVU
    			if (B != 32'h0000_0000) begin
					HI_tmp = {1'b0, A} % {1'b0, B};
    				LO_tmp = {1'b0, A} / {1'b0, B};
    			end
				else begin
					HI_tmp = HI;
					LO_tmp = LO;
				end
    		end
			
		endcase
	end
	
	
    always @(posedge clk) begin		
    	if (reset) begin
    		HI <= 32'h0000_0000;
    		LO <= 32'h0000_0000;
    		cycle_num <= 4'b0000;
			HI_tmp <= 32'h0000_0000;
			LO_tmp <= 32'h0000_0000;
			Busy <= 1'b0;
			A <= 32'h0000_0000;
			B <= 32'h0000_0000;
			five_or_ten <= 1'b0;
			Op <= 3'b000;
			HI_back <= 0;
			LO_back <= 0;
			cnt <= 0;
    	end
    	else begin
		
			HI_back <= HI;
			LO_back <= LO;
		
			if (Enmultdiv) cnt <= 1;
			else cnt <= 0;
			
			if (cnt == 1 & (IntReq | ExcReq)) begin
				Busy <= 0;
				HI <= HI_back;
				LO <= LO_back;
				cycle_num <= 0;
			end
			
			if (Start & !lock_muldiv) begin
				A <= RD1;
				B <= RD2;
				Op <= MD_ctr;
				Busy <= 1;
				if (MD_ctr == MULT | MD_ctr == MULTU) 
					five_or_ten <= 1'b0;
				else if(MD_ctr == DIV | MD_ctr == DIVU)
					five_or_ten <= 1'b1;			
			end	
			
    		if (Busy & !lock_muldiv) begin
				cycle_num <= cycle_num + 1;
				if ((five_or_ten == 1'b0 & cycle_num == 3) | (five_or_ten == 1'b1 & cycle_num == 8)) begin
					cycle_num <= 0;
					Busy <= 0;
					HI <= HI_tmp;
					LO <= LO_tmp;
				end
			end
			case(MD_ctr) 
				MTHI: if (!lock_muldiv) HI <= RD1;
				MTLO: if (!lock_muldiv) LO <= RD1;
			endcase
    	end
    end
    
endmodule
