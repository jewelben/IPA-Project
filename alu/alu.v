`include "../addsub/addsubfunc.v"
`include "../and/andfunc.v"
`include "../xor/xorfunc.v"


// 1-bit 4x1 MUX
module mux4x11bit (
	output out,
	input  in0,
	input  in1,
	input  in2,
	input  in3,
	input  [1:0] sel
);

	wire [1:0] nsel;
	wire temp0, temp1, temp2, temp3;

	not x1 (nsel[0], sel[0]);
	not x2 (nsel[1], sel[1]);
	and x3 (temp0, in0, nsel[1], nsel[0]);
	and x4 (temp1, in1, nsel[1],  sel[0]);
	and x5 (temp2, in2,  sel[1], nsel[0]);
	and x6 (temp3, in3,  sel[1],  sel[0]);
	or  x7 (out, temp0, temp1, temp2, temp3);

endmodule


// 64-bit 4x1 MUX
module mux4x164bit (
	output signed [63:0] out,
	input  signed [63:0] in0,
	input  signed [63:0] in1,
	input  signed [63:0] in2,
	input  signed [63:0] in3,
	input  [1:0] sel
);

	wire [1:0] nsel;
	wire signed [63:0] temp0, temp1, temp2, temp3;

	// Using a 4x1 MUX on all 64 bits of the inputs
	genvar i;
	generate
		for (i = 0; i < 64; i = i + 1) begin
			mux4x11bit x1 (.out (out[i]), .in0 (in0[i]), .in1 (in1[i]), .in2 (in2[i]), .in3 (in3[i]), .sel (sel));
		end
	endgenerate

endmodule


// 64-bit ALU
module alu (
	output signed [63:0] out,
	output OF_FLAG,
	input [1:0] OPCODE,
	input signed [63:0] in1,
	input signed [63:0] in2
);

	wire signed [63:0] out0, out1, out2, out3;
	wire OF_FLAG0, OF_FLAG1, OF_FLAG2, OF_FLAG3;

	// ALU calculates the results of all the operations
	addsub64bit control0 (.out (out0), .OF_FLAG (OF_FLAG0), .in1 (in1), .in2 (in2), .op (1'b0));
	addsub64bit control1 (.out (out1), .OF_FLAG (OF_FLAG1), .in1 (in1), .in2 (in2), .op (1'b1));
	and64bit    control2 (.out (out2), .OF_FLAG (OF_FLAG2), .in1 (in1), .in2 (in2));
	xor64bit    control3 (.out (out3), .OF_FLAG (OF_FLAG3), .in1 (in1), .in2 (in2));

	// Selects the output of the ALU depending on OPCODE using MUXes
	mux4x164bit selectoutput  (.out (out)    , .in0 (out0)    , .in1 (out1)    , .in2 (out2)    , .in3 (out3)    , .sel (OPCODE));
	mux4x11bit  selectOF_FLAG (.out (OF_FLAG), .in0 (OF_FLAG0), .in1 (OF_FLAG1), .in2 (OF_FLAG2), .in3 (OF_FLAG3), .sel (OPCODE));

endmodule
