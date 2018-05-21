`timescale 1ns / 1ps

module DM(clk, reset, Addr, WD, MemWr, BE, pc8_M,
		  RD);

	input clk, reset;
	input [11:0] Addr;
	input [31:0] WD;
	input MemWr;
	input [3:0] BE;
	
	output [31:0] RD;
	
	reg [31:0] Memory [4095:0];
	
	integer i;
	initial begin
		for (i = 0; i < 4096; i = i + 1)
			Memory[i] = 32'h0000_0000;
	end
	
	input [31:0] pc8_M;
	wire [31:0] pc;
	assign pc = pc8_M - 8;

	assign RD = Memory[Addr];
	
	always @(posedge clk) begin
		if (reset) begin
			for (i = 0; i < 1024; i = i + 1)
				Memory[i] <= 32'h0000_0000;
		end
		else begin
			if (MemWr) begin
				case(BE)
					4'b1111: Memory[Addr] = WD;
					4'b0011: Memory[Addr][15:0] = WD[15:0];
					4'b1100: Memory[Addr][31:16] = WD[15:0];
					4'b0001: Memory[Addr][7:0] = WD[7:0];
					4'b0010: Memory[Addr][15:8] = WD[7:0];
					4'b0100: Memory[Addr][23:16] = WD[7:0];
					4'b1000: Memory[Addr][31:24] = WD[7:0];
					default: Memory[Addr] = WD;
				endcase
				$display("%d@%h: *%h <= %h", $time, pc, {17'b0 ,Addr, 2'b0}, Memory[Addr]);
			end
		end
	end


endmodule
