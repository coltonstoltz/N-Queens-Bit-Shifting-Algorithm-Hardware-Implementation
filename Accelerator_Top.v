`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2022 01:37:34 PM
// Design Name: 
// Module Name: Accelerator_Top
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

module Accelerator_Top(
    input clk,
    input rst,
    output done,
    output dp,
    output [6:0] segment,
    output [7:0] anodes 
    );
    
    reg [28:0] clkDiv = 0;
    wire [63:0] sum;
    wire [31:0] muxOut;
    
    always @(posedge clk) begin
        clkDiv <= clkDiv + 1'b1;
    end
    
    Accelerator Accelerator(.clk(clk), .reset(rst), .sum(sum), .done(done));
    Mux_2x1_64(.inA(sum[31:0]), .inB(sum[63:32]), .sel(clkDiv[28]), .muxOut(muxOut));
    SevenSegmentDisplay Display(.clk(clk), .x(muxOut), .dp(dp), .seg(segment), .anodes(anodes));
    
endmodule
