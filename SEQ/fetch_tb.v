`timescale 1ns / 1ps

module fetch_tb;

	reg clk = 0;
	reg [63:0] PC = 0;
	output [ 3:0] icode;
	output [ 3:0] ifun;
	output [ 3:0] rA;
	output [ 3:0] rB;
	output [63:0] valC;
	output [63:0] valP;
	output hlt;
	output imem_error;
	output instr_valid;

	fetch uut (clk, PC, icode, ifun, rA, rB, valC, valP, hlt, imem_error, instr_valid);

	initial begin
		$dumpfile("fetch_tb.vcd");
		$dumpvars(0, fetch_tb);
	end

	always #10 clk = ~clk; PC = valP;

	always @(posedge clk) begin
		$monitor($time, " icode = %h ifun = %h\nrA = %h rB = %h valC = %h\nvalP = %b\nhlt = %d imem_error = %d instr_valid = %d\n", icode, ifun, rA, rB, valC, valP, hlt, imem_error, instr_valid);
	end
      
endmodule
