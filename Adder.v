/*****************************************************************************
 *
 *Adder for 12 bit Microcontoller
 *Inputs : In_data (8 bits)
 *
 *Outputs: Out_data (8bits)  
 *
 *Reference:
 *http://www.fpga4student.com/2016/11/verilog-hdl-implementation-of-micro.html
 *****************************************************************************/

 module Adder(
 	input [7:0] In_data,
 	output [7:0] Out_data
 );

 assign Out_data = In_data + 1;
 endmodule