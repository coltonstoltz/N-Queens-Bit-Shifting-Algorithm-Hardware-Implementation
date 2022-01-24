`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2020 08:25:24 AM
// Design Name: 
// Module Name: Accelerator_tb
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


module Accelerator_tb();

    reg [4:0] n;
    //reg [DATAWIDTH - 1:0] init_min, init_col, init_row;
    //reg [DATAWIDTH - 1:0] init_maj;
    reg clk, reset;
    //wire [DATAWIDTH - 1:0] sum;
    wire [23:0] sum;
    wire done;
    
    Accelerator Accelerator(.n(n), .clk(clk), .reset(reset), .sum(sum), .done(done));
    
    
    always
        begin
            clk <= 1'b0; 
            #1;
            clk <= 1'b1;
            #1;
        end 
    
    initial
        begin
            reset <= 1'b1;
            n <= 5'b10000; //init_min <= 8'b0; init_col <= 8'b0; init_maj <= 8'b0; init_row <= 8'b0;
            #50;
            
            reset <= 1'b0;
            #200;
        end   
        
endmodule