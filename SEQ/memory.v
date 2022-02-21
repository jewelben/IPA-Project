`timescale 1ns/1ps

module memory(
    input clk,
    input reg [3:0] icode,
    input reg [63:0] valA,
    input reg [63:0] valB,
    input reg [63:0] valE,
    input reg [63:0] valP,
    output dmem_error,
    output reg [63:0] valM
);

reg [63:0] mem[2047:0]; // Might have to change variable name...
wire mem_read;
wire mem_write;
reg [63:0] mem_data;
reg [63:0] mem_addr;


// where to assgin value to dmem_error???

always@(posedge clk)
begin
    if (icode == 4b'0100 || icode == 4'b1010)   // rmmovq or pushq
    begin
        mem_write = 1;
        mem_read = 0;
        mem_data = valA;
        mem_addr = valE;
    end
    else if (icode == 4'b1000)  // call
    begin
        mem_write = 1;
        mem_read = 0;
        mem_data = valP;
        mem_addr = valE;
    end
    else if (icode == 4b'0101 || icode == 4b'1011)  // mrmovq or popq
    begin
        mem_write = 0;
        mem_read = 1;
        mem_addr = valE;
    end
    else if (icode == 4b'1001)  // ret
    begin
        mem_write = 0;
        mem_read = 1;
        mem_addr = valA;
    end

    if (mem_write && !mem_read)
    begin
        mem[mem_addr] = mem_data;
    end
    else if (!mem_write && mem_read)
    begin
        valM = mem[mem_addr];
    end

endmodule