module fetch (clk, PC, icode, ifun, rA, rB, valC, valP, hlt, imem_error, instr_valid);

	input clk;
	input [63:0] PC;
	output reg [ 3:0] icode;
	output reg [ 3:0] ifun;
	output reg [ 3:0] rA;
	output reg [ 3:0] rB;
	output reg [63:0] valC;
	output reg [63:0] valP;
	output reg hlt;
	output reg imem_error;
	output reg instr_valid;

	initial begin
	rA = 4'b1111;
	rB = 4'b1111;
	valC = 64'd0;
	valP = 64'd0;
	hlt = 0;
	imem_error = 0;
	instr_valid = 1;
	end

	reg [7:0] instruction_memory [1023:0];
	initial begin
		// 30 f0 00 00 00 00 00 00 00 00 | irmovq $12, %rax
		instruction_memory[0] = 8'h30;
		instruction_memory[1] = 8'hf0;
		instruction_memory[2] = 8'h0c;
		instruction_memory[3] = 8'h00;
		instruction_memory[4] = 8'h00;
		instruction_memory[5] = 8'h00;
		instruction_memory[6] = 8'h00;
		instruction_memory[7] = 8'h00;
		instruction_memory[8] = 8'h00;
		instruction_memory[9] = 8'h00;

		// // 00 | halt
		// instruction_memory[0] = 8'h00;

		// // ff | INVALID
		// instruction_memory[0] = 8'hff;
	end

	reg [7:0] opcode;
	reg [7:0] regids;

	always @(posedge clk) begin
		if (PC > 1023) begin
			imem_error = 1;
		end

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
			valC = {
			    instruction_memory[PC + 9],
			    instruction_memory[PC + 8],
			    instruction_memory[PC + 7],
			    instruction_memory[PC + 6],
			    instruction_memory[PC + 5],
			    instruction_memory[PC + 4],
			    instruction_memory[PC + 3],
			    instruction_memory[PC + 2]
			};
			valP = PC + 10;
		end

		// rmmovq rA, D(rB)
		else if (icode == 4'b0100) begin
			regids = instruction_memory[PC + 1];
			rA = regids[7:4];
			rB = regids[3:0];
			valC = {
			    instruction_memory[PC + 9],
			    instruction_memory[PC + 8],
			    instruction_memory[PC + 7],
			    instruction_memory[PC + 6],
			    instruction_memory[PC + 5],
			    instruction_memory[PC + 4],
			    instruction_memory[PC + 3],
			    instruction_memory[PC + 2]
			};
			valP = PC + 10;
		end

		// mrmovq D(rB), rA
		else if (icode == 4'b0101) begin
			regids = instruction_memory[PC + 1];
			rA = regids[7:4];
			rB = regids[3:0];
			valC = {
			    instruction_memory[PC + 9],
			    instruction_memory[PC + 8],
			    instruction_memory[PC + 7],
			    instruction_memory[PC + 6],
			    instruction_memory[PC + 5],
			    instruction_memory[PC + 4],
			    instruction_memory[PC + 3],
			    instruction_memory[PC + 2]
			};
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
			valC = {
			    instruction_memory[PC + 8],
			    instruction_memory[PC + 7],
			    instruction_memory[PC + 6],
			    instruction_memory[PC + 5],
			    instruction_memory[PC + 4],
			    instruction_memory[PC + 3],
			    instruction_memory[PC + 2],
			    instruction_memory[PC + 1]
			};
			valP = PC + 9;
		end

		// call Dest
		else if (icode == 4'b1000) begin
			valC = {
			    instruction_memory[PC + 8],
			    instruction_memory[PC + 7],
			    instruction_memory[PC + 6],
			    instruction_memory[PC + 5],
			    instruction_memory[PC + 4],
			    instruction_memory[PC + 3],
			    instruction_memory[PC + 2],
			    instruction_memory[PC + 1]
			};
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