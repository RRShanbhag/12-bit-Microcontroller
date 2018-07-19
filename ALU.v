/*****************************************************************************
 *
 *ALU module for 12 bit Microcontoller
 *Inputs : Operand1 (8 bits), Operand2 (8bits), Enable, Mode(4 bits), 
 *		   CurrentFlags (4 bits)
 *Outputs: Result (8 bits), Flags(4 bits)  
 *
 *Reference:
 *http://www.fpga4student.com/2016/11/verilog-hdl-implementation-of-micro.html
 *****************************************************************************/

module ALU(
 	input Enable,
 	input  [7:0] Operand1,
 	input  [7:0] Operand2,
 	input  [3:0] Mode,
 	input  [3:0] Cflags,
 	output [7:0] Result,
 	output [3:0] Flags
 	);

 	reg  [7:0] Result;				// Store the final result
 	reg  Carry;						// Store the carry for the next bit operation
 	reg [3:0] Flags;

 	always@(*) begin				// For every change in the inputs
 	if (Enable == 0) begin
 		Result = 0;
 		Flags = 0;
 	end

 	else begin

		case(Mode)

			//Addition M-Type
			4'b0000: 
			begin
				{Carry, Result} = Operand1 + Operand2;
				if((Operand1[7] == Operand2[7]) && (Result[7] == Operand1[7])) 
				begin
					Flags[0] = 1'b1;
				end
				else 
				begin
					Flags[0] = 1'b0;
				end
				Flags[1] = Result[7];

				if (Result == 0)
					Flags[3] = 1'b0;
				Flags[2] = Carry;
			end
			
			//Subtraction M-Type
			4'b0001: 
			begin
				{Carry, Result} = Operand1 - Operand2;

				if((Operand1[7] == Operand2[7]) && (Result[7] != Operand1[7])) 
					Flags[0] = 1'b1;
				else
					Flags[0] = 1'b0;

				Flags[1] = Result[7];
				Flags[2] = Carry;
				if (Result == 0)
					Flags[3] = 1'b0;
			end

			//Move Acc to Mem
			4'b0010: Result = Operand1;

			//Move Mem to Acc
	  		4'b0011: Result = Operand2;
			
	  		//AND M-Type
			4'b0100: 
			begin
				Result = Operand1 & Operand2;
				if (Result == 0)
					Flags[3] = 1'b0;
			end
			//OR M-Type
			4'b0101: 
			begin
				Result = Operand1 | Operand2;
				if (Result == 0)
					Flags[3] = 1'b0;
			end

			//XOR M-Type
			4'b0110: 
			begin
				Result = Operand1 ^ Operand2;
				if (Result == 0)
					Flags[3] = 1'b0;
			end

			//Sutraction Mem to Acc 
			4'b0111:
			begin
				{Carry, Result} = Operand2 - Operand1;

				if((Operand1[7] == Operand2[7]) && (Result[7] != Operand1[7])) 
					Flags[0] = 1'b1;
				else
					Flags[0] = 1'b0;

				Flags[1] = Result[7];
				if (Result == 0)
					Flags[3] = 1'b0;
			end

			//Increment by 1
			4'b1000:
			begin
				{Carry, Result} = Operand1 + 8'h1;
				if(Result[7] == Operand1[7]) 
					Flags[0] = 1'b1;
				else
					Flags[0] = 1'b0;

				Flags[1] = Result[7];

				if (Result == 0)
					Flags[3] = 1'b0;
				Flags[2] = Carry;
			end

			//Decrement by 1
			4'b1001:
			begin
				{Carry, Result} = Operand1 - 8'h1;
				if(Result[7] == Operand1[7]) 
					Flags[0] = 1'b1;
				else
					Flags[0] = 1'b0;

				Flags[1] = Result[7];
				Flags[2] = Carry;

				if (Result == 0)
					Flags[3] = 1'b0;
			end

			//Rotate Left
			4'b1010: Result=(Operand2 << Operand1[2:0])|(Operand2>>Operand1[2:0]);
			
			//Rotate Right
			4'b1011: Result=(Operand2 >> Operand1[2:0])|(Operand2<<Operand1[2:0]);
			
			//Shift Left Logical
			4'b1100: Result = Operand2 << Operand1[2:0];
	  	
		  	//Shift Right Logical
		  	4'b1101: Result = Operand2 >> Operand1[2:0];
			
			//Shift Right Arithmatic
			4'b1110: Result = Operand2 >>> Operand1[2:0];

			//Complement
			4'b1111:
			begin
				{Carry, Result} = 8'h0 - Operand1;
				if(Result[7] == Operand1[7]) 
					Flags[0] = 1'b1;
				else
					Flags[0] = 1'b0;

				Flags[1] = Result[7];
				Flags[2] = Carry;

				if (Result == 0)
					Flags[3] = 1'b0;
			end
			default: Result = Operand2;
		endcase
	end
end
endmodule