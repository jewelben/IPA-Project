	module decode(clk, icode, rA, rB, valA, valB);

	input             clk;
	input      [ 3:0] icode;
	input      [ 3:0] rA;
	input      [ 3:0] rB;
	output reg [63:0] valA;
	output reg [63:0] valB;

	reg [63:0] register_file[0:14];
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

	// For testing purposes, hardcoding the values stored in the registers
	initial begin
		register_file[0] = 64'd0;
		register_file[1] = 64'd1;
		register_file[2] = 64'd2;
		register_file[3] = 64'd3;
		register_file[4] = 64'd4;
		register_file[5] = 64'd5;
		register_file[6] = 64'd7;
		register_file[7] = 64'd7;
		register_file[8] = 64'd8;
		register_file[9] = 64'd9;
		register_file[10] = 64'd10;
		register_file[11] = 64'd11;
		register_file[12] = 64'd12;
		register_file[13] = 64'd13;
		register_file[14] = 64'd14;
	end

	always @(posedge clk) begin
		// cmovxx rA, rB
		if (icode == 4'b0010) begin
			valA = register_file[rA];
		end

		// irmovq V, rB
		else if(icode == 4'b0011) begin
			valB = register_file[rB];
		end

		// rmmovq rA, D(rB)
		else if(icode == 4'b0100) begin
			valA = register_file[rA];
			valB = register_file[rB];
		end

		// mrmovq D(rB), rA
		else if(icode == 4'b0101) begin
			valB = register_file[rB];
		end

		// OPq rA, rB
		else if(icode == 4'b0110) begin
			valA = register_file[rA];
			valB = register_file[rB];
		end

		// call Dest
		else if(icode == 4'b1000) begin
			valB = register_file[4];
		end

		// ret
		else if(icode == 4'b1001) begin
			valA = register_file[4];
			valB = register_file[4];
		end

		// pushq rA, rB
		else if(icode == 4'b1010) begin
			valA = register_file[rA];
			valB = register_file[4];
		end

		// popq rA, rB
		else if(icode == 4'b1011) begin
			valA = register_file[4];
			valB = register_file[4];
		end
	end

endmodule