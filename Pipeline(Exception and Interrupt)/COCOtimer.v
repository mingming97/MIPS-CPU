`timescale 1ns / 1ps

module COCOtimer(
	clk, reset, addr, we, WD, 
	RD, IRQ);
	
	input clk, reset, we;
	input [3:2] addr;
	input [31:0] WD;
	
	output [31:0] RD;
	output IRQ;
	
	wire IM;
	wire [1:0] Mode;
	wire Enable;
	
	reg [31:0] CTRL;
	reg [31:0] PRESET;
	reg [31:0] COUNT;
	
	parameter
	IDLE = 3'h0,
	INI = 3'h1,
	CNT = 3'h2,
	TOZ = 3'h3,
	MOD0 = 3'h4;
		
	initial begin
		CTRL = 32'h0000_0000;
		PRESET = 32'h0000_0000;
		COUNT = 32'h0000_0000;
		state = 3'b0;
	end
	
	assign IM = CTRL[3];
	assign Mode = CTRL[2:1];
	assign Enable = CTRL[0];
	
	assign RD = addr == 2'b00 ? CTRL : 
	            addr == 2'b01 ? PRESET : 
				addr == 2'b10 ? COUNT : 
				32'b0;
	
	assign IRQ = IM & (COUNT == 0) & (Mode == 0) & (state != IDLE);
	
	reg [2:0] state;
	reg [2:0] nextstate;
	
	always @(posedge clk) begin
		if (reset) begin
			CTRL <= 32'h0000_0000;
			PRESET <= 32'h0000_0000;
			COUNT <= 32'h0000_0000;
		end
		else begin
			if (we) begin
				case (addr)
					2'b00: CTRL <= WD;
					2'b01: PRESET <= WD;
				endcase
			end
			state = nextstate;
			case (state)
				INI: begin
					COUNT = PRESET;
				end
				CNT: begin
					if (Enable)
						COUNT = COUNT - 1;
				end
				TOZ: begin
					if (Enable)
						COUNT = COUNT - 1;
				end
				MOD0: begin
					if (!we) 
						CTRL[0] = 0;
				end
			endcase
		end
	end
	
	always @(state or Mode or Enable or COUNT) begin
		case (state)
			IDLE: nextstate = (Enable) ? INI : IDLE;
			INI: nextstate = CNT;
			CNT: nextstate = (COUNT == 1) ? TOZ : CNT;
			TOZ: nextstate = (Mode == 2'b01) ? INI : MOD0;
			MOD0: nextstate = (Enable) ? INI : MOD0;
		endcase
	end
	
	
	
	
	
	


endmodule
