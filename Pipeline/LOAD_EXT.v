`timescale 1ns / 1ps

module LOAD_EXT(RD_tmp, load_Sel, addr1_0, RD);
	
	input [31:0] RD_tmp;
	input [2:0] load_Sel;
	input [1:0] addr1_0;

	output reg [31:0] RD;

	wire [4:0] load;
	
	assign load = {load_Sel, addr1_0};

	always @(*) begin
		case (load)

			//lw
			5'b000_00: RD = RD_tmp;

			//lb
			5'b001_00: RD = {{24{RD_tmp[7]}},  RD_tmp[7:0]};
			5'b001_01: RD = {{24{RD_tmp[15]}},  RD_tmp[15:8]};
			5'b001_10: RD = {{24{RD_tmp[23]}},  RD_tmp[23:16]};
			5'b001_11: RD = {{24{RD_tmp[31]}},  RD_tmp[31:24]};

			//lbu
	 		5'b011_00: RD = {24'b0, RD_tmp[7:0]};
	 		5'b011_01: RD = {24'b0, RD_tmp[15:8]};
	 		5'b011_10: RD = {24'b0, RD_tmp[23:16]};
	 		5'b011_11: RD = {24'b0, RD_tmp[31:24]};

	 		//lh
	 		5'b010_00: RD = {{16{RD_tmp[15]}},  RD_tmp[15:0]};
	 		5'b010_10: RD = {{16{RD_tmp[31]}},  RD_tmp[31:16]};

	 		//lhu
	 		5'b100_00: RD = {16'b0,  RD_tmp[15:0]};
	 		5'b100_10: RD = {16'b0,  RD_tmp[31:16]};

	 		default: RD = 32'h0000_0000;
		endcase
	end
	
	


endmodule
