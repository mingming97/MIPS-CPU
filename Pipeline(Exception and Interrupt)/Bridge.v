`timescale 1ns / 1ps

module Bridge(
	PrAddr, PrRD, PrWD, PrWe, PrBE,
	timer_addr, timer_WD, timer0_RD, timer1_RD,
	timer0_WE, timer1_WE, timer_BE);
	
	input [31:2] PrAddr;
	input [31:0] PrWD;
	input [3:0] PrBE;
	input PrWe;
	input [31:0] timer0_RD;
	input [31:0] timer1_RD;
	
	output [31:0] PrRD;
	output [1:0] timer_addr;
	output [31:0] timer_WD;
	output timer0_WE;
	output timer1_WE;
	output [3:0] timer_BE;
	
	assign timer_addr = PrAddr[3:2];
	
	assign timer_WD = PrWD;
	
	wire hit_timer0;
	assign hit_timer0 = (PrAddr[31:4] == 28'h0000_7f0);
	
	wire hit_timer1;
	assign hit_timer1 = (PrAddr[31:4] == 28'h0000_7f1);
	
	assign PrRD = (hit_timer0) ? timer0_RD : timer1_RD;
				  
	assign timer0_WE = hit_timer0 & PrWe;
	assign timer1_WE = hit_timer1 & PrWe;
	
	assign timer_BE = PrBE;
	
endmodule
