`timescale 1ns / 1ps
module fsm_startup(
    input clk,
    input rst,
    output reg fsm_done,
    output reg fsm_writeEN,
    output reg [4:0] fsm_rd,
    output reg [31:0] fsm_writeDT 
    );
    
    reg [1:0] state;
    localparam INIT = 2'd0,
               WRITE1 = 2'd1,
               WRITE2 = 2'd2,
               DONE = 2'd3;
    
    always @(posedge clk) begin
        if(rst) begin
            state <= INIT;
            fsm_done <= 0;
            fsm_writeEN <= 0;
        end else begin
            case(state)
                INIT: begin
                    state <= WRITE1;
                end
                WRITE1: begin
                    fsm_writeEN <= 1;
                    fsm_rd <= 5'd1;
                    fsm_writeDT <= 32'h10101010;
                    state <= WRITE2;
                end
                WRITE2: begin
                    fsm_writeEN <= 1;
                    fsm_rd <= 5'd2;
                    fsm_writeDT <= 32'h01010101;
                    state <= DONE;
                end
                DONE: begin
                    fsm_writeEN <= 0;
                    fsm_done <= 1;
                    state <= DONE;
                end
            endcase
        end
    end    
endmodule
