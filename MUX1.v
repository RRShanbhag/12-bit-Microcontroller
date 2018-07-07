/*****************************************************************************
 *
 *Multiplexer 1 for 12 bit Microcontoller
 *Inputs : Input1 (8 bits), Input2(8 bits), Select 
 *
 *Outputs: Out (8bits)  
 *
 *Reference:
 *http://www.fpga4student.com/2016/11/verilog-hdl-implementation-of-micro.html
 *****************************************************************************/

 module MUX1(
 	input [7:0] Input1, Input2,
 	input Sel,
 	output [7:0] Out
 );

 assign Out = (Sel == 1)? Input1: Input2;
 endmodule