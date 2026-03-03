`timescale 1ns / 1ps
module task_2(
    input clk,
    input rst,
    input writeEN,
    input [4:0]rs1,
    input [4:0]rs2,
    input [4:0]rd,
    input [31:0]writeDT,
    output [31:0]readDT1,
    output [31:0]readDT2 
    );
    reg [31:0] registers[0:31];
    assign readDT1 = registers[rs1];
    assign readDT2 = registers[rs2];
    integer i;
    always @(posedge clk)begin
        if(rst) begin
             for(i=0; i < 32; i = i + 1)begin
                registers[i] <= 0;
            end 
        end
        else if(writeEN != 0 && rd != 0)begin
            registers[rd] <= writeDT;
        end
    end;
endmodule
