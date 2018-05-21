`timescale 1ns / 1ps

module IM(Addr, instr);
	
	input [31:0] Addr;
	output [31:0] instr;
	
	reg [31:0] instr_memory[4095:0];
	
	integer i;
	
	initial begin
		for (i = 0; i < 4096; i = i + 1)
			instr_memory[i] = 0;
		$readmemh("code.txt", instr_memory);
	end
	
	wire [31:0] tmp = Addr - 32'h0000_3000;
	
	assign instr = instr_memory[tmp[13:2]];
	
endmodule
