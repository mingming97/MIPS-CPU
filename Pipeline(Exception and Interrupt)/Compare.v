`timescale 1ns / 1ps

module Compare(RD1, RD2, Imm32_lbit, Comp, Zero);
	
	input signed [31:0] RD1;
	input signed [31:0] RD2;
	input signed [31:0] Imm32_lbit;
	
	input [2:0] Comp;
	
	output reg Zero;
	
	initial begin
		Zero = 0;
	end
	
	always @(*) begin
		case (Comp)
			3'b000: Zero = (RD1 == RD2) ? 1 : 0;//beq
			3'b001: Zero = (RD1 != RD2) ? 1 : 0;//bne
			3'b010: Zero = (RD1 <= $signed(32'h0000_0000)) ? 1 : 0;//blez
			3'b011: Zero = (RD1 > $signed(32'h0000_0000)) ? 1 : 0;//bgtz
			3'b100: Zero = (RD1 < $signed(32'h0000_0000)) ? 1 : 0;//bltz
			3'b101: Zero = (RD1 >= $signed(32'h0000_0000)) ? 1 : 0;//bgez
			3'b110: Zero = (RD2 == 0) ? 1 : 0; //movz
			default: Zero = 0;
		endcase
	end


endmodule
