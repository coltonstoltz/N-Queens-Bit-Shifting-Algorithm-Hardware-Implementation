`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2020 08:02:51 AM
// Design Name: 
// Module Name: Accelerator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "Accelerator.vh"

module Accelerator(clk, reset, sum, done);

//    input [4:0] n;
    //input [DATAWIDTH - 1:0] init_min, init_col, init_row;
    //input [DATAWIDTH - 1:0] init_maj;
    input clk, reset;
    output [63:0] sum;
    output done;
    
    wire [63:0] sum_0, sum_1, sum_2, sum_3, sum_4, sum_5, sum_6, sum_7, sum_8, 
                sum_9, sum_10, sum_11, sum_12, sum_13, sum_14, sum_15, sum_16,
                sum_17, sum_18;
                //acc_0_out, acc_1_out;
    wire done_0, done_1, done_2, done_3, done_4, done_5, done_6, done_7, done_8, 
         done_9, done_10, done_11, done_12, done_13, done_14, done_15, done_16,
         done_17, done_18;
  
    /*
    //Use if running single Solver unit simulations
    Solver Solver_0(.N(n), .i_colPtr(5'b00000), .i_rowPtr(5'b00000), .clk(clk), .reset(reset), .count(sum), .done(done));
    */
    
    //Use these if running parallel Solver configuration simulations
    Solver #(.N(`N)) Solver_0(.i_colPtr(5'b00000), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_0), .done(done_0));
    Solver #(.N(`N)) Solver_1(.i_colPtr(5'b00001), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_1), .done(done_1));
    Solver #(.N(`N)) Solver_2(.i_colPtr(5'b00010), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_2), .done(done_2));
    Solver #(.N(`N)) Solver_3(.i_colPtr(5'b00011), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_3), .done(done_3));
    Solver #(.N(`N)) Solver_4(.i_colPtr(5'b00100), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_4), .done(done_4));
    Solver #(.N(`N)) Solver_5(.i_colPtr(5'b00101), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_5), .done(done_5));
    Solver #(.N(`N)) Solver_6(.i_colPtr(5'b00110), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_6), .done(done_6));
    Solver #(.N(`N)) Solver_7(.i_colPtr(5'b00111), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_7), .done(done_7));
    Solver #(.N(`N)) Solver_8(.i_colPtr(5'b01000), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_8), .done(done_8));
    Solver #(.N(`N)) Solver_9(.i_colPtr(5'b01001), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_9), .done(done_9));
    Solver #(.N(`N)) Solver_10(.i_colPtr(5'b01010), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_10), .done(done_10));
    Solver #(.N(`N)) Solver_11(.i_colPtr(5'b01011), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_11), .done(done_11));
    Solver #(.N(`N)) Solver_12(.i_colPtr(5'b01100), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_12), .done(done_12));
    Solver #(.N(`N)) Solver_13(.i_colPtr(5'b01101), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_13), .done(done_13));
    Solver #(.N(`N)) Solver_14(.i_colPtr(5'b01110), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_14), .done(done_14));
    Solver #(.N(`N)) Solver_15(.i_colPtr(5'b01111), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_15), .done(done_15));
    Solver #(.N(`N)) Solver_16(.i_colPtr(5'b10000), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_16), .done(done_16));
    Solver #(.N(`N)) Solver_17(.i_colPtr(5'b10001), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_17), .done(done_17));
    Solver #(.N(`N)) Solver_18(.i_colPtr(5'b10010), .i_rowPtr(5'b00001), .clk(clk), .reset(reset), .count(sum_18), .done(done_18));
    
    /*
    Accumulator ACC_0(.in_0(sum_0), .in_1(sum_1), .in_2(sum_2), .in_3(sum_3), .in_4(sum_4), .in_5(sum_5), .in_6(sum_6), .in_7(sum_7), .out(acc_0_out));
    Accumulator ACC_1(.in_0(sum_8), .in_1(sum_9), .in_2(sum_10), .in_3(sum_11), .in_4(sum_12), .in_5(sum_13), .in_6(sum_14), .in_7(0), .out(acc_1_out));
    Accumulator ACC_Main(.in_0(acc_0_out), .in_1(acc_1_out), .in_2(0), .in_3(0), .in_4(0), .in_5(0), .in_6(0), .in_7(0), .out(sum));
    
    and(done, done_0, done_1, done_2, done_3, done_4, done_5, done_6, done_7, done_8, done_9, done_10, done_11, done_12, done_13, done_14);
    */
    assign sum = sum_0 + sum_1 + sum_2 + sum_3 + sum_4 + sum_5 + sum_6 + sum_7 + sum_8 + sum_9 + sum_10 + sum_11 + sum_12 + sum_13 + sum_14 + sum_15 + sum_16 + sum_17 + sum_18;
    assign done = done_0 & done_1 & done_2 & done_3 & done_4 & done_5 & done_6 & done_7 & done_8 & done_9 & done_10 & done_11 & done_12 & done_13 & done_14 & done_15 & done_16 & done_17 & done_18;
    
endmodule
