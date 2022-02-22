`timescale 1ns/1ps

module decode(
    clk,
    icode,
    rA,
    rB,
    valA,
    valB,
);

input clk;
input [3:0] icode;
input [3:0] rA;
input [3:0] rB;
output reg [63:0] valA;
output reg [63:0] valB;
reg [63:0] register_memory[0:14];

/*

    register_memory[0] is %rax
    register_memory[1] is %rcx
    register_memory[2] is %rdx
    register_memory[3] is %rbx
    register_memory[4] is %rsp
    register_memory[5] is %rbp
    register_memory[6] is %rsi
    register_memory[7] is %rdi
    register_memory[8] is %r8
    register_memory[9] is %r9
    register_memory[10] is %r10
    register_memory[11] is %r11
    register_memory[12] is %r12
    register_memory[13] is %r13
    register_memory[14] is %r14

*/

// For testing purposes, hardcoding the values stored in the registers
initial begin
    register_memory[0] = 64'd0;
    register_memory[1] = 64'd1;
    register_memory[2] = 64'd2;
    register_memory[3] = 64'd3;
    register_memory[4] = 64'd4;
    register_memory[5] = 64'd5;
    register_memory[6] = 64'd7;
    register_memory[7] = 64'd7;
    register_memory[8] = 64'd8;
    register_memory[9] = 64'd9;
    register_memory[10] = 64'd10;
    register_memory[11] = 64'd11;
    register_memory[12] = 64'd12;
    register_memory[13] = 64'd13;
    register_memory[14] = 64'd14;
end

always@(posedge clk)
begin

    if (icode == 4'b0010)   // cmovXX
    begin
        valA = register_memory[rA];
    end
    else if(icode == 4'b0011)   // irmovq
    begin
        valB = register_memory[rB];
    end
    else if(icode == 4'b0100)   // rmmovq
    begin
        valA = register_memory[rA];
        valB = register_memory[rB];
    end
    else if(icode == 4'b0101)   // mrmovq
    begin
        valB = register_memory[rB];
    end 
    else if(icode == 4'b0110)   // OPq
    begin
        valA = register_memory[rA];
        valB = register_memory[rB];
    end
    else if(icode == 4'b1000)   // call
    begin
        valB = register_memory[4];
    end
    else if(icode == 4'b1001)   // ret
    begin
        valA = register_memory[4];
        valB = register_memory[4];
    end 
    else if(icode == 4'b1010)   // pushq
    begin
        valA = register_memory[rA];
        valB = register_memory[4];
    end
    else if(icode == 4'b1011)   // popq
    begin
        valA = register_memory[4];
        valB = register_memory[4];
    end    

end

endmodule