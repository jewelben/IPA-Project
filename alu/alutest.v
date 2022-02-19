module alutest;

	reg [1:0] OPCODE;
	reg signed [63:0] in1;
	reg signed [63:0] in2;
	output signed [63:0] out;
	output OF_FLAG;

	alu uut (
		.out     (out),
		.OF_FLAG (OF_FLAG),
		.OPCODE  (OPCODE),
		.in1     (in1),
		.in2     (in2)
	);

	initial begin
		$dumpfile("alutest.vcd");
		$dumpvars(0, alutest);

		$monitor($time, " OPCODE = %b\n\t\t     in1 = %b\n\t\t     in2 = %b\n\t\t     out = %b\n\t\t     OF_FLAG = %d\n", OPCODE, in1, in2, out, OF_FLAG);

		OPCODE = 2'b00; in1 = 64'b0; in2 = 64'b0;
		#20 OPCODE = 2'b00; in1 =  64'b101101; in2 =  64'b100110;
		#20 OPCODE = 2'b01; in1 =  64'b101101; in2 =  64'b100110;
		#20 OPCODE = 2'b10; in1 =  64'b101101; in2 =  64'b100110;
		#20 OPCODE = 2'b11; in1 =  64'b101101; in2 =  64'b100110;
		#20 OPCODE = 2'b00; in1 = -64'b101101; in2 =  64'b100110;
		#20 OPCODE = 2'b01; in1 = -64'b101101; in2 =  64'b100110;
		#20 OPCODE = 2'b10; in1 = -64'b101101; in2 =  64'b100110;
		#20 OPCODE = 2'b11; in1 = -64'b101101; in2 =  64'b100110;
		#20 OPCODE = 2'b00; in1 =  64'b101101; in2 = -64'b100110;
		#20 OPCODE = 2'b01; in1 =  64'b101101; in2 = -64'b100110;
		#20 OPCODE = 2'b10; in1 =  64'b101101; in2 = -64'b100110;
		#20 OPCODE = 2'b11; in1 =  64'b101101; in2 = -64'b100110;
		#20 OPCODE = 2'b00; in1 = -64'b101101; in2 = -64'b100110;
		#20 OPCODE = 2'b01; in1 = -64'b101101; in2 = -64'b100110;
		#20 OPCODE = 2'b10; in1 = -64'b101101; in2 = -64'b100110;
		#20 OPCODE = 2'b11; in1 = -64'b101101; in2 = -64'b100110;
		#20 OPCODE = 2'b00; in1 =  64'd9223372036854775807; in2 =  64'd1;
		#20 OPCODE = 2'b01; in1 =  64'd9223372036854775807; in2 = -64'd1;

		$finish;
	end

endmodule