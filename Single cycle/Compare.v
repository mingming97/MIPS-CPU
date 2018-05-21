`timescale 1ns / 1ps

module Compare(RD1, RD2, Comp, Zero);
	
	input signed [31:0] RD1, RD2;
	input Comp;
	output Zero;
	
	assign Zero = Comp ? (RD1 == RD2) : (RD1 != RD2);


endmodule
