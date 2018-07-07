/*****************************************************************************
 *
 *Program Memory (256 bytes) for 12 bit Microcontoller
 *Inputs : Instr_port (12 bits), En, Load_En, clk, Load_Addr(8 bits),
 *		   Load_Instr(12 bits)  
 *
 *Outputs: Out_data (8bits)  
 *
 *Reference:
 *http://www.fpga4student.com/2016/11/verilog-hdl-implementation-of-micro.html
 *****************************************************************************/

 module PMem(
 	input clk,
 	input En,
 	input [7:0] Addr,
 	input Load_En,
 	input [7:0] Load_Addr,
 	input [11:0]Load_Instr,
 	output [11:0] Instr
 );

 reg [11:0] Prog_Mem[255:0];

 always@(posedge clk)
 begin
 	if(Load_En) begin
 		Prog_Mem[Load_Addr] <= Load_Instr;
 	end
 end

 assign Instr = (En == 1)? Prog_Mem[Addr]:0;
 endmodule


