module decode (clk, icode, rA, rB, valA, valB);

	input  clk;
	input  [ 3:0] icode;
	input  [ 3:0] rA;
	input  [ 3:0] rB;
	output [63:0] valA;
	output [63:0] val;

	reg [63:0] register_memory [14:0];
	/* register_memory[0]  -> %rax
	   register_memory[1]  -> %rcx
	   register_memory[2]  -> %rdx
	   register_memory[3]  -> %rbx
	   register_memory[4]  -> %rsp
	   register_memory[5]  -> %rbp
	   register_memory[6]  -> %rsi
	   register_memory[7]  -> %rdi
	   register_memory[8]  -> %r8
	   register_memory[9]  -> %r9
	   register_memory[10] -> %r10
	   register_memory[11] -> %r11
	   register_memory[12] -> %r12
	   register_memory[13] -> %r13
	   register_memory[14] -> %r14 */

	always @(posedge clk) begin
		// halt
		if (icode == 4'b0000) begin
		end

		// nop
		else if (icode == 4'b0001) begin
		end

		// cmovxx rA, rB
		else if (icode == 4'b0010) begin
			valA = register_memory[rA];
		end

		// irmovq V, rB
		else if (icode == 4'b0011) begin
		end

		// rmmovq rA, D(rB)
		else if (icode == 4'b0100) begin
			valA = register_memory[rA];
			valB = register_memory[rB];
		end

		// mrmovq D(rB), rA
		else if (icode == 4'b0101) begin
			valB = register_memory[rB];
		end

		// OPq rA, rB
		else if (icode == 4'b0110) begin
			valA = register_memory[rA];
			valB = register_memory[rB];
		end

		// jXX Dest
		else if (icode == 4'b0111) begin
		end

		// call Dest
		else if (icode == 4'b1000) begin
			valB = register_memory[4];
		end

		// ret
		else if (icode == 4'b1001) begin
			valA = register_memory[4];
			valB = register_memory[4];
		end

		// pushq rA
		else if (icode == 4'b1010) begin
			valA = register_memory[rA];
			valB = register_memory[4];
		end

		// popq rA
		else if (icode == 4'b1011) begin
			valA = register_memory[4];
			valB = register_memory[4];
		end
	end
endmodule