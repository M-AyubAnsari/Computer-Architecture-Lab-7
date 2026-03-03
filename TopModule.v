`timescale 1ns / 1ps
module top_rf_alu(
    input clk,
    input rst,
    input writeEN_sw,
    input [4:0] rd_sw,
    input [3:0] alu_op_sw,
    output [3:0] state_led,
    output [7:0] result_led   
    );
    
    wire fsm_done_wire;
    wire fsm_writeEN_wire;
    wire [4:0] fsm_rd_wire;
    wire [31:0] fsm_writeDT_wire;
    
    
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] alu_result_wire;
    wire zero_flag;
    
    wire final_writeEN = fsm_done_wire ? writeEN_sw : fsm_writeEN_wire;
    wire [4:0] final_rd = fsm_done_wire ? rd_sw : fsm_rd_wire;
    wire [31:0] final_writeDT = fsm_done_wire ? alu_result_wire : fsm_writeDT_wire;
    
    assign result_led = alu_result_wire[7:0];  
    
    ALU uut_board_alu(
        .A(read_data1),
        .B(read_data2),
        .ALUControl(alu_op_sw),
        .ALUResult(alu_result_wire),
        .Zero(zero_flag)
    ); 
    
    task_2 uut_board_reg(
        .clk(clk),
        .rst(rst),
        .writeEN(final_writeEN),
        .rs1(5'd1),
        .rs2(5'd2),
        .rd(final_rd),
        .writeDT(final_writeDT),
        .readDT1(read_data1),
        .readDT2(read_data2)
    );
    
    fsm_startup uut_startup(
        .clk(clk),
        .rst(rst),
        .fsm_done(fsm_done_wire),
        .fsm_writeEN(fsm_writeEN_wire),
        .fsm_rd(fsm_rd_wire),
        .fsm_writeDT(fsm_writeDT_wire)
    );
    
    
endmodule
