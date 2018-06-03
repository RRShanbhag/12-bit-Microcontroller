/*****************************************************************************
 *
 *Data Memory Test Bench (256 bytes) for 12 bit Microcontoller
 *Inputs : In_data (8 bits), En, W_En, Addr_port(4 bits) and clk
 *
 *Outputs: Out_data (8bits)  
 *
 *Reference:
 *http://www.fpga4student.com/2016/11/verilog-hdl-implementation-of-micro.html
 *****************************************************************************/

 module DMem_tb;

 reg clk, En, W_En;
 reg [7:0] In_data;
 reg [3:0] Addr_port;
 wire [7:0] Out_data;

 DMem uut(
 .clk(clk),
 .Enable(En),
 .Write_en(W_En),
 .Address_port(Addr_port),
 .Input_data(In_data),
 .Output_data(Out_data)
 );

 initial

 clk = 1'b1;
 always #10 clk = ~clk;

 initial begin
	clk = 1'b0;
	En = 1'b0;
	W_En = 1'b0;
	Addr_port = 4'h0;
	In_data = 0;

	#10 En = 1'b1;
	#10 W_En = 1'b1;

	#10 Addr_port = 4'h0; In_data = 8'hAB;
	#10 Addr_port = 4'h1; In_data = 8'h90;
	#10 Addr_port = 4'h5; In_data = 8'hFF;
	#10 Addr_port = 4'h8; In_data = 8'h12;
	#10 Addr_port = 4'hA; In_data = 8'h34;
	#10 Addr_port = 4'hF; In_data = 8'h75;
	#10 Addr_port = 4'hB; In_data = 8'h64;
	#10 Addr_port = 4'h9; In_data = 8'hFE;

	#10 W_En = 1'b0;
	#10 Addr_port = 4'hA;
	#10 Addr_port = 4'h2;
	#10 Addr_port = 4'hF;
	#10 Addr_port = 4'hC;
	#50;
	$finish;
 end
 initial begin
 	$dumpfile("dmem.vcd");
	$dumpvars;
 end
 endmodule