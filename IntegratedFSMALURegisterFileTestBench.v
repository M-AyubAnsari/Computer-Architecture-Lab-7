`timescale 1ns / 1ps
module RF_ALU_FSM_tb;
    reg [3:0] state;
    localparam RESET_STATE = 4'd0,
               WRITE_REG1 = 4'd1,
               WRITE_REG2 = 4'd2,
               WRITE_REG3 = 4'd3,
               ALU_ADD = 4'd4,
               ALU_SUB = 4'd5,
               ALU_AND = 4'd6,
               ALU_OR = 4'd7,
               ALU_XOR = 4'd8,
               ALU_SLL = 4'd9,
               ALU_SRL = 4'd10,
               BRANCH_CHECK = 4'd11,
               WRITE_FLAG = 4'd12,
               CHECK_ZERO = 4'd13,
               READ_AFTER_WRITE = 4'd14;
    reg clk;
    reg rst;
    reg writeEN;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [31:0] writeDT;
    reg [31:0] alu_in1;
    reg [31:0] alu_in2;
    reg [3:0] alu_ctrl;
    
    wire [31:0] readDT1;
    wire [31:0] readDT2;
    wire [31:0] alu_res;
    wire zero_flag;
    
    task_2 uut_rgfile(
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
    
    ALU uut_alu(
        .A(alu_in1),
        .B(alu_in2),
        .ALUControl(alu_ctrl),
        .ALUResult(alu_res),
        .Zero(zero_flag)
        );
    
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        rst = 1;
        state = RESET_STATE;
    end
    always @(posedge clk) begin
        case(state)
            RESET_STATE: begin
                rst <= 0;
                state <= WRITE_REG1;
            end
            WRITE_REG1: begin
                writeEN <= 1;
                rd <= 5'd1;
                writeDT <= 32'h10101010;
                state <= WRITE_REG2;
            end
            WRITE_REG2: begin
                rd <= 5'd2;
                writeDT <= 32'h01010101;
                state <= WRITE_REG3;
            end
            WRITE_REG3 : begin
                rd <= 5'd3;
                writeDT <= 32'h00000005;
                rs1 <= 5'd1;
                rs2 <= 5'd2;
                state <= ALU_ADD;
            end
            ALU_ADD: begin
                writeEN <= 0;
                alu_in1 <= readDT1;
                alu_in2 <= readDT2;
                alu_ctrl <= 4'b0010;
                state <= ALU_SUB;
            end
            ALU_SUB: begin
                writeEN <= 1;
                rd <= 5'd4;
                writeDT <= alu_res;
                if(alu_res == 32'h11111111)begin
                    $display("ADD TEST PASSED");
                end
                
                rs1 <= 5'd1;
                rs2 <= 5'd2;
                alu_in1 <= readDT1;
                alu_in2 <= readDT2;
                alu_ctrl <= 4'b0110;
                state <= ALU_AND;
            end
            ALU_AND: begin
                writeEN <= 1;
                rd <= 5'd5;
                writeDT <= alu_res;
                if(alu_res == 32'h0f0f0f0f )begin
                    $display("SUB TEST PASSED");
                end
                
                rs1 <= 5'd1;
                rs2 <= 5'd2;
                alu_in1 <= readDT1;
                alu_in2 <= readDT2;
                alu_ctrl <= 4'b0000;
                state <= ALU_OR;
            end
            ALU_OR: begin
                writeEN <= 1;
                rd <= 5'd6;
                writeDT <= alu_res;
                if(alu_res == 32'h00000000)begin
                    $display("AND TEST PASSED");
                end
      
                rs1 <= 5'd1;
                rs2 <= 5'd2;
                alu_in1 <= readDT1;
                alu_in2 <= readDT2;
                alu_ctrl <= 4'b0001;
                state <= ALU_XOR;
            end
            ALU_XOR: begin
                writeEN <= 1;
                rd <= 5'd7;
                writeDT <= alu_res;
                if(alu_res == 32'h11111111)begin
                    $display("OR TEST PASSED");
                end
                 
                rs1 <= 5'd1;
                rs2 <= 5'd2;
                alu_in1 <= readDT1;
                alu_in2 <= readDT2;
                alu_ctrl <= 4'b0011;
                state <= ALU_SLL;
            end
            ALU_SLL: begin
                writeEN <= 1;
                rd <= 5'd8;
                writeDT <= alu_res;
                if(alu_res == 32'h11111111)begin
                    $display("XOR TEST PASSED");
                end
                
                rs1 <= 5'd1;
                rs2 <= 5'd2;
                alu_in1 <= readDT1;
                alu_in2 <= readDT2;
                alu_ctrl <= 4'b0100;
                state <= ALU_SRL;
            end
            ALU_SRL: begin
                writeEN <= 1;
                rd <= 5'd9;
                writeDT <= alu_res;
                if(alu_res == 32'h20202020)begin
                    $display("SLL TEST PASSED");
                end
                
                rs1 <= 5'd1;
                rs2 <= 5'd2;
                alu_in1 <= readDT1;
                alu_in2 <= readDT2;
                alu_ctrl <= 4'b0101;
                state <= BRANCH_CHECK;
            end
            BRANCH_CHECK: begin
                writeEN <= 1;
                rd <= 5'hA;
                writeDT <= alu_res;
                if(alu_res == 32'h08080808)begin
                    $display("SRL TEST PASSED");
                end
                
                rs2 <= rs1;
                alu_in1 <= readDT1;
                alu_in2 <= readDT2;
                alu_ctrl <= 4'b0110;
                state <= WRITE_FLAG;
            end
            WRITE_FLAG: begin
                writeEN <= 0;
                if(zero_flag)begin
                    writeEN <= 1;
                    rd <= 5'hB;
                    writeDT <= 32'd1;
                    $display("BRANCH TEST PASSED");
                end
                state <= CHECK_ZERO;
            end
            CHECK_ZERO: begin
                writeEN <= 1;
                rd <= 5'd0;
                writeDT <= 32'hFFFFFFFF;
                rs1 <= 5'd0;
                state <= READ_AFTER_WRITE;
            end
            READ_AFTER_WRITE: begin
                if(readDT1 == 32'h00000000)begin
                    $display("CHECK ZERO TEST PASSED");
                end
                writeEN <= 1;
                rd <= 5'd3;
                writeDT <= 32'hABCDABCD;
                rs1 <= 5'd3;
                state <= READ_AFTER_WRITE;
            end
        endcase 
    end
endmodule
