`timescale 1ns / 1ps

module ClrControl(ID_EX_clr_tmp, Zero, clr_sel, 
				  IF_ID_clr, ID_EX_clr);
	
	input ID_EX_clr_tmp;
	input [1:0] clr_sel;
	input Zero;
	
	output reg IF_ID_clr;
	output ID_EX_clr;
	
	reg temp;
	
	always @(*) begin
		case (clr_sel)
			2'b01: begin  // movz/bgezal(if not clear ID_EX)
				IF_ID_clr = 0;
				temp = !Zero;
			end
			default: begin
				IF_ID_clr = 0;
				temp = 0;
			end
		endcase
	end
	
	
	assign ID_EX_clr = temp | ID_EX_clr_tmp;
	
endmodule
