`timescale 1ns / 1ps

module BE_EXT(save_Sel, addr1_0, BE);
	
	input [1:0] save_Sel;
	input [1:0] addr1_0;
	
	output reg [3:0] BE;
	
	wire [3:0] save;
	
	assign save = {save_Sel, addr1_0};
	
	always @(*) begin
		case (save)
			
			//sw
			4'b00_00: BE = 4'b1111;
			4'b00_01: BE = 4'b1111;
			4'b00_10: BE = 4'b1111;
			4'b00_11: BE = 4'b1111;
			
			//sh
			4'b10_00: BE = 4'b0011;
			4'b10_01: BE = 4'b0011;
			4'b10_10: BE = 4'b1100;
			4'b10_11: BE = 4'b1100;


			//sb
			4'b01_00: BE = 4'b0001;
			4'b01_01: BE = 4'b0010;
			4'b01_10: BE = 4'b0100;
			4'b01_11: BE = 4'b1000;
			
			default: BE = 4'b0000;
		endcase
	end


endmodule
