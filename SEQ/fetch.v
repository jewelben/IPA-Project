`timescale 1ns/1ps

module fetch(
    clk,
    icode,
    ifun,
    rA,
    rB,
    PC,
    valC,
    valP,
    status_condition
);

input clk;
input [63:0] PC; // Assuming PC can take values 0 to 1023
output reg [3:0] icode;
output reg [3:0] ifun;
output reg [3:0] rA;
output reg[3:0] rB;
output reg [63:0] valC;
output reg [63:0] valP;
output reg [2:0] status_condition;

/* 
    status_condition is,
        AOK => Normal operation => 001
        HLT => Halt instruction encountered => 010
        ADR => Bad address encountered => 011
        INS => Invalid instruction encountered => 100

    If AOK, keep going, otherwise stop program execution
*/

reg OPCODE [7:0];    // 1-10 bytes of instruction
reg [7:0] instruction_memory [1023:0];
reg [79:0] instruction; // 1-10 byte long instructions
always@(posedge clk)
begin

    if (PC > 2047 || PC < 0) // Bad instruction memory address, ADR
    begin
        status_condition = 3'b011;
    end

    /* 

        ***********************************************************************
        ***********Hardcode instructions here, in instruction memory***********
        ***********************************************************************

    */

    OPCODE = instruction_memory[PC];

    icode = OPCODE[0:3];
    ifun = OPCODE[4:7];
    // OPCODE = icode ifun
always@(posedge clk)
begin
    if (icode == 4'b0000)   // halt
    begin
        instruction = instruction_memory[PC];   // Instruction length is 1 byte
        valP = PC + 64'd1;
        status_condition = 3'b010;  // Halt instruction encountered, HLT
    end
    else if(icode == 4'b0001)   // nop
    begin
        instruction = instruction_memory[PC];   // Instruction length is 1 byte
        valP = PC + 64'd1;
    end
    else if(icode == 4'b0010)   //cmovxx
    begin
        instruction = instruction_memory[PC:PC+1];   // Instruction length is 2 bytes
        rA = instruction[8:11];
        rB = instruction[12:15];
        valP = PC + 64'd2;
    end
    else if(icode == 4'b0011)   //irmovq
    begin
        instruction = instruction_memory[PC:PC+9];  // Instruction length is 10 bytes
        rA = instruction[8:11];
        rB = instruction[12:15];
        valC = instruction[16:79];
        valP = PC + 64d'10;
    end
    else if(icode == 4b'0100)   //rmmovq
    begin
        instruction = instruction_memory[PC:PC+9];  // Instruction length is 10 bytes
        rA = instruction[8:11];
        rB = instruction[12:15];
        valC = instruction[16:79];
        valP = PC + 64d'10;
    end
    else if(icode == 4b'0101)   //  mrmovq
    begin
        instruction = instruction_memory[PC:PC+9];  // Instruction length is 10 bytes
        rA = instruction[8:11];
        rB = instruction[12:15];
        valC = instruction[16:79];
        valP = PC + 64d'10;
    end
    else if(icode == 4b'0110)   // OPq
    begin
        instruction = instruction_memory[PC:PC+1];   // Instruction length is 2 bytes
        rA = instruction[8:11];
        rB = instruction[12:15];
        valP = PC + 64'd2;
    end
    else if(icode == 4b'0111)   // jXX
    begin
        instruction = instruction_memory[PC:PC+9];  // Instruction length is 9 bytes
        valC = instruction[8:71];
        valP = PC + 64d'9;    
    end
    else if(icode == 4b'1000)   // call
    begin
        instruction = instruction_memory[PC:PC+9];  // Instruction length is 9 bytes
        valC = instruction[8:71];
        valP = PC + 64d'9;        
    end
    else if(icode == 4b'1001)   // ret
    begin
        instruction = instruction_memory[PC];   // Instruction length is 1 byte
        valP = PC + 64'd1;
    end
    else if(icode == 4b'1010)   // pushq
    begin
        instruction = instruction_memory[PC:PC+1];   // Instruction length is 2 bytes
        rA = instruction[8:11];
        rB = instruction[12:15];
        valP = PC + 64'd2;
    end
    else if(icode == 4b'1011)   // popq
    begin
        instruction = instruction_memory[PC:PC+1];   // Instruction length is 2 bytes
        rA = instruction[8:11];
        rB = instruction[12:15];
        valP = PC + 64'd2;
    end
    else    // invalid icode or OPCODE
    begin
        status_condition = 3b'100;  // Invalid instruction encountered, INS
    end
end


endmodule



