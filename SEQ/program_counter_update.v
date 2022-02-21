module pc_update(
    input clk,
    input reg [63:0] PC,
    input cnd,
    input reg [3:0] icode,
    input reg [63:0] valC,
    input reg [63:0] valM,
    input reg [63:0] valP,
    output reg [63:0] new_pc
);

always@(posedge clk)

    if(icode == 4'b1000)    // call
    begin
        new_pc = valC;
    end
    else if(icode == 4'b0111 && cnd == 1'b1)   // jXX
    begin
        new_pc = valC;
    end
    else if(icode == 4'b1001)   // ret
    begin
        new_pc = valM;
    end
    else
    begin
        new_pc = valP;
    end

end

endmodule