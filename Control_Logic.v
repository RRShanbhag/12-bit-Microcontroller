/*****************************************************************************
 *
 *Control Unit for 12 bit Microcontoller
 *Inputs : Instr_Reg (12 bits), State(2 bits), Status_Reg(4 bits)
 *
 *Outputs: ProgCounter_En, Acc_En, StatusReg_En, InstrReg_En, DataMemWrite_En,
 * 		   ALU_En, MUX1_Sel, MUX2_Sel, DataMem_En, ProgMem_En, ALU_Mode, 
 *		   ProgMemLoad_En
 *
 *Reference:
 *http://www.fpga4student.com/2016/11/verilog-hdl-implementation-of-micro.html
 *****************************************************************************/
 module Control_Logic(
 input [11:0] Instr_Reg,
 input [1:0] State,
 input [3:0] Status_Reg,
 output ProgCounter_En, Acc_En, StatusReg_En, InstrReg_En, ProgMem_En, 
 output DataMemWrite_En, ALU_En, MUX1_Sel, DataMem_En, DataReg_En, MUX2_Sel,
 output ProgMemLoad_En,
 output [3:0] ALU_Mode
 );

 parameter LOAD = 2'b00, FETCH = 2'b01, DECODE = 2'b10, EXECUTE = 2'b11;

 reg ProgCounter_En, Acc_En, StatusReg_En, InstrReg_En, ProgMem_En;
 reg DataMemWrite_En, ALU_En, MUX1_Sel, DataMem_En, DataReg_En, MUX2_Sel;
 reg ProgMemLoad_En;
 reg [3:0] ALU_Mode;

 always@(*)
 begin

 	//Initialize all the signals at every input change.
 	ProgMemLoad_En = 0;
	ProgCounter_En = 0;
	Acc_En = 0;
	StatusReg_En = 0;
	InstrReg_En = 0;
	ProgMem_En = 0;
	DataMemWrite_En = 0;
	ALU_En = 0;
	MUX1_Sel = 0;
	DataMem_En = 0;
	DataReg_En = 0;
	MUX2_Sel = 0;
	ALU_Mode = 4'h0;

	// Load State -> Enable the Program Memory and the Load Signal
	if(State == LOAD)
	begin
		ProgMemLoad_En = 1'b1;
		ProgMem_En = 1'b1;
	end

	//Fetch State -> Fetch the instruction from Program Memory and load it to IR
	else if (State == FETCH)
	begin
		InstrReg_En = 1'b1;
		ProgMem_En = 1'b1;
	end

	//Decode State -> Decode the instr in the IR and send it to ALU and other modules
	//Instruction Register = {Instruction Type(11:8), Opcode(11:8)/Immediate(7:4), 
	//						  Immediate_value/DMem_Addr(3:1) }
	//
 	else if (State == DECODE)
 	begin
 		if (Instr_Reg[11:9] == 3'b001)	// M-type
 		begin
 			DataReg_En = 1'b1; 
 			DataMem_En = 1'b1;
 		end
 		else
 		begin
 			DataReg_En = 1'b0;
 			DataMem_En = 1'b0;
 		end
 	end

 	else if (State == EXECUTE)
 	begin
 		if (Instr_Reg[11] == 1'b1) // I-Type Operation
 		begin
 			ProgCounter_En = 1'b1; // Take current Instr_Addr
 			Acc_En = 1'b1; // Since I-Type, Operand2 for ALU -> Accumulator
 			StatusReg_En = 1'b1; //Enable Status Register
 			ALU_En = 1'b1; //Enable ALU
 			ALU_Mode = Instr_Reg[10:8]; //Opcode in I-Type-> 4'b0xxx
 			MUX1_Sel = 1; // Take the next Instruction Addr from Adder
 			MUX2_Sel = 0; // Do not take value from Memory
 		end
 		else if(Instr_Reg[11:10] == 2'b01) //JZ, JC, JS, JO
 		begin
 			ProgCounter_En = 1'b1;
 			MUX1_Sel = Status_Reg[Instr_Reg[9:8]];
 		end
 		else if(Instr_Reg[9] == 1'b1) // Execute M-type Instruction
 		begin
 			ProgCounter_En = 1'b1;
 			Acc_En = Instr_Reg[8];
 			StatusReg_En = 1'b1;
 			DataMem_En = !(Instr_Reg[8]);
 			DataReg_En = !(Instr_Reg[8]);
 			ALU_En = 1'b1;
 			ALU_Mode = Instr_Reg[7:4];
 			MUX1_Sel = 1'b1;
 			MUX2_Sel = 1'b1;
 		end
 		else if(Instr_Reg[8] == 1'b0)
 		begin
 			ProgCounter_En = 1'b1;
 			MUX1_Sel = 1'b1;
 		end
 		else
 		begin
 			ProgCounter_En = 1'b0;
 			MUX1_Sel = 1'b0;
 		end
 	end
 end
 endmodule