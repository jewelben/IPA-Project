`timescale 1ns/1ps

module memory(
    clk,
    icode,
    valA,
    valB,
    valE,
    valP,
    valM
)

output reg [63:0] valM;
reg [63:0] main_memory[1023:0];

always@(posedge clk)
begin

    if(icode == 4b'0100)   // rmmovq
    begin
        main_memory[valE] = valA;
    end
    else if(icode == 4b'0101)   // mrmovq
    begin
        valM = main_memory[valE];
    end
    
end

endmodule