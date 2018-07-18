# 12-bit-Microcontroller
HDL: Verilog. Compiler: iVerilog. RT Engine: Icarus VVP. Platform: Linux.

Reference and Architecture: 
http://www.fpga4student.com/2016/11/verilog-hdl-implementation-of-micro.html

Test Case 1:
0000_0000_0000 //NOP
1011_0000_0001 //MOV Acc <- 1
0010_0010_0000 //MOV DMem <- Acc
1011_0000_0000 //MOV Acc <- 0
0011_0011_0000 //MOV Acc <- DMem
0001_0000_0101 //PC <- 5; Instr_Reg <- PMem[5]
0000_0000_0000 //NOP
0000_0000_0000 //NOP
0000_0000_0000 //NOP
0000_0000_0000 //NOP
