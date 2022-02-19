module xortest;

	reg    signed [63:0] in1;
	reg    signed [63:0] in2;
	output signed [63:0] out;
	output OF_FLAG;

	xor64bit uut (
		.out     (out),
		.OF_FLAG (OF_FLAG),
		.in1     (in1),
		.in2     (in2)
	);

	initial begin
		$dumpfile("xortest.vcd");
		$dumpvars(0, xortest);

		$monitor($time, " in1 = %b\n\t\t     in2 = %b\n\t\t     out = %b\n\t\t     OF_FLAG = %d\n", in1, in2, out, OF_FLAG);

		in1 = 64'b0; in2 = 64'b0;
		#20 in1 =  64'b100110; in2 =  64'b110001;
		#20 in1 =  64'b001110; in2 =  64'b101000;
		#20 in1 = -64'b101101; in2 =  64'b010101;
		#20 in1 = -64'b100001; in2 = -64'b100010;
		#20 in1 =  64'b101111; in2 =  64'b111001;

		$finish;
	end

endmodule