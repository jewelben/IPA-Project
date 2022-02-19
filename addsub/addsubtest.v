module addsubtest;

	reg signed [63:0] in1;
	reg signed [63:0] in2;
	reg op;
	output signed [63:0] out;
	output OF_FLAG;

	addsub64bit uut (
		.out     (out),
		.OF_FLAG (OF_FLAG),
		.in1     (in1),
		.in2     (in2),
		.op      (op)
	);

	initial begin
		$dumpfile("addsubtest.vcd");
		$dumpvars(0, addsubtest);

		$monitor($time, " op = %d, in1 = %d, in2 = %d, out = %d, OF_FLAG = %d", op, in1, in2, out, OF_FLAG);

		op = 2'b00; in1 = 64'b0; in2 = 64'b0;
		#20 op = 2'b00; in1 =  64'b101101; in2 =  64'b100110;
		#20 op = 2'b00; in1 = -64'b101101; in2 =  64'b100110;
		#20 op = 2'b00; in1 =  64'b101101; in2 = -64'b100110;
		#20 op = 2'b00; in1 = -64'b101101; in2 = -64'b100110;
		#20 op = 2'b01; in1 =  64'b101101; in2 =  64'b100110;
		#20 op = 2'b01; in1 = -64'b101101; in2 =  64'b100110;
		#20 op = 2'b01; in1 =  64'b101101; in2 = -64'b100110;
		#20 op = 2'b01; in1 = -64'b101101; in2 = -64'b100110;
		#20 op = 2'b00; in1 =  64'd9223372036854775807; in2 =  64'd1;
		#20 op = 2'b01; in1 =  64'd9223372036854775807; in2 = -64'd1;
		#20 op = 2'b00; in1 = -64'd9223372036854775808; in2 = -64'd1;
		#20 op = 2'b01; in1 = -64'd9223372036854775808; in2 =  64'd1;

		$finish;
	end

endmodule