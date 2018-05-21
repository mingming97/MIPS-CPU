`timescale 1ns / 1ps

module GRF(clk, reset, A1, A2, A3, WD, RegWr, pc8, A4, 
		   is_delay_slot, IntReq, ExcReq, 
		   RD1, RD2, RD3);

	input clk, reset;
	input [4:0] A1, A2, A3, A4;
	input [31:0] WD;
	input RegWr;
	input is_delay_slot;
	input IntReq;
	input ExcReq;
	
	output [31:0] RD1, RD2, RD3;
	
	reg [31:0] register [31:0];
	integer i;
	
	input [31:0] pc8;
	wire [31:0] pc;
	assign pc = pc8 - 8;
	
	initial begin
		for (i = 0; i < 32; i = i + 1)
			register[i] = 0;
	end
	
	assign RD1 = (A1 == A3 && A3 != 5'b00000 && RegWr) ? WD : register[A1];
	assign RD2 = (A2 == A3 && A3 != 5'b00000 && RegWr) ? WD : register[A2];
	assign RD3 = (A4 == A3 && A3 != 5'b00000 && RegWr) ? WD : register[A4];
	
	always @(posedge clk) begin
		if (reset) begin
			for (i = 0; i < 32; i = i + 1)
				register[i] <= 0;
		end
		else begin
			if (RegWr) begin
				if (A3 != 5'b00000) begin
					register[A3] <= WD;
					$display("%d@%h: $%d <= %h", $time, pc, A3, WD);
				end
			end
		end
	end
	
	


endmodule
