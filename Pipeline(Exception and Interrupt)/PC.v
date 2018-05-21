`timescale 1ns / 1ps

module PC(clk, reset, next_pc, now_pc, En, IntReq, ExcReq);
	
	input [31:0] next_pc;
	input clk, reset, En, IntReq, ExcReq;
	
	output reg [31:0] now_pc;
	
	initial begin
		now_pc = 32'h0000_3000;
	end
	
	always @(posedge clk) begin
		if (reset)
			now_pc <= 32'h0000_3000;
		else if (En | IntReq | ExcReq)
			now_pc <= next_pc;
	end

endmodule
