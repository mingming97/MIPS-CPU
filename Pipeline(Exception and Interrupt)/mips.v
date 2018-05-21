`timescale 1ns / 1ps

module mips(clk, reset);
	
	input clk, reset;
	
	wire [31:2] PrAddr;
	wire [3:0] PrBE;
	wire [31:0] PrWD;
	wire PrWe;
	wire [31:0] PrRD;
	wire [1:0] timer_addr;
	wire [31:0] timer_WD;
	wire timer0_WE;
	wire timer1_WE;
	wire [3:0] timer_BE;
	wire [31:0] timer0_RD;
	wire [31:0] timer1_RD;
	wire timer0_IRQ, timer1_IRQ;
	
	cpu cpu(
		.clk(clk),
		.reset(reset),
		.PrRD(PrRD),
		.HWInt({4'b0, timer1_IRQ, timer0_IRQ}),
		
		.PrAddr(PrAddr),
		.PrBE(PrBE),
		.PrWD(PrWD),
		.PrWe(PrWe));
	
	Bridge bridge(
		.PrAddr(PrAddr),
		.PrWD(PrWD),
		.PrBE(PrBE),
		.PrWe(PrWe),
		.timer0_RD(timer0_RD),
		.timer1_RD(timer1_RD),
		
		.PrRD(PrRD),
		.timer_addr(timer_addr),
		.timer_WD(timer_WD),
		.timer0_WE(timer0_WE),
		.timer1_WE(timer1_WE),
		.timer_BE(timer_BE));
	
	COCOtimer timer0(
		.clk(clk),
		.reset(reset),
		.addr(timer_addr),
		.we(timer0_WE),
		.WD(timer_WD),
		
		.RD(timer0_RD),
		.IRQ(timer0_IRQ));
	
	COCOtimer timer1(
		.clk(clk),
		.reset(reset),
		.addr(timer_addr),
		.we(timer1_WE),
		.WD(timer_WD),
		
		.RD(timer1_RD),
		.IRQ(timer1_IRQ));
	
endmodule
