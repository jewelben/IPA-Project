`include "ALU/alu.v"

module cond (ifun, CC, Cnd);

	input [3:0] ifun;
	input [2:0] CC;
	output Cnd;

	parameter J_UNC = 4'h0; // Unconditional jump
	parameter J_LE  = 4'h1; // Jump if less than or equal
	parameter J_L   = 4'h2; // Jump if less than
	parameter J_E   = 4'h3;	// Jump if equal
	parameter J_NE  = 4'h4;	// Jump if not equal
	parameter J_GE  = 4'h5; // Jump if greater than or equal
	parameter J_G   = 4'h6; // Jump if greater than

	wire ZF = CC[2];
	wire SF = CC[1];
	wire OF = CC[0];
	
	assign Cnd =
	(ifun == J_UNC) |
	(ifun == J_LE & ((ZF ^ OF) | ZF)) |
	(ifun == J_L  & (SF ^ OF)) |
	(ifun == J_E  & ZF) |
	(ifun == J_NE & ~ZF) |
	(ifun == J_GE & (~SF ^ OF)) |
	(ifun == J_G  & (~SF ^ OF) & ~ZF);

endmodule

module execute (clk, icode, ifun, valA, valB, valC, valE, Cnd);

	input  clk;
	input  [ 3:0] icode;
	input  [ 3:0] ifun;
	input  [63:0] valA;
	input  [63:0] valB;
	input  [63:0] valC;
	output [63:0] valE;
	output Cnd;

	reg [2:0] CC;

	always @(posedge clk) begin
		// cmovxx rA, rB
		else if (icode == 4'b0010) begin
			ALUA = valA;
			ALUB = 0;
			ALUfun = 2'b00;
		end

		// irmovq V, rB
		else if (icode == 4'b0011) begin
			ALUA = valC;
			ALUB = 0;
			ALUfun = 2'b00;
		end

		// rmmovq rA, D(rB)
		else if (icode == 4'b0100) begin
			ALUA = valC;
			ALUB = valB;
			ALUfun = 2'b00;
		end

		// mrmovq D(rB), rA
		else if (icode == 4'b0101) begin
			ALUA = valC;
			ALUB = valB;
			ALUfun = 2'b00;
		end

		// OPq rA, rB
		else if (icode == 4'b0110) begin
			ALUA = valA;
			ALUB = valB;
			if (ifun == 4'b0000) begin
				ALUfun = 2'b00;
			end
			else if (ifun == 4'b0001) begin
				ALUfun = 2'b01;
			end
			else if (ifun == 4'b0010) begin
				ALUfun = 2'b10;
			end
			else if (ifun == 4'b0011) begin
				ALUfun = 2'b11;
			end
		end

		// call Dest
		else if (icode == 4'b1000) begin
			ALUA = -8;
			ALUB = valB;
			ALUfun = 2'b00;
		end

		// ret
		else if (icode == 4'b1001) begin
			ALUA = 8;
			ALUB = valB;
			ALUfun = 2'b00;
		end

		// pushq rA
		else if (icode == 4'b1010) begin
			ALUA = -8;
			ALUB = valB;
			ALUfun = 2'b00;
		end

		// popq rA
		else if (icode == 4'b1011) begin
			ALUA = 8;
			ALUB = valB;
			ALUfun = 2'b00;
		end

		alu alu0 (ALUA, ALUB, ALUfun, valE, CC);
		cond cond0 (ifun, CC, Cnd);
	end

endmodule