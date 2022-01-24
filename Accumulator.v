`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2020 06:58:58 PM
// Design Name: 
// Module Name: Accumulator
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


module Accumulator (in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, out);

    input [23:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7;
    output [23:0] out;
    
    assign out = in_0 + in_1 + in_2 + in_3 + in_4 + in_5 + in_6 + in_7;
    
endmodule
