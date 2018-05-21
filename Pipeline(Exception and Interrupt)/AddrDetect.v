`timescale 1ns / 1ps

module AddrDetect(Addr, load_Sel_tmp, save_Sel, is_load_M, is_save_M, is_loadb, is_saveb, ExcCode, we);
	
	input [31:0] Addr;
	input [2:0] load_Sel_tmp;
	input [1:0] save_Sel;
	input is_load_M;
	input is_save_M;
	input is_loadb;
	input is_saveb;
	
	output [4:0] ExcCode;
	output we;
	
	wire legal_range;
	assign legal_range = Addr[31:13] == 19'b0 | Addr[31:12] == 20'h00002 | Addr == 32'h0000_7f00 | Addr == 32'h0000_7f04 |
						 Addr == 32'h0000_7f10 | Addr == 32'h0000_7f14 | 
						 (is_loadb & (Addr[31:13] == 19'b0 | Addr[31:12] == 20'h00002)) |
						 (is_saveb & (Addr[31:13] == 19'b0 | Addr[31:12] == 20'h00002));
	
	wire legal_load;
	assign legal_load = legal_range & (
						(load_Sel_tmp == 3'b000 & Addr[1:0] == 2'b00) | 
						(load_Sel_tmp == 3'b001 | load_Sel_tmp == 3'b011) | 
						(load_Sel_tmp == 3'b010 & Addr[0] == 1'b0) | 
						(load_Sel_tmp == 3'b100 & Addr[0] == 1'b0));
	
	wire legal_save;
	assign legal_save = legal_range & (
						(save_Sel == 2'b00 & Addr[1:0] == 2'b00) | 
						(save_Sel == 2'b01) |
						(save_Sel == 2'b10 & Addr[0] == 1'b0));
	
	assign we = (!is_load_M & !is_save_M) | (is_load_M & legal_load) | (is_save_M & legal_save);
	
	assign ExcCode = we ? 5'b0 : 
					 is_save_M ? 5'h5 :
					 5'h4;
	
endmodule
