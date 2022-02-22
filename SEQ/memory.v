`timescale 1ns/1ps

module memory(
    input clk,
    input [3:0] icode,
    input [63:0] valA,
    input [63:0] valB,
    input [63:0] valE,
    input [63:0] valP,
    output dmem_error,
    output reg [63:0] valM
);

reg [63:0] mem[0:2047]; // Might have to change variable name...
reg mem_read;
reg mem_write;
reg [63:0] mem_data;
reg [63:0] mem_addr;


// where to assgin value to dmem_error???

// Hardcoding values in main memory for testing
initial begin
    mem[0] = 64'd0;
    mem[1] = 64'd1;
    mem[2] = 64'd2;
    mem[3] = 64'd3;
    mem[4] = 64'd4;
    mem[5] = 64'd5;
    mem[6] = 64'd6;
    mem[7] = 64'd7;
    mem[8] = 64'd8;
    mem[9] = 64'd9;
    mem[10] = 64'd10;
    mem[11] = 64'd11;
    mem[12] = 64'd12;
    mem[13] = 64'd13;
    mem[14] = 64'd14;
    mem[15] = 64'd15;
end

always@(posedge clk)
begin
    if (icode == 4'b0100 || icode == 4'b1010)   // rmmovq or pushq
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
    else if (icode == 4'b0101 || icode == 4'b1011)  // mrmovq or popq
    begin
        mem_write = 0;
        mem_read = 1;
        mem_addr = valE;
    end
    else if (icode == 4'b1001)  // ret
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

end

endmodule