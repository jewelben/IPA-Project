// 1-bit AND
module and1bit (
	output out,
	input  in1,
	input  in2
);

	and x1 (out, in1, in2);

endmodule


// 64-bit AND
module and64bit (
	output signed [63:0] out,
	output OF_FLAG,
	input  signed [63:0] in1,
	input  signed [63:0] in2
);

	// Using 1-bit AND gates on all 64 bits of the 2 inputs
	genvar i;
	generate
		for (i = 0; i < 64; i = i + 1) begin
			and1bit x1 (.out (out[i]), .in1 (in1[i]), .in2 (in2[i]));
		end
	endgenerate

	// Overflow Flag is set to 0 for bitwise operations
	assign OF_FLAG = 1'b0;

endmodule