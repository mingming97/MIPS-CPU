`timescale 1ns / 1ps

`define rs 25:21
`define rt 20:16
`define rd 15:11
`define imm16 15:0
`define imm26 25:0
`define funct 5:0
`define op 31:26
`define br 20:16

module mips(clk, reset);

	input clk, reset;

	//pc
	wire [31:0] now_pc;

	//pcadd
	wire [31:0] pc4;
	wire [31:0] pc8;

	//im
	wire [31:0] instr;

	//if_id
	wire [31:0] pc8_D;
	wire [31:0] instr_D;

	//cu_D
	wire [2:0] Comp;
	wire Branch;
	wire [1:0] nPc_sel;
	wire [1:0] ExtOp;
	wire [1:0] clr_sel;

	//ext
	wire [27:0] Imm28;
	wire [31:0] Imm32_lbit_D;
	wire [31:0] Imm32_hbit_D;

	//grf
	wire [31:0] RD1_tmp;
	wire [31:0] RD2_tmp;
	wire [31:0] RD3_tmp;

	//mfrsd mfrtd
	wire [31:0] RD1_D;
	wire [31:0] RD2_D;
	wire [31:0] RD3_D;

	//compare
	wire Zero;
	
	//clrcontrol
	wire IF_ID_clr;
	wire ID_EX_clr;

	//npc
	wire [31:0] br_pc;
	wire [31:0] j_pc;
	wire [31:0] jr_pc;

	//pcmux
	wire [31:0] next_pc;

	//id_ex
	wire [31:0] pc8_E;
	wire [31:0] instr_E;
	wire [31:0] RD1_E_tmp;
	wire [31:0] RD2_E_tmp;
	wire [31:0] RD3_E_tmp;
	wire [31:0] Imm32_lbit_E;
	wire [31:0] Imm32_hbit_E;
	wire Zero_E;

	//cu_E
	wire [3:0] ALUctr;
	wire ALUsrc_A;
	wire ALUsrc_B;
	wire [2:0] AO_Sel;
	wire [2:0] MD_ctr;
	wire Start;

	//mfrse mfrte
	wire [31:0] RD1_E;
	wire [31:0] RD2_E;
	wire [31:0] RD3_E;

	//alusrc_mux
	wire [31:0] A;
	wire [31:0] B;

	//alu
	wire [31:0] AO_tmp;
	
	//mult_div
	wire [31:0] HIO;
	wire [31:0] LOO;
	wire Busy;

	//ao_mux
	wire [31:0] AO_E;

	//ex_mem
	wire [31:0] pc8_M;
	wire [31:0] instr_M;
	wire [31:0] AO_M;
	wire [31:0] RD1_M_tmp;
	wire [31:0] RD2_M_tmp;
	wire [31:0] RD3_M_tmp;
	wire Zero_M;

	//cu_M
	wire MemWr;
	wire [1:0] save_Sel;

	//mfrsm mfrtm
	wire [31:0] RD1_M;
	wire [31:0] RD2_M;
	wire [31:0] RD3_M;
	
	//be_ext
	wire [3:0] BE;
	
	//dm
	wire [31:0] RD_M;

	//mem_wb
	wire [31:0] pc8_W;
	wire [31:0] instr_W;
	wire [31:0] AO_W;
	wire [31:0] RD1_W;
	wire [31:0] RD2_W;
	wire [31:0] RD3_W;
	wire [31:0] RD_W_tmp;
	wire Zero_W;

	//cu_W
	wire RegWr_tmp;
	wire [1:0] RegDst;
	wire [1:0] MemtoReg;
	wire RegWr_sel;
	wire [2:0] load_Sel;
	
	//load_ext
	wire [31:0] RD_W;

	//WRAmux
	wire [4:0] A3;

	//WRDmux
	wire [31:0] WD;

	//stall
	wire IF_ID_En;
	wire ID_EX_clr_tmp;
	wire PC_En;

	//forward
	wire [2:0] ForwardRSD, ForwardRTD, ForwardRDD, ForwardRSE, ForwardRTE, ForwardRDE, ForwardRSM, ForwardRTM, ForwardRDM;
	
	PC pc(
		.clk(clk),
		.reset(reset),
		.next_pc(next_pc),
		.En(PC_En),	

		.now_pc(now_pc));

	PCadd pcadd(
		.now_pc(now_pc),

		.pc4(pc4),
		.pc8(pc8));

	IM im(
		.Addr(now_pc),

		.instr(instr));

	IF_ID if_id(
		.clk(clk),
		.reset(reset),
		.En(IF_ID_En),
		.clr(IF_ID_clr),
		.pc8(pc8),
		.instr(instr),

		.pc8_D(pc8_D),
		.instr_D(instr_D));

	ControlUnit cu_D(
		.instr(instr_D),

		.Comp(Comp),
		.Branch(Branch),
		.nPc_sel(nPc_sel),
		.ExtOp(ExtOp),
		.clr_sel(clr_sel));

	EXT ext(
		.Imm16(instr_D[`imm16]),
		.Imm26(instr_D[`imm26]),
		.ExtOp(ExtOp),

		.Imm28(Imm28),
		.Imm32_lbit(Imm32_lbit_D),
		.Imm32_hbit(Imm32_hbit_D));

	GRF grf(
		.clk(clk),
		.reset(reset),
		.A1(instr_D[`rs]),
		.A2(instr_D[`rt]),
		.A3(A3),
		.A4(instr_D[`rd]),
		.WD(WD),
		.RegWr(RegWr),
		.pc8(pc8_W),

		.RD1(RD1_tmp),
		.RD2(RD2_tmp),
		.RD3(RD3_tmp));

	MFRSD mfrsd(
		.ForwardRSD(ForwardRSD),
		.RD1_tmp(RD1_tmp),
		.pc8_E(pc8_E),
		.pc8_M(pc8_M),
		.AO_M(AO_M),

		.RD1_D(RD1_D));

	MFRTD mfrtd(
		.ForwardRTD(ForwardRTD),
		.RD2_tmp(RD2_tmp),
		.pc8_E(pc8_E),
		.pc8_M(pc8_M),
		.AO_M(AO_M),

		.RD2_D(RD2_D));
	
	MFRDD mfrdd(
		.ForwardRDD(ForwardRDD),
		.RD3_tmp(RD3_tmp),
		.pc8_E(pc8_E),
		.pc8_M(pc8_M),
		.AO_M(AO_M),

		.RD3_D(RD3_D));

	Compare compare(
		.RD1(RD1_D),
		.RD2(RD2_D),
		.Imm32_lbit(Imm32_lbit_D),
		.Comp(Comp),

		.Zero(Zero));
	
	ClrControl clrcontrol(
		.ID_EX_clr_tmp(ID_EX_clr_tmp),
		.Zero(Zero), 
		.clr_sel(clr_sel),
		
		.IF_ID_clr(IF_ID_clr),
		.ID_EX_clr(ID_EX_clr));

	NPC npc(
		.Imm32(Imm32_lbit_D),
		.Imm28(Imm28),
		.pc8_D(pc8_D),
		.jr_pc_i(RD1_D),

		.br_pc(br_pc),
		.j_pc(j_pc),
		.jr_pc(jr_pc));

	PCMux pcmux(
		.nPc_sel(nPc_sel),
		.Zero(Zero),
		.Branch(Branch),
		.pc4(pc4),
		.br_pc(br_pc),
		.jr_pc(jr_pc),
		.j_pc(j_pc),

		.next_pc(next_pc));

	ID_EX id_ex(
		.clk(clk),
		.reset(reset),
		.En(1'b1),
		.clr(ID_EX_clr),
		.pc8_D(pc8_D),
		.instr_D(instr_D),
		.RD1_D(RD1_D),
		.RD2_D(RD2_D),
		.RD3_D(RD3_D),
		.Imm32_lbit_D(Imm32_lbit_D),
		.Imm32_hbit_D(Imm32_hbit_D),
		.Zero_D(Zero),

		.pc8_E(pc8_E),
		.instr_E(instr_E),
		.RD1_E(RD1_E_tmp),
		.RD2_E(RD2_E_tmp),
		.RD3_E(RD3_E_tmp),
		.Imm32_lbit_E(Imm32_lbit_E),
		.Imm32_hbit_E(Imm32_hbit_E),
		.Zero_E(Zero_E));

	ControlUnit cu_E(
		.instr(instr_E),

		.ALUctr(ALUctr),
		.ALUsrc_A(ALUsrc_A),
		.ALUsrc_B(ALUsrc_B),
		.AO_Sel(AO_Sel),
		.MD_ctr(MD_ctr),
		.Start(Start));

	MFRSE mfrse(
		.ForwardRSE(ForwardRSE),
		.RD1_E_tmp(RD1_E_tmp),
		.pc8_M(pc8_M),
		.AO_M(AO_M),
		.WD(WD),

		.RD1_E(RD1_E));

	MFRTE mfrte(
		.ForwardRTE(ForwardRTE),
		.RD2_E_tmp(RD2_E_tmp),
		.pc8_M(pc8_M),
		.AO_M(AO_M),
		.WD(WD),

		.RD2_E(RD2_E));

	MFRDE mfrde(
		.ForwardRDE(ForwardRDE),
		.RD3_E_tmp(RD3_E_tmp),
		.pc8_M(pc8_M),
		.AO_M(AO_M),
		.WD(WD),

		.RD3_E(RD3_E));	
	

	ALUsrc_AMux alu_a_mux(
		.ALUsrc_A(ALUsrc_A),
		.RD1(RD1_E),
		.RD2(RD2_E),

		.A(A));

	ALUsrc_BMux alu_b_mux(
		.ALUsrc_B(ALUsrc_B),
		.RD2(RD2_E),
		.Imm32_lbit(Imm32_lbit_E),

		.B(B));

	ALU alu(
		.A(A),
		.B(B),
		.ALUctr(ALUctr),

		.AO(AO_tmp));
	
	MultDiv multdiv(
		.clk(clk),
		.reset(reset),
		.Start(Start),
		.RD1(RD1_E),
		.RD2(RD2_E),
		.MD_ctr(MD_ctr),
		
		.Busy(Busy),
		.HIO(HIO),
		.LOO(LOO));

	AO_Mux ao_mux(
		.AO_Sel(AO_Sel),
		.AO_tmp(AO_tmp),
		.Imm32_hbit_E(Imm32_hbit_E),
		.RD1_E(RD1_E),
		.HIO(HIO),
		.LOO(LOO),

		.AO_E(AO_E));

	EX_MEM ex_mem(
		.clk(clk),
		.reset(reset),
		.En(1'b1),
		.clr(1'b0),
		.pc8_E(pc8_E),
		.instr_E(instr_E),
		.AO_E(AO_E),
		.RD1_E(RD1_E),
		.RD2_E(RD2_E),
		.RD3_E(RD3_E),
		.Zero_E(Zero_E),

		.pc8_M(pc8_M),
		.instr_M(instr_M),
		.AO_M(AO_M),
		.RD1_M(RD1_M_tmp),
		.RD2_M(RD2_M_tmp),
		.RD3_M(RD3_M_tmp),
		.Zero_M(Zero_M));

	ControlUnit cu_M(
		.instr(instr_M),

		.MemWr(MemWr),
		.save_Sel(save_Sel));

	MFRSM mfrsm(
		.ForwardRSM(ForwardRSM),
		.RD1_M_tmp(RD1_M_tmp),
		.WD(WD),

		.RD1_M(RD1_M));

	MFRTM mfrtm(
		.ForwardRTM(ForwardRTM),
		.RD2_M_tmp(RD2_M_tmp),
		.WD(WD),

		.RD2_M(RD2_M));
	
	MFRDM mfrdm(
		.ForwardRDM(ForwardRDM),
		.RD3_M_tmp(RD3_M_tmp),
		.WD(WD),

		.RD3_M(RD3_M));
	
	BE_EXT be_ext(
		.save_Sel(save_Sel),
		.addr1_0(AO_M[1:0]),
		
		.BE(BE));
	
	DM dm(
		.clk(clk),
		.reset(reset),
		.Addr(AO_M[13:2]),
		.WD(RD2_M),
		.MemWr(MemWr),
		.BE(BE),
		.pc8_M(pc8_M),

		.RD(RD_M));

	MEM_WB mem_wb(
		.clk(clk),
		.reset(reset),
		.pc8_M(pc8_M),
		.instr_M(instr_M),
		.AO_M(AO_M),
		.RD1_M(RD1_M),
		.RD2_M(RD2_M),
		.RD3_M(RD3_M),
		.RD_M(RD_M),
		.Zero_M(Zero_M),

		.pc8_W(pc8_W),
		.instr_W(instr_W),
		.AO_W(AO_W),
		.RD1_W(RD1_W),
		.RD2_W(RD2_W),
		.RD3_W(RD3_W),
		.RD_W(RD_W_tmp),
		.Zero_W(Zero_W));

	ControlUnit cu_W(
		.instr(instr_W),

		.RegWr(RegWr_tmp),
		.RegDst(RegDst),
		.MemtoReg(MemtoReg),
		.RegWr_sel(RegWr_sel),
		.load_Sel(load_Sel));
	
	LOAD_EXT load_ext(
		.RD_tmp(RD_W_tmp),
		.load_Sel(load_Sel),
		.addr1_0(AO_W[1:0]),
		
		.RD(RD_W));
	
	
		
	RegWrMux regwrmux(
		.RegWr_tmp(RegWr_tmp),
		.Zero(Zero_W),
		.RegWr_sel(RegWr_sel),
		
		.RegWr(RegWr));

	WrRegAddrMux WRAmux(
		.RegDst(RegDst),
		.rt(instr_W[`rt]),
		.rd(instr_W[`rd]),

		.A3(A3));

	WrRegDataMux WRDmux(
		.MemtoReg(MemtoReg),
		.AO(AO_W),
		.RD(RD_W),
		.pc8(pc8_W),

		.WD(WD));
		
	Stall stall(
		.instr_D(instr_D),
		.instr_E(instr_E),
		.instr_M(instr_M),
		.Busy(Busy),
		.Start(Start),
		
		.IF_ID_En(IF_ID_En),
		.ID_EX_clr(ID_EX_clr_tmp),
		.PC_En(PC_En));

	Forward forward(
		.instr_D(instr_D),
		.instr_E(instr_E),
		.instr_M(instr_M),
		.instr_W(instr_W),

		.ForwardRSD(ForwardRSD),
		.ForwardRTD(ForwardRTD),
		.ForwardRDD(ForwardRDD),
		.ForwardRSE(ForwardRSE),
		.ForwardRTE(ForwardRTE),
		.ForwardRDE(ForwardRDE),
		.ForwardRSM(ForwardRSM),
		.ForwardRTM(ForwardRTM),
		.ForwardRDM(ForwardRDM));

endmodule
