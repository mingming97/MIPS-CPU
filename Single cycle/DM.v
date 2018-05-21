`timescale 1ns / 1ps

module DM(clk, reset, Addr, WD, MemWr, now_pc, save_Sel, load_Sel,
		  RD);

	input clk, reset;
	input [31:0] Addr;
	input [31:0] WD;
	input MemWr;
	input [31:0] now_pc;
	
	input [1:0] save_Sel;
	input [2:0] load_Sel;
	wire [4:0] load;
	wire [3:0] save;
	assign load = {load_Sel, Addr[1:0]};
	assign save = {save_Sel, Addr[1:0]};
	
	output reg [31:0] RD;
	
	reg [31:0] Memory [1023:0];
	
	integer i;
	
	initial begin
		for (i = 0; i < 1024; i = i + 1)
			Memory[i] = 32'h0000_0000;
	end
	
	//assign RD = Memory[Addr[11:2]];
	always @(*) begin
		case (load)

			//lw
			5'b000_00: RD = Memory[Addr[11:2]];

			//lb
			5'b001_00: RD = {{24{Memory[Addr[11:2]][7]}},  Memory[Addr[11:2]][7:0]};
			5'b001_01: RD = {{24{Memory[Addr[11:2]][15]}},  Memory[Addr[11:2]][15:8]};
			5'b001_10: RD = {{24{Memory[Addr[11:2]][23]}},  Memory[Addr[11:2]][23:16]};
			5'b001_11: RD = {{24{Memory[Addr[11:2]][31]}},  Memory[Addr[11:2]][31:24]};

			//lbu
			5'b011_00: RD = {24'b0, Memory[Addr[11:2]][7:0]};
			5'b011_01: RD = {24'b0, Memory[Addr[11:2]][15:8]};
			5'b011_10: RD = {24'b0, Memory[Addr[11:2]][23:16]};
			5'b011_11: RD = {24'b0, Memory[Addr[11:2]][31:24]};

			//lh
			5'b010_00: RD = {{16{Memory[Addr[11:2]][15]}},  Memory[Addr[11:2]][15:0]};
			5'b010_10: RD = {{16{Memory[Addr[11:2]][31]}},  Memory[Addr[11:2]][31:16]};

			//lhu
			5'b100_00: RD = {16'b0,  Memory[Addr[11:2]][15:0]};
			5'b100_10: RD = {16'b0,  Memory[Addr[11:2]][31:16]};

			default: RD = 32'h0000_0000;
		endcase
	end
	
	always @(posedge clk) begin
		if (reset) begin
			for (i = 0; i < 1024; i = i + 1) 
				Memory[i] <= 32'h0000_0000;
		end
		else begin
			if (MemWr) begin
				//Memory[Addr[11:2]] <= WD;
				case (save)
				
					//sw
					4'b00_00: Memory[Addr[11:2]] <= WD;

					//sb
					4'b01_00: Memory[Addr[11:2]][7:0] <= WD[7:0];
					4'b01_01: Memory[Addr[11:2]][15:8] <= WD[7:0];
					4'b01_10: Memory[Addr[11:2]][23:16] <= WD[7:0];
					4'b01_11: Memory[Addr[11:2]][31:24] <= WD[7:0];

					//sh
					4'b10_00: Memory[Addr[11:2]][15:0] <= WD[15:0];
					4'b10_10: Memory[Addr[11:2]][31:16] <= WD[15:0];

					default: Memory[Addr[11:2]] <= 32'h0000_0000;
				endcase				
				$display("@%h: *%h <= %h", now_pc, Addr, WD);
			end
		end
	end

endmodule
