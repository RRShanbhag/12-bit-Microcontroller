/*****************************************************************************
 *
 *Microcontroller Test Bench
 *Inputs : Clock and Reset
 *
 *Outputs: None. Check all Module Outputs after every clock cycle.  
 *
 *Reference:
 *http://www.fpga4student.com/2016/11/verilog-hdl-implementation-of-micro.html
 *****************************************************************************/

 module MCU_tb;

 reg clk;
 reg rst;

 MCU MCU_UUT(
 	.clk(clk),
 	.rst(rst)
 );

 initial 
 begin

	 //Initialize Inputs
	 rst = 1;

	 //Wait till all modules reset.
	 #100;
	 rst = 0;
 end

 initial begin
 	$dumpfile("mcu.vcd");
	$dumpvars;
 end
 
 initial 
 begin
 	clk = 0;
 	repeat(600)
 	begin
 		#1 clk = ~clk;
 	end
 end
 endmodule