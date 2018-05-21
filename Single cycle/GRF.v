`timescale 1ns / 1ps

module GRF(clk, reset, RegWr, A1, A2, A3, WD, now_pc, 
		   RD1, RD2);
	
	input clk, reset;
	input RegWr;
	input [4:0] A1, A2, A3;
	input [31:0] WD;
	input [31:0] now_pc;
	
	output [31:0] RD1, RD2;
	
	reg [31:0] register [31:0];
	
	integer i;
	
	initial begin
		for (i = 0; i < 32; i = i + 1)
			register[i] = 0;
	end
	
	assign RD1 = register[A1];
	assign RD2 = register[A2];
	
	always @(posedge clk) begin
		if (reset) begin
			for (i = 0; i < 32; i = i + 1)
				register[i] = 0;
		end
		else begin
			if (RegWr) begin
				if (A3 != 5'b00000) begin
					register[A3] <= WD;
					$display("@%h: $%d <= %h", now_pc, A3, WD);
				end
			end
		end
	end

endmodule
