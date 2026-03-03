`timescale 1ns / 1ps
module regfile_tb();
    reg clk;
    reg rst;
    reg writeEN;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] writeDT;
    wire [31:0] readDT1;
    wire [31:0] readDT2;
    
    task_2 uut(
        .clk(clk),
        .rst(rst),
        .writeEN(writeEN),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .writeDT(writeDT),
        .readDT1(readDT1),
        .readDT2(readDT2)
    );
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        rst = 1;
        writeEN = 0;
        rd = 0;
        writeDT = 0;
        rs1 = 0;
        rs2 = 0;
        
        
        #10 rst = 0;
        
        writeEN = 1;
        rd = 5;
        writeDT = 32'hDEADBEEf;
        rs1 = 5;
        
        #10;
        
        rd = 0;
        writeDT = 32'hffffffff;
        rs1 = 0;
        
        #10;
        
        
        rd = 6;
        writeDT = 32'h12345678;
        rs1 = 5;
        rs2 = 6;
        #10
   
        
        rd = 5;
        writeDT = 32'h87654321;
        rs1 = 5;
        #10;
    end  
endmodule
