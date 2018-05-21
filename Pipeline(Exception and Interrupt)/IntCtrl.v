`timescale 1ns / 1ps

module IntCtrl(
	ExcReq, IntReq,
	ExcPC_Sel, EXLSet, 
	IF_ID_int_clr, ID_EX_int_clr, EX_MEM_int_clr, MEM_WB_int_clr);
	
	input ExcReq, IntReq;
	
	output ExcPC_Sel;
	output EXLSet;
	output IF_ID_int_clr, ID_EX_int_clr, EX_MEM_int_clr, MEM_WB_int_clr;
	
	assign ExcPC_Sel = ExcReq | IntReq;
	assign EXLSet = ExcReq | IntReq;
	assign IF_ID_int_clr = ExcReq | IntReq;
	assign ID_EX_int_clr = ExcReq | IntReq;
	assign EX_MEM_int_clr = ExcReq | IntReq;
	assign MEM_WB_int_clr = ExcReq | IntReq;


endmodule
