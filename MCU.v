/*****************************************************************************
 *
 *12 bit Microcontoller (simplified version)
 *Harvard Architecture, Non-pipelined
 *Inputs : clk (1 bit), reset(1 bit)
 *
 *Reference:
 *http://www.fpga4student.com/2016/11/verilog-hdl-implementation-of-micro.html
 *****************************************************************************/
 module MCU(
 	input clk, rst
 );

 //Initialize States.
 parameter LOAD = 2'b00, FETCH=2'b01, DECODE=2'b10, EXECUTE = 2'b11;
 
 //Initialize Registers and Memory
 reg LoadDone;
 reg ProgCounter_Clr, Accumulator_Clr, StatusReg_Clr, DataReg_Clr, InstrReg_Clr;
 reg[1:0] currentState, nextState;
 reg[3:0] StatusReg;
 reg[7:0] LoadAddr;
 reg[7:0] ProgCounter, DataReg, Accumulator;
 reg[11:0] InstrReg;
 reg[11:0] ProgMem[9:0];

 //Initialize all signals 
 wire ProgCounter_En, Accumulator_En, StatusReg_En, DataReg_En, InstrReg_En; 
 wire ProgMem_En, DataMem_En, DataMem_WEn, ALU_En, ProgMem_LEn, MUX1_Sel, MUX2_Sel;
 wire[3:0] StatusReg_Updated;
 wire[3:0] ALU_Mode;
 wire[7:0] AdderOut;
 wire[7:0] ALU_Out, ALU_Operand2;
 wire[7:0] ProgCounter_Updated, DataReg_Updated;
 wire[11:0] InstrReg_Updated;
 wire[11:0] LoadInstr;

 //LOAD all the 10 instructions to Memory
 initial
 begin
 $readmemb("/home/shanbhag/Desktop/Verilog_Projects/MCU/tests/case1.dat", ProgMem, 0, 9);
 end
 
 //ALU
 ALU ALU_unit(
 .Operand1(Accumulator),
 .Operand2(ALU_Operand2),
 .Enable(ALU_En),
 .Mode(ALU_Mode),
 .Cflags(StatusReg),
 .Result(ALU_Out),
 .Flags(StatusReg_Updated)
 );

 //MUX1
 MUX1 MUX1_unit(
 .Input1(AdderOut),
 .Input2(InstrReg[7:0]),
 .Sel(MUX1_Sel),
 .Out(ProgCounter_Updated)
 );

 //MUX2
 MUX1 MUX2_unit(
 .Input1(DataReg),
 .Input2(InstrReg[7:0]),
 .Sel(MUX2_Sel),
 .Out(ALU_Operand2)
 );

 //Data Memory
 DMem DMem_unit(
 .clk(clk),
 .Enable(DataMem_En),
 .Write_en(DataMem_WEn),
 .Address_port(InstrReg[3:0]),
 .Input_data(ALU_Out),
 .Output_data(DataReg_Updated)
 );

 //Program Memory
 PMem PMem_unit(
 .clk(clk),
 .En(ProgMem_En),
 .Addr(ProgCounter),
 .Load_En(ProgMem_LEn),
 .Load_Addr(LoadAddr),
 .Load_Instr(LoadInstr),
 .Instr(InstrReg_Updated)
 );

 //Adder
 Adder PC_Adder_unit(
 .In_data(ProgCounter),
 .Out_data(AdderOut)
 );

 //Control Unit
 Control_Logic Control_Logic_unit(
 .Instr_Reg(InstrReg),
 .State(currentState),
 .Status_Reg(StatusReg),
 .ProgCounter_En(ProgCounter_En),
 .Acc_En(Accumulator_En),
 .StatusReg_En(StatusReg_En),
 .InstrReg_En(InstrReg_En),
 .ProgMem_En(ProgMem_En),
 .DataMemWrite_En(DataMem_WEn),
 .ALU_En(ALU_En),
 .MUX1_Sel(MUX1_Sel),
 .MUX2_Sel(MUX2_Sel),
 .DataMem_En(DataMem_En),
 .DataReg_En(DataReg_En),
 .ProgMemLoad_En(ProgMem_LEn),
 .ALU_Mode(ALU_Mode)
 );

 //LOAD consequent instructions from the programMem to LoadInstr for every posedge.
 always @(posedge clk) 
 begin
 	if(rst == 1)
 	begin
 		LoadAddr <= 0;
 		LoadDone <= 1'b0;
 	end
 	else if(ProgMem_LEn == 1'b1)
 	begin
 		LoadAddr <= LoadAddr+8'd1;
	 	if(LoadAddr == 8'd9)
	 	begin
	 		LoadAddr <= 8'd0;
	 		LoadDone <= 1'b1;
	 	end
	 	else
	 	begin
	 		LoadDone <= 1'b0;
	 	end
	end
 end
 assign LoadInstr = ProgMem[LoadAddr];

 //Go to the next state at every posedge.
 always @(posedge clk)
 begin
 	//if rst then set the state initially to Load.
 	if(rst == 1)
 		currentState <= LOAD;
 	//Else whatever is the next state.
 	else
 		currentState <= nextState;
 end

 //For every change in clk
 always @(*)
 begin
 	ProgCounter_Clr = 0; 
 	Accumulator_Clr = 0;
 	StatusReg_Clr = 0; 
 	DataReg_Clr = 0;
 	InstrReg_Clr = 0;
 	case(currentState)
 	
	 	LOAD:
	 	begin
	 	//After Load, set the nextState to FETCH and clear all the registers. 
	 		if(LoadDone == 1)
	 		begin
	 			nextState = FETCH;
	 			ProgCounter_Clr = 1; 
	 			Accumulator_Clr = 1;
	 			StatusReg_Clr = 1; 
	 			DataReg_Clr = 1;
	 			InstrReg_Clr = 1;
	 		end
	 		else
	 		nextState = LOAD;
	 	end

	 	FETCH:
	 	begin
	 		nextState = DECODE;
	 	end

	 	DECODE:
	 	begin
	 		nextState = EXECUTE;
	 	end

	 	EXECUTE:
	 	begin
	 		nextState = FETCH; // These are blocking assignments. Hence, happens 
	 	end

 	endcase
 end

 //Update Program Counter, Accumulator and Status Register for every 
 //posedge of clock.
 always @(posedge clk)
 begin
 	if(rst == 1)
 	begin
 		ProgCounter <= 8'd0;
 		Accumulator <= 8'd0;
 		StatusReg 	<= 8'd0;
 	end
 	else
 	begin
 		if(ProgCounter_En == 1'b1)
 			ProgCounter = ProgCounter_Updated;
 		else if (ProgCounter_Clr == 1)
 			ProgCounter = 8'd0;
 		if(Accumulator_En == 1'b1)
 			Accumulator <= ALU_Out;
 		else if(Accumulator_Clr == 1)
 			Accumulator <= 8'd0;
 		if(StatusReg_En == 1'b1)
 			StatusReg <= StatusReg_Updated;
 		else if(StatusReg_Clr == 1)
 			StatusReg <= 4'd0;
 	end
 end

 //Update the Data Register and Program Register.
 always @(posedge clk)
 begin
 	if(DataReg_En == 1'b1)
 		DataReg <= DataReg_Updated;
 	else if(DataReg_Clr == 1)
 		DataReg <= 8'd0;
 	if(InstrReg_En == 1'b1)
 		InstrReg <= InstrReg_Updated;
 	else if(InstrReg_Clr == 1)
 		InstrReg <= 12'd0;
 end
 endmodule