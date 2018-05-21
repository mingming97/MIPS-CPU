`timescale 1ns / 1ps

module IM(Addr, instr, ExcCode);
	
	input [31:0] Addr;
	output [31:0] instr;
	
	output [4:0] ExcCode;
	
	reg [31:0] instr_memory[4095:0];
	
	integer i;
	
	initial begin
		for (i = 0; i < 4096; i = i + 1)
			instr_memory[i] = 0;
		$readmemh("code.txt", instr_memory);
		
		$readmemh("code_handler.txt", instr_memory, 1120, 2047);
	end
	
	wire legal;
	assign legal = (Addr[1:0] == 2'b0) & (Addr[31:12] == 20'h00003 | Addr[31:12] == 20'h00004);
	
	assign ExcCode = legal ? 5'b0 : 5'h4;
	
	wire [31:0] tmp = Addr - 32'h0000_3000;
	
	assign instr = legal ? instr_memory[tmp[13:2]] : 32'h0000_0000;
	
endmodule
