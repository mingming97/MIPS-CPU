`timescale 1ns / 1ps

module MultDiv(
	clk, reset, Start, 
	RD1, RD2, MD_ctr,
	Busy, HIO, LOO);
	
	input clk, reset;
    input signed [31:0] RD1, RD2;
    input [2:0] MD_ctr;
    input Start;

    output [31:0] HIO;
    output [31:0] LOO;
    output reg Busy;

    reg [31:0] HI, LO;
	reg [31:0] HI_tmp, LO_tmp;
    reg [3:0] cycle_num;
	reg signed [31:0] A, B;
	reg signed [63:0] C;
	reg [2:0] Op;
	reg five_or_ten;
	
	// 000:'mult' 001:'multu' 010:'div' 011:'divu' 100:'mthi' 101:'mtlo'
	
	parameter
	MULT = 3'b000,
	MULTU = 3'b001,
	DIV = 3'b010,
	DIVU = 3'b011,
	MTHI = 3'b100,
	MTLO = 3'b101,
	MADD = 3'b110;
	

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
			end

    		DIVU: begin		//DIVU
    			if (B != 32'h0000_0000) begin
					HI_tmp = {1'b0, A} % {1'b0, B};
    				LO_tmp = {1'b0, A} / {1'b0, B};
    			end
    		end
			
			MADD: begin
				C = A * B;
				{HI_tmp, LO_tmp} = C + {HI, LO};
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
    	end
    	else begin
			if (Start) begin
				A <= RD1;
				B <= RD2;
				Op <= MD_ctr;
				Busy <= 1;
				if (MD_ctr == MULT | MD_ctr == MULTU) 
					five_or_ten <= 1'b0;
				else if(MD_ctr == DIV | MD_ctr == DIVU)
					five_or_ten <= 1'b1;			
			end	
			
    		if (Busy) begin
				cycle_num <= cycle_num + 1;
				if ((five_or_ten == 1'b0 & cycle_num == 3) | (five_or_ten == 1'b1 & cycle_num == 8)) begin
					cycle_num <= 0;
					Busy <= 0;
					HI <= HI_tmp;
					LO <= LO_tmp;
				end
			end
			case(MD_ctr) 
				MTHI: HI <= RD1;
				MTLO: LO <= RD1;
			endcase
    	end
    end
    
endmodule