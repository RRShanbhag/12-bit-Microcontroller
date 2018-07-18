CC=iverilog
CFLAGS=-I

all:
	@$(CC) -Wall -o out/alu.out ALU.v ALU_tb.v
	@$(CC) -Wall -o out/dmem.out DMem.v DMem_tb.v
	@$(CC) -Wall -o out/Adder.out Adder.v
	@$(CC) -Wall -o out/MUX1.out MUX1.v
	@$(CC) -Wall -o out/PMem.out PMem.v
	@$(CC) -Wall -o out/CtrlLogic.out Control_Logic.v
	@$(CC) -Wall -o out/mcu.out MCU.v ALU.v MUX1.v DMem.v PMem.v Adder.v Control_Logic.v MCU_tb.v
	@echo "Built Module"
	@+$(MAKE) -C ./vcd
	@echo "Generated VCD file"
clean:
	@rm -r ./out/*.out
	@rm -r ./vcd/*.vcd
	