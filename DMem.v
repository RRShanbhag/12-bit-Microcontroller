/*****************************************************************************
 *
 *Data Memory module (256 bytes) for 12 bit Microcontoller
 *Inputs : Input_data (8 bits), Enable, Write_Enable, Address_port(4 bits) 
 *		   and Clock
 *Outputs: Output_data (8bits)  
 *
 *Reference:
 *http://www.fpga4student.com/2016/11/verilog-hdl-implementation-of-micro.html
 *****************************************************************************/
 module DMem(
 	input clk,
 	input Enable,
 	input Write_en,
 	input [3:0] Address_port,
 	input [7:0] Input_data,
 	output [7:0] Output_data
 );

 reg [7:0] data_mem [255:0]; 

 always@(posedge clk)
 begin
 	if(Enable == 1 && Write_en == 1)
 		data_mem[Address_port] <= Input_data;
 end
 assign Output_data = (Enable == 1)? data_mem[Address_port]:0;
 endmodule
