`timescale 1ns / 1ps

module write_back(
    input clk,
    input [3:0] icode,
    input [3:0] rA,
    input [3:0] rB,
    input [63:0] valA,
    input [63:0] valB,
    input [63:0] valE,
    input [63:0] valM,
    output reg [63:0] dstE, // output for testing purposes
    output reg [63:0] dstM // output for testing purposes
);

reg [63:0] register_memory[0:14];

always@(posedge clk)
begin

    if(icode == 4'b0010 || icode == 4'b0011 || icode == 4'b0110)  // cmovxx or irmovq or OPq
    begin
        dstE = rB;
        register_memory[dstE] = valE;
    end
    if(icode == 4'b1000 || icode == 4'b1001 || icode == 4'b1010 || icode == 4'b1011) // call or ret or pushq or popq
    begin
        dstE = 64'd4;   // %rsp
        register_memory[dstE] = valE;
    end
    if(icode == 4'b0101 || icode == 4'b1011)    // mrmovq or popq
    begin
        dstM = rA;
        register_memory[dstM] = valM;
    end
    if(icode==4'b1011) //popq
    begin
        register_memory[4] = valE;
        register_memory[rA] = valM;
    end

end
endmodule