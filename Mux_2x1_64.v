`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/20/2022 09:32:09 AM
// Design Name: 
// Module Name: Mux_2x1_64
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


module Mux_2x1_64(
    input [31:0] inA,
    input [31:0] inB,
    input sel,
    output [31:0] muxOut
    );
    
    assign muxOut = (sel) ? inB : inA;
    
endmodule
