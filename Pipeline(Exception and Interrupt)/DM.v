`timescale 1ns / 1ps

module DM(clk, reset, Addr, WD, MemWr, BE, PrRD, pc8_M, 
		  RD, we, IntReq);

	input clk, reset;
	input [31:2] Addr;
	input [31:0] WD;
	input MemWr;
	input [3:0] BE;
	input [31:0] PrRD;
	input we;
	input IntReq;
	
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
	

	assign RD = (Addr[31:13] == 19'b0 | Addr[31:12] == 20'h00002) ? Memory[Addr[13:2]] : PrRD;
	
	wire WE;
	assign WE = MemWr & (Addr[31:13] == 19'b0 | Addr[31:12] == 20'h00002) & (!IntReq);
	
	
	always @(posedge clk) begin
		if (reset) begin
			for (i = 0; i < 1024; i = i + 1)
				Memory[i] <= 32'h0000_0000;
		end
		else begin
			if (WE & we) begin
				case(BE)
					4'b1111: Memory[Addr[13:2]] = WD;
					4'b0011: Memory[Addr[13:2]][15:0] = WD[15:0];
					4'b1100: Memory[Addr[13:2]][31:16] = WD[15:0];
					4'b0001: Memory[Addr[13:2]][7:0] = WD[7:0];
					4'b0010: Memory[Addr[13:2]][15:8] = WD[7:0];
					4'b0100: Memory[Addr[13:2]][23:16] = WD[7:0];
					4'b1000: Memory[Addr[13:2]][31:24] = WD[7:0];
					default: Memory[Addr[13:2]] = WD;
				endcase
				$display("%d@%h: *%h <= %h", $time, pc, {Addr, 2'b0}, Memory[Addr]);
			end
		end
	end


endmodule
