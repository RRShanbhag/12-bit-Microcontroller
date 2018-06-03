CC=iverilog
CFLAGS=-I

all:
	@$(CC) -Wall -o out/alu.out ALU.v ALU_tb.v
	@$(CC) -Wall -o out/dmem.out DMem.v DMem_tb.v
	@echo "Built Module"
	@+$(MAKE) -C ./vcd
	@echo "Generated VCD file"
clean:
	@rm -r ./out/*.out
	@rm -r ./vcd/*.vcd
	