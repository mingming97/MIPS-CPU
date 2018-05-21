`timescale 1ns / 1ps

module IM(Addr, instr);
	
	input [31:0] Addr;
	output [31:0] instr;
	
	reg [31:0] instr_memory[1023:0];
	
	integer i;
	
	initial begin
		for (i = 0; i < 1024; i = i + 1)
			instr_memory[i] = 0;
		
		$readmemh("code.txt", instr_memory);
	end
	
	assign instr = instr_memory[Addr[11:2]];

endmodule
