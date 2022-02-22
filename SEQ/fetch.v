module fetch (clk, PC, icode, ifun, rA, rB, valC, valP, hlt, imem_error, instr_valid);

	input  clk;
	input  [63:0] PC;
	output [ 3:0] icode;
	output [ 3:0] ifun;
	output [ 3:0] rA;
	output [ 3:0] rB;
	output [63:0] valC;
	output [63:0] valP;
	output hlt;
	output imem_error;
	output instr_valid;

	reg [7:0] instruction_memory [1023:0];

	assign rA = 4'b1111;
	assign rB = 4'b1111;
	assign valC = 64'd0;

	always @(posedge clk) begin
		if (PC > 1023) begin
			imem_error = 1;
		end

		reg [7:0] opcode;
		reg [7:0] regids;

		opcode = instruction_memory[PC];
		icode = opcode[7:4];
		ifun = opcode[3:0];

		// halt
		if (icode == 4'b0000) begin
			hlt = 1;
			valP = PC + 1;
		end

		// nop
		else if (icode == 4'b0001) begin
			valP = PC + 1;
		end

		// cmovxx rA, rB
		else if (icode == 4'b0010) begin
			regids = instruction_memory[PC + 1];
			rA = regids[7:4];
			rB = regids[3:0];
			valP = PC + 2;
		end

		// irmovq V, rB
		else if (icode == 4'b0011) begin
			regids = instruction_memory[PC + 1];
			rA = regids[7:4];
			rB = regids[3:0];
			valC = instruction_memory[PC + 2:PC + 9];
			valP = PC + 10;
		end

		// rmmovq rA, D(rB)
		else if (icode == 4'b0100) begin
			regids = instruction_memory[PC + 1];
			rA = regids[7:4];
			rB = regids[3:0];
			valC = instruction_memory[PC + 2:PC + 9];
			valP = PC + 10;
		end

		// mrmovq D(rB), rA
		else if (icode == 4'b0101) begin
			regids = instruction_memory[PC + 1];
			rA = regids[7:4];
			rB = regids[3:0];
			valC = instruction_memory[PC + 2:PC + 9];
			valP = PC + 10;
		end

		// OPq rA, rB
		else if (icode == 4'b0110) begin
			regids = instruction_memory[PC + 1];
			rA = regids[7:4];
			rB = regids[3:0];
			valP = PC + 2;
		end

		// jXX Dest
		else if (icode == 4'b0111) begin
			valC = instruction_memory[PC + 1:PC + 8];
			valP = PC + 9;
		end

		// call Dest
		else if (icode == 4'b1000) begin
			valC = instruction_memory[PC + 1:PC + 8];
			valP = PC + 9;		
		end

		// ret
		else if (icode == 4'b1001) begin
			valP = PC + 1;
		end

		// pushq rA
		else if (icode == 4'b1010) begin
			regids = instruction_memory[PC + 1];
			rA = regids[7:4];
			rB = regids[3:0];
			valP = PC + 2;
		end

		// popq rA
		else if (icode == 4'b1011) begin
			regids = instruction_memory[PC + 1];
			rA = regids[7:4];
			rB = regids[3:0];
			valP = PC + 2;
		end

		// Invalid instruction encountered
		else begin
			instr_valid = 0;
		end
	end

endmodule