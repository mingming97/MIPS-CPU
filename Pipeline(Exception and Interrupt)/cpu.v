`timescale 1ns / 1ps

`define rs 25:21
`define rt 20:16
`define rd 15:11
`define imm16 15:0
`define imm26 25:0
`define funct 5:0
`define op 31:26
`define br 20:16

module cpu(clk, reset, PrAddr, PrBE, PrRD, PrWD, PrWe, HWInt);

	input clk, reset;
	
	input [31:0] PrRD;
	input [7:2] HWInt;
	
	output [31:2] PrAddr;
	output [3:0] PrBE;
	output [31:0] PrWD;
	output PrWe;
	
	assign PrAddr = AO_M[31:2];
	assign PrBE = BE;
	assign PrWe = MemWr & we;
	assign PrWD = RD2_M;

	//pc
	wire [31:0] now_pc;

	//pcadd
	wire [31:0] pc4;
	wire [31:0] pc8;

	//im
	wire [31:0] instr;
	wire [4:0] ExcCode;

	//if_id
	wire [31:0] pc8_D;
	wire [31:0] instr_D_tmp;
	wire [31:0] pc_D;
	wire [4:0] ExcCode_D_tmp;

	//instrdetect
	wire [4:0] ExcCode_D_new;
	wire [31:0] instr_D;

	//cu_D
	wire [2:0] Comp;
	wire Branch;
	wire [1:0] nPc_sel;
	wire [1:0] ExtOp;
	wire clr_D;

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

	//npc
	wire [31:0] br_pc;
	wire [31:0] j_pc;
	wire [31:0] jr_pc;
	wire [31:0] epc;

	//pcmux
	wire [31:0] next_pc_tmp;

	//excpcmux
	wire [31:0] next_pc;

	//id_ex
	wire [31:0] pc8_E;
	wire [31:0] instr_E;
	wire [31:0] RD1_E_tmp;
	wire [31:0] RD2_E_tmp;
	wire [31:0] RD3_E_tmp;
	wire [31:0] Imm32_lbit_E;
	wire [31:0] Imm32_hbit_E;
	wire [31:0] pc_E;
	wire [4:0] ExcCode_E_tmp;

	//cu_E
	wire [3:0] ALUctr;
	wire ALUsrc_A;
	wire ALUsrc_B;
	wire [2:0] AO_Sel;
	wire [2:0] MD_ctr;
	wire Start;
	wire EnOverflow;
	wire Enmultdiv;
	wire is_load_E;
	wire is_save_E;

	//mfrse mfrte
	wire [31:0] RD1_E;
	wire [31:0] RD2_E;
	wire [31:0] RD3_E;

	//alusrc_mux
	wire [31:0] A;
	wire [31:0] B;

	//alu
	wire [31:0] AO_tmp;
	wire [4:0] ExcCode_E_new;
	
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
	wire [31:0] pc_M;
	wire [4:0] ExcCode_M_tmp;

	//cu_M
	wire MemWr;
	wire [1:0] save_Sel;
	wire [2:0] load_Sel_tmp;
	wire CP0_WE;
	wire is_load_M;
	wire is_save_M;
	wire is_loadb;
	wire is_saveb;

	//mfrsm mfrtm
	wire [31:0] RD1_M;
	wire [31:0] RD2_M;
	wire [31:0] RD3_M;
	
	//be_ext
	wire [3:0] BE;

	//addrdetect
	wire [4:0] ExcCode_M_new;
	wire we;
	
	//dm
	wire [31:0] RD_M;

	//cp0
	wire IntReq;
	wire ExcReq;
	wire [31:0] EPC;
	wire [31:0] CP0O_M;
	wire BD;

	//intctrl
	wire ExcPC_Sel;
	wire EXLSet;
	wire IF_ID_int_clr;
	wire ID_EX_int_clr;
	wire EX_MEM_int_clr;
	wire MEM_WB_int_clr;

	//mem_wb
	wire [31:0] pc8_W;
	wire [31:0] instr_W;
	wire [31:0] AO_W;
	wire [31:0] RD1_W;
	wire [31:0] RD2_W;
	wire [31:0] RD3_W;
	wire [31:0] RD_W_tmp;
	wire [31:0] CP0O_W;

	//cu_W
	wire [1:0] RegDst;
	wire [1:0] MemtoReg;
	wire RegWr;
	wire [2:0] load_Sel;
	wire is_delay_slot;
	wire EXLClr;
	
	//load_ext
	wire [31:0] RD_W;

	//WRAmux
	wire [4:0] A3;

	//WRDmux
	wire [31:0] WD;

	//stall
	wire IF_ID_En;
	wire ID_EX_clr;
	wire PC_En;

	//forward
	wire [2:0] ForwardRSD, ForwardRTD, ForwardRDD, ForwardRSE, ForwardRTE, ForwardRDE, ForwardRSM, ForwardRTM, ForwardRDM;
	
	//exccodemux
	wire [4:0] ExcCode_D, ExcCode_E, ExcCode_M;
	wire lock_muldiv;

	
	PC pc(
		.clk(clk),
		.reset(reset),
		.next_pc(next_pc),
		.En(PC_En),
		.IntReq(IntReq),
		.ExcReq(ExcReq),

		.now_pc(now_pc));

	PCadd pcadd(
		.now_pc(now_pc),

		.pc4(pc4),
		.pc8(pc8));

	IM im(
		.Addr(now_pc),

		.instr(instr),
		.ExcCode(ExcCode));

	IF_ID if_id(
		.clk(clk),
		.reset(reset),
		.En(IF_ID_En),
		.clr_D(clr_D),
		.int_clr(IF_ID_int_clr),
		.pc8(pc8),
		.instr(instr),
		.pc(now_pc),
		.ExcCode(ExcCode),

		.pc8_D(pc8_D),
		.instr_D(instr_D_tmp),
		.pc_D(pc_D),
		.ExcCode_D(ExcCode_D_tmp));

	InstrDetect instrdetect(
		.instr_D_tmp(instr_D_tmp),

		.ExcCode(ExcCode_D_new),
		.instr_D(instr_D));

	ControlUnit cu_D(
		.instr(instr_D),

		.Comp(Comp),
		.Branch(Branch),
		.nPc_sel(nPc_sel),
		.ExtOp(ExtOp),
		.clr_D(clr_D));

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
		.is_delay_slot(is_delay_slot),
		.IntReq(IntReq),
		.ExcReq(ExcReq),

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

	NPC npc(
		.Imm32(Imm32_lbit_D),
		.Imm28(Imm28),
		.pc8_D(pc8_D),
		.jr_pc_i(RD1_D),
		.epc_i(EPC),

		.br_pc(br_pc),
		.j_pc(j_pc),
		.jr_pc(jr_pc),
		.epc(epc));

	PCMux pcmux(
		.nPc_sel(nPc_sel),
		.Zero(Zero),
		.Branch(Branch),
		.pc4(pc4),
		.br_pc(br_pc),
		.jr_pc(jr_pc),
		.j_pc(j_pc),
		.epc(epc),

		.next_pc(next_pc_tmp));

	ExcPCMux excpcmux(
		.next_pc_tmp(next_pc_tmp),
		.ExcPC_Sel(ExcPC_Sel),

		.next_pc(next_pc));

	ID_EX id_ex(
		.clk(clk),
		.reset(reset),
		.En(1'b1),
		.clr(ID_EX_clr),
		.int_clr(ID_EX_int_clr),
		.pc8_D(pc8_D),
		.instr_D(instr_D),
		.RD1_D(RD1_D),
		.RD2_D(RD2_D),
		.RD3_D(RD3_D),
		.Imm32_lbit_D(Imm32_lbit_D),
		.Imm32_hbit_D(Imm32_hbit_D),
		.pc_D(pc_D),
		.ExcCode_D(ExcCode_D),

		.pc8_E(pc8_E),
		.instr_E(instr_E),
		.RD1_E(RD1_E_tmp),
		.RD2_E(RD2_E_tmp),
		.RD3_E(RD3_E_tmp),
		.Imm32_lbit_E(Imm32_lbit_E),
		.Imm32_hbit_E(Imm32_hbit_E),
		.pc_E(pc_E),
		.ExcCode_E(ExcCode_E_tmp));

	ControlUnit cu_E(
		.instr(instr_E),

		.ALUctr(ALUctr),
		.ALUsrc_A(ALUsrc_A),
		.ALUsrc_B(ALUsrc_B),
		.AO_Sel(AO_Sel),
		.MD_ctr(MD_ctr),
		.Start(Start),
		.EnOverflow(EnOverflow),
		.Enmultdiv(Enmultdiv),
		.is_load_E(is_load_E),
		.is_save_E(is_save_E));

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
		.EnOverflow(EnOverflow),
		.is_load_E(is_load_E),
		.is_save_E(is_save_E),

		.AO(AO_tmp),
		.ExcCode(ExcCode_E_new));
	
	/*MultDiv multdiv(
		.clk(clk),
		.reset(reset),
		.Start(Start),
		.RD1(RD1_E),
		.RD2(RD2_E),
		.MD_ctr(MD_ctr),
		.lock_muldiv(lock_muldiv),
		.Enmultdiv(Enmultdiv),
		.IntReq(IntReq),
		.ExcReq(ExcReq),
		
		.Busy(Busy),
		.HIO(HIO),
		.LOO(LOO));*/
	
	MultDivVer1 multdiv(
		.clk(clk),
		.reset(reset),
		.Start(Start),
		.RD1(RD1_E),
		.RD2(RD2_E),
		.MD_ctr(MD_ctr),
		.lock_muldiv(lock_muldiv),
		.Enmultdiv(Enmultdiv),
		.IntReq(IntReq),
		.ExcReq(ExcReq),
		
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
		.int_clr(EX_MEM_int_clr),
		.pc8_E(pc8_E),
		.instr_E(instr_E),
		.AO_E(AO_E),
		.RD1_E(RD1_E),
		.RD2_E(RD2_E),
		.RD3_E(RD3_E),
		.pc_E(pc_E),
		.ExcCode_E(ExcCode_E),

		.pc8_M(pc8_M),
		.instr_M(instr_M),
		.AO_M(AO_M),
		.RD1_M(RD1_M_tmp),
		.RD2_M(RD2_M_tmp),
		.RD3_M(RD3_M_tmp),
		.pc_M(pc_M),
		.ExcCode_M(ExcCode_M_tmp));

	ControlUnit cu_M(
		.instr(instr_M),

		.MemWr(MemWr),
		.save_Sel(save_Sel),
		.load_Sel(load_Sel_tmp),
		.CP0_WE(CP0_WE),
		.is_load_M(is_load_M),
		.is_save_M(is_save_M),
		.is_loadb(is_loadb),
		.is_saveb(is_saveb));

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

	AddrDetect addrdetect(
		.Addr(AO_M),
		.load_Sel_tmp(load_Sel_tmp),
		.save_Sel(save_Sel),
		.is_load_M(is_load_M),
		.is_save_M(is_save_M),
		.is_loadb(is_loadb),
		.is_saveb(is_saveb),
		
		.ExcCode(ExcCode_M_new),
		.we(we));
	
	DM dm(
		.clk(clk),
		.reset(reset),
		.Addr(AO_M[31:2]),
		.WD(RD2_M),
		.MemWr(MemWr),
		.BE(BE),
		.pc8_M(pc8_M),
		.PrRD(PrRD),
		.we(we),
		.IntReq(IntReq),

		.RD(RD_M));

	CP0 cp0(
		.clk(clk),
		.reset(reset),
		.A1(instr_M[`rd]),
		.A2(instr_M[`rd]),
		.DIn(RD2_M),
		.PC(pc_M),
		.ExcCode(ExcCode_M),
		.HWInt(HWInt),
		.We(CP0_WE),
		.EXLSet(EXLSet),
		.EXLClr(EXLClr),
		.is_delay_slot(is_delay_slot),

		.IntReq(IntReq),
		.ExcReq(ExcReq),
		.EPC(EPC),
		.DOut(CP0O_M));

	IntCtrl intctrl(
		.ExcReq(ExcReq),
		.IntReq(IntReq),

		.ExcPC_Sel(ExcPC_Sel),
		.EXLSet(EXLSet),
		.IF_ID_int_clr(IF_ID_int_clr),
		.ID_EX_int_clr(ID_EX_int_clr),
		.EX_MEM_int_clr(EX_MEM_int_clr),
		.MEM_WB_int_clr(MEM_WB_int_clr));

	MEM_WB mem_wb(
		.clk(clk),
		.reset(reset),
		.int_clr(MEM_WB_int_clr),
		.pc8_M(pc8_M),
		.instr_M(instr_M),
		.AO_M(AO_M),
		.RD1_M(RD1_M),
		.RD2_M(RD2_M),
		.RD3_M(RD3_M),
		.RD_M(RD_M),
		.CP0O_M(CP0O_M),

		.pc8_W(pc8_W),
		.instr_W(instr_W),
		.AO_W(AO_W),
		.RD1_W(RD1_W),
		.RD2_W(RD2_W),
		.RD3_W(RD3_W),
		.RD_W(RD_W_tmp),
		.CP0O_W(CP0O_W));

	ControlUnit cu_W(
		.instr(instr_W),

		.RegWr(RegWr),
		.RegDst(RegDst),
		.MemtoReg(MemtoReg),
		.load_Sel(load_Sel),
		.is_delay_slot(is_delay_slot),
		.EXLClr(EXLClr));
	
	LOAD_EXT load_ext(
		.RD_tmp(RD_W_tmp),
		.load_Sel(load_Sel),
		.addr1_0(AO_W[1:0]),
		
		.RD(RD_W));

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
		.CP0O(CP0O_W),

		.WD(WD));
		
	Stall stall(
		.instr_D(instr_D),
		.instr_E(instr_E),
		.instr_M(instr_M),
		.Busy(Busy),
		.Start(Start),
		
		.IF_ID_En(IF_ID_En),
		.ID_EX_clr(ID_EX_clr),
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

	ExcCodeMux exccodemux(
		.ExcCode_D_new(ExcCode_D_new),
		.ExcCode_D_tmp(ExcCode_D_tmp),
		.ExcCode_D(ExcCode_D),
		
		.ExcCode_E_new(ExcCode_E_new),
		.ExcCode_E_tmp(ExcCode_E_tmp),
		.ExcCode_E(ExcCode_E),

		.ExcCode_M_new(ExcCode_M_new),
		.ExcCode_M_tmp(ExcCode_M_tmp),
		.ExcCode_M(ExcCode_M),
		
		.IntReq(IntReq),
		.ExcReq(ExcReq),
		.lock_muldiv(lock_muldiv));

endmodule

