// Full Adder
module fulladder (
	output sum,
	output cout,
	input  in1,
	input  in2,
	input  cin
);

	wire w1, w2, w3;

	xor x1 (w1, in1, in2);	
	and x2 (w2, in1, in2);	
	xor x3 (sum, cin, w1);
	and x4 (w3, cin, w1);	
	or  x5 (cout, w2, w3);

endmodule


// 64-bit Adder-Subtractor
// op = 0 : add, op = 1 : sub
module addsub64bit (
	output signed [63:0] out,
	output OF_FLAG,
	input  signed [63:0] in1,
	input  signed [63:0] in2,
	input  op
);

	wire [63:0] nin2;
	wire [64:0] carry;
	assign carry[0] = op;

	// Generate nin2 which is in2 if op = 0 and ~in2 if op = 1
	genvar i;
	generate
		for (i = 0; i < 64; i = i + 1) begin
			xor x1 (nin2[i], in2[i], op);
		end
	endgenerate

	// Ripple Adder : Add in1 and nin2
	genvar j;
	generate
		for (j = 0; j < 64; j = j + 1) begin
			fulladder x2 (.sum (out[j]), .cout (carry[j + 1]), .in1 (in1[j]), .in2 (nin2[j]), .cin (carry[j]));
		end
	endgenerate

	// Calculate Overflow Flag
	xor x3 (OF_FLAG, carry[64], carry[63]);

endmodule