/*****************************************************************************
 *
 *TestBench for ALU module
 *Inputs : Operand1 (8 bits), Operand2 (8bits), Enable, Mode(4 bits), 
 *		   CurrentFlags (4 bits)
 *Outputs: Result (8 bits), Flags(4 bits)  
 *
 *Reference:
 *http://www.fpga4student.com/2016/11/verilog-hdl-implementation-of-micro.html
 *****************************************************************************/

 module ALU_tb;

 reg en;
 reg [7:0] op1;
 reg [7:0] op2;
 reg [3:0] mode;
 reg [3:0] cflags;

 wire [7:0] result;
 wire [3:0] flags_out;

 ALU uut(
 .Enable(en),
 .Operand1(op1),
 .Operand2(op2),
 .Mode(mode),
 .Cflags(cflags),
 .Result(result),
 .Flags(flags_out)
 );

 initial begin

 op1 = 8'h0;
 op2 = 8'h0;
 en = 1'b0;

 #10;

 op1 = 8'hFC;
 op2 = 8'h8;
 en = 1'b1;

 #20 mode = 4'b0000;
 #20 mode = 4'b0001;
 #20 mode = 4'b0010;
 #20 mode = 4'b0011;
 #20 mode = 4'b0100;
 #20 mode = 4'b0101;
 #20 mode = 4'b0110;
 #20 mode = 4'b0111;
 #20 mode = 4'b1000;
 #20 mode = 4'b1001;
 #20 mode = 4'b1010;
 #20 mode = 4'b1011;
 #20 mode = 4'b1100;
 #20 mode = 4'b1101;
 #20 mode = 4'b1110;
 #20 mode = 4'b1111;
 #50;
 end

 initial begin
 $dumpfile("alu.vcd");
 $dumpvars;
 end
 endmodule
