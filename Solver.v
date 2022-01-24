`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2020 07:01:23 PM
// Design Name: 
// Module Name: Solver
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

module Solver #(parameter N = 5'd8, REGWIDTH = 5)(/*N, */i_colPtr, i_rowPtr, clk, reset, count, done);

    //parameter REGWIDTH = 5;
    
    //input [4:0] N;
    input [4:0] i_colPtr, i_rowPtr;
    input clk, reset;
    output reg [63:0] count;
    output reg done;
    
    reg [REGWIDTH - 1:0] minReg[(2*N-2):0], majReg[(2*N-2):0]; // minReg and majReg sizes are 2N-1
    reg [REGWIDTH - 1:0] colReg[(N-1):0], colPtrMem[(N-1):0]; // colReg and colPtrMem sizes are N
    reg [REGWIDTH - 1:0] colPtr, rowPtr, tempColPtr;
    reg [(N-1):0] conflicts;

    localparam STATE_0 = 5'b00000, 
               STATE_1 = 5'b00001,
               STATE_2 = 5'b00010, 
               STATE_3 = 5'b00011, 
               STATE_4 = 5'b00100,
               STATE_5 = 5'b00101,
               STATE_6 = 5'b00110, 
               STATE_7 = 5'b00111, 
               STATE_8 = 5'b01000, 
               STATE_9 = 5'b01001, 
               STATE_10 = 5'b01010, 
               STATE_11 = 5'b01011, 
               STATE_12 = 5'b01100, 
               STATE_13 = 5'b01101, 
               STATE_14 = 5'b01110, 
               STATE_15 = 5'b01111, 
               STATE_16 = 5'b10000,
               STATE_8_5 = 5'b10001;

    reg [4:0] nextState;
    
    integer i;
    
    always @(posedge clk) begin
        if (reset) begin
            nextState <= STATE_0;
        end
        else begin
            case (nextState) 
                
                STATE_0: begin
                    for (i = 0; i < N; i = i + 1) begin
                        colReg[i] <= 0; colPtrMem[i] <= 0;
                    end
                    for (i = 0; i < (2*N-1); i = i + 1) begin
                        minReg[i] <= 0; majReg[i] <= 0; 
                    end
                    colPtr <= i_colPtr; rowPtr <= i_rowPtr; tempColPtr <= 0; conflicts <= 0; count <= 0; done <= 0;
                    //conflicts <= conflictsIn;
                    
                    nextState <= STATE_16;
                end
                
                STATE_1: begin
                /*If there is not a conflict in the current column, go to state that will place Queen in this row, column
                  If there is a conflict in the current column, go to state that will increment column pointer (move left)*/ 
                    if (conflicts[colPtr] == 0) begin
                        nextState <= STATE_2;
                    end
                    else begin
                        nextState <= STATE_8;
                    end
                end
                
                STATE_2: begin
                /*Checking if location pointed at by column pointer in minReg is available*/
                /*Row pinter has one added to it for comparison, as a zero indicates no conflict*/
                    colReg[colPtr] <= rowPtr + 1;
                
                    if (minReg[colPtr] == 0) begin
                        nextState <= STATE_3;
                    end
                    else begin
                        nextState <= STATE_4;
                    end
                end
                
                STATE_3: begin
                /*Update minReg to reflect newly placed Queen conflict*/
                /*Row pinter has one added to it for comparison, as a zero indicates no conflict*/
                    minReg[colPtr] = rowPtr + 1;
                    
                    nextState <= STATE_4;
                end
                
                STATE_4: begin
                /*Checking if location pointed at by column pointer in majReg is available*/
                    if (majReg[colPtr+(N-1)] == 0) begin
                        nextState <= STATE_5;
                    end
                    else begin
                        nextState <= STATE_6;
                    end
                end
                
                STATE_5: begin
                /*Update majReg to reflect newly placed Queen conflict*/
                /*Row pinter has one added to it for comparison, as a zero indicates no conflict*/
                    majReg[colPtr+(N-1)] = rowPtr + 1;
                    
                    nextState <= STATE_6;
                end
                
                STATE_6: begin // i < 2N - 2
                /*Left Shifting minReg (down-left)*/
                /*Right Shifting majReg (down-right)*/
                    for (i = 0; i < (2*N-2); i = i + 1) begin
                        minReg[(2*N-2)-i] <= minReg[(2*N-3)-i];
                        majReg[i] <= majReg[i+1];
                    end
                /*Setting ends of minReg and majReg to zero (no conflict)*/
                /*Setting colPtrMem for this row to current column*/
                /*Then incrementing row and setting colPtr back to furthest right column*/
                    minReg[0] <= 0;
                    majReg[(2*N-2)] <= 0;
                    colPtrMem[rowPtr] <= colPtr;
                    rowPtr <= rowPtr + 1;
                    colPtr <= 0;
                    
                    nextState <= STATE_7;                    
                end
                
                STATE_7: begin
                /*Calculating conflicts from min, maj, and col registers
                  Stores conflicts for current row into conlficts register*/
                    for (i = 0; i < N; i = i + 1) begin
                        conflicts[i] <= ((colReg[i] > 0) | (minReg[i] > 0) | (majReg[(N-1)+i] > 0));
                    end
                /*If row pointer is not at bottom row, go to next row down*/
                    if (rowPtr < N) begin
                        nextState <= STATE_1;
                    end
                    else begin
                        nextState <= STATE_14;
                    end
                end
                
                STATE_8: begin
                /*Incrementing column pointer (move left)*/
                    colPtr <= colPtr + 1;
                    
                    nextState <= STATE_8_5;                    
                end
                
                STATE_8_5: begin
                /*If not at the furthest left column, go to state(STATE_1) that will attempt to place Queen*/
                /*If at the furthest left column and not at top row, go to state (STATE_9) that will reverse shift minReg, majReg*/
                /*If at the furthest left column and at the top row, go to state (STATE_15) that will end calculations*/
                    if (colPtr < N) begin
                        nextState <= STATE_1;
                    end
                    else if ((colPtr == N) & (rowPtr > 1)) begin
                        nextState <= STATE_9;
                    end
                    else if ((colPtr == N) & (rowPtr == 1)) begin
                        nextState <= STATE_15;
                    end
                end
                
                STATE_9: begin
                /*Reverse shifting to represent moving back up a row*/
                /*Right Shifting minReg*/
                /*Left Shifting majReg*/
                    for (i = 0; i < (2*N-2); i = i + 1) begin
                        minReg[i] <= minReg[i+1];
                        majReg[(2*N-2)-i] <= majReg[(2*N-3)-i];
                    end
                /*Shifting in zeros (no conflict) at ends of minReg, majReg*/
                /*Column location is set by referencing stored location in colPtrMem for previous row*/
                    minReg[(2*N-2)] <= 0;
                    majReg[0] <= 0;
                    colPtr <= colPtrMem[rowPtr - 1];
                    nextState <= STATE_12;
                end
                
                STATE_10: begin
                    if (colReg[tempColPtr] == rowPtr) begin
                       nextState <= STATE_12; 
                    end
                    else begin
                        nextState <= STATE_11;
                    end
                end
                
                STATE_11: begin
                    tempColPtr = tempColPtr + 1;
                    
                    nextState <= STATE_10;
                end
                
                STATE_12: begin
                /*Needing to backtrack and erase old Queen conflicts*/
                    colReg[colPtr] <= 0;
                    minReg[colPtr] <= 0;
                    majReg[colPtr+(N-1)] <= 0;
                    
                    nextState <= STATE_13;
                end
                
                STATE_13: begin
                /*Updating conflicts register after removing old Queen conflicts done in previous state*/
                /*Moving back up a row*/
                    for (i = 0; i < N; i = i + 1) begin
                        conflicts[i] <= ((colReg[i] > 0) | (minReg[i] > 0) | (majReg[(N-1)+i] > 0));
                    end
                    
                    rowPtr <= rowPtr - 1;
                    
                    nextState <= STATE_8;
                end
                
                STATE_14: begin
                /*Solution found, increment count*/
                /*Go to state (STATE_9) to go */
                    count <= count + 1;
                    
                    nextState <= STATE_9;
                end
                
                STATE_15: begin
                    done <= 1;
                end
                
                STATE_16: begin
                /*Setting initial conflicts into the three registers from pre-placed Queen*/
                    colReg[colPtr] <= 1; 
                    minReg[colPtr+1] <= 1; 
                    majReg[colPtr+N-2] <= 1;
                    colPtr <= 0;
                    
                    nextState <= STATE_7;
                end
                
                default: begin
                    nextState <= STATE_0;
                end
                
            endcase
        end
    end
endmodule
/*
module Solver #(parameter DATAWIDTH = 6)(n, min, maj, col, row_index, 
                                         clk, reset, 
                                         next_min, next_maj, next_col, next_row_index, 
                                         count, done, init, reg_load);

    input [3:0] n;
    input [DATAWIDTH - 1:0] min, maj, col, row_index;
    input clk, reset;
    output reg [DATAWIDTH - 1:0] next_min, next_maj, next_col, next_row_index, count;
    output reg done, init, reg_load;
    
    reg [DATAWIDTH - 1:0] queenPosition, conflicts, tempRowIndex, tempMin, tempMaj, tempCol, queenColumns;
    
    
    reg [DATAWIDTH - 1:0] rows[0:DATAWIDTH - 1];
    reg [DATAWIDTH - 1:0] conflictMem[0:DATAWIDTH - 1];
    
    localparam STATE_0 = 4'b0000,
               STATE_1 = 4'b0001,
               STATE_2 = 4'b0010,
               STATE_3 = 4'b0011,
               STATE_4 = 4'b0100,
               STATE_5 = 4'b0101,
               STATE_6 = 4'b0110,
               STATE_7 = 4'b0111,
               STATE_8 = 4'b1000,
               STATE_9 = 4'b1001,
               STATE_10 = 4'b1010,
               STATE_11 = 4'b1011,
               STATE_12 = 4'b1100,
               STATE_13 = 4'b1101,
               STATE_14 = 4'b1110,
               STATE_15 = 4'b1111;
               
    reg [3:0] state, nextState;
    
    integer i;
    
    always @(posedge clk)
        begin
            if (reset == 1) begin
                nextState <= STATE_0;
            end
            else begin
            
            case (nextState)
                
                STATE_0: begin //  Initializing values, setting up to receive initial min, maj, col, and row index values.
                    count <= 0;
                    done <= 1'b0;
                    init <= 1'b1;
                    queenPosition <= 0;
                    tempRowIndex <= 0;
                    conflicts <= 0;
                    queenColumns <= 0;
                    
                    for (i = 0; i < DATAWIDTH; i = i + 1) begin
                        rows[i] <= 0;
                        conflictMem[i] <= 0;
                    end
                    
                    nextState <= STATE_1;
                end
                
                STATE_1: begin //  Loading new values for min, maj, col, and row index.
                    tempMin <= min;
                    tempMaj <= maj;
                    tempCol <= col;
                    tempRowIndex <= row_index;
                    
                    
                    if (row_index == 0) begin
                        queenColumns = 0;
                    end
                    else begin
                        queenColumns <= queenColumns | rows[row_index - 1];
                    end
                    nextState <= STATE_2;
                end
                
                STATE_2: begin //  Incrementing solution count and continuing FOR loop from previous call.
                    //queenColumns <= queenColumns | rows[tempRowIndex];
                    if ((tempRowIndex) == n) begin
                            nextState <= STATE_5;
                    end
                    else begin
                            nextState <= STATE_3;
                    end
                end
                
                STATE_3: begin //  Getting conflicts for current row.
                    conflicts <= (tempMin | tempMaj | tempCol | queenColumns);
                    nextState <= STATE_4;
                end
                
                STATE_4: begin  //  Initialiazing FOR Loop.
                    queenPosition <= 1;
                    nextState <= STATE_6;
                end
                
                STATE_5: begin //  Continuing FOR Loop, left shifting by one queen's position on current row.
                    count <= count + 1;
                    nextState <= STATE_7;
                end
                
                STATE_6: begin //  Comparing value of conflicts and potential position of queen on current row.
                    if ((conflicts & queenPosition) == 0) begin
                        nextState <= STATE_8;
                    end
                    else begin
                        nextState <= STATE_7;
                    end
                end
                
                STATE_7: begin //  No available spot for queen on current row.  Check to see if queen on top row is at it's last position.  
                               //  If so, done.  If not, need to shift queen's position on current row.
                    if (rows[0][DATAWIDTH - 1] == 1'b1) begin
                        nextState <= STATE_15;
                    end
                    else begin
                        if (queenPosition[DATAWIDTH - 1] == 1'b1) begin
                            nextState <= STATE_10;
                        end
                        else begin
                            nextState <= STATE_9;
                        end
                        
                    end
                end
                
                STATE_8: begin //  Queen has been placed on current row with no conflicts, update next min, maj, col conflicts and increment current row.  
                               //  Write queen's position on current row to rows in case have to come back to current row.
                    next_min <= (tempMin | queenPosition) << 1;
                    next_maj <= (tempMaj | queenPosition) >> 1;
                    next_col <= tempCol | queenPosition;
                    next_row_index <= tempRowIndex + 1;
                    rows[tempRowIndex] <= queenPosition;
                    conflictMem[tempRowIndex] <= conflicts;
                    init <= 1'b0;
                    nextState <= STATE_1;
                end
                
                STATE_9: begin //  No available spot for queen on current row, left shit queen's position on current row by one.
                    queenPosition <= queenPosition << 1;
                    nextState <= STATE_6;
                end
                
                STATE_10: begin //  If queen's position has been shifted out of column range, decrement current row, index into previous rows to get queen's position in previous row.  
                                //  Go back to continuing FOR Loop to increment queen's position in previous row.
                    rows[tempRowIndex] <= 0;
                    conflictMem[tempRowIndex] <= 0;
                    queenPosition <= rows[tempRowIndex - 1];
                    conflicts <= conflictMem[tempRowIndex - 1] | rows[tempRowIndex - 1];
               
                    nextState <= STATE_11;
                   
                end
                
                STATE_11: begin
                    queenColumns <= queenColumns ^ queenPosition;
                    tempRowIndex <= tempRowIndex - 1;
                    nextState <= STATE_12;
                end
                
                STATE_12: begin
                    conflicts <= conflicts | queenColumns;
                    if ((tempRowIndex) == 0) begin
                        nextState <= STATE_14;
                    end
                    else begin
                        nextState <= STATE_13;
                    end
                end
                
                STATE_13: begin
                    tempMin <= rows[tempRowIndex - 1] << 1;
                    tempMaj <= rows[tempRowIndex - 1] >> 1;
                    tempCol <= rows[tempRowIndex - 1];
                    nextState <= STATE_6;
                end
                
                STATE_14: begin
                    tempMin <= 0;
                    tempMaj <= 0;
                    tempCol <= 0;
                    nextState <= STATE_6;
                end
                
                STATE_15: begin
                    done <= 1'b1;
                    nextState <= STATE_15;
                end
                
                default: begin
                    nextState <= STATE_0;
                end
                
            endcase
            end
        end
        
endmodule
*/
/*
module Solver #(parameter DATAWIDTH = 8)(ld, col, rd, clk, reset, next_ld, next_col, next_rd, count, done, init, reg_load);

    input [DATAWIDTH - 1:0] ld, col;
    input [DATAWIDTH - 1:0] rd;
    input clk, reset;
    output reg [DATAWIDTH - 1:0] next_ld, next_col, count;
    output reg [DATAWIDTH - 1:0] next_rd;
    output reg done, init, reg_load;
    reg [DATAWIDTH - 1:0] possibleSlots;
    reg [DATAWIDTH - 1:0] currentBit;
    reg [DATAWIDTH - 1:0] limit = -1;
    
    localparam STATE_Initial = 4'b0000, 
               STATE_0 = 4'b0001,
               STATE_1 = 4'b0010,
               STATE_2 = 4'b0011,
               STATE_3 = 4'b0100,
               STATE_4 = 4'b0101,
               STATE_5 = 4'b0110,
               STATE_Done = 4'b0111;
               
    reg [DATAWIDTH - 1:0] state, nextState;
               
    always @(posedge clk)
        begin
            case (state)
            
                STATE_Initial: begin
                    count <= 0;
                    done <= 0;
                    reg_load <= 1'b0;
                    init <= 1'b1;
                    //possibleSlots <= ~(ld | col | rd);
                    nextState <= STATE_0;
                end
                
                STATE_0: begin
                    reg_load <= 1'b1;
                    //possibleSlots <= ~(ld | col | rd);
                    if (col == -1)
                        begin
                            nextState <= STATE_1;
                        end
                    else
                        begin
                            nextState <= STATE_2;
                        end
                end
               
                STATE_1: begin
                    count <= count + 1;
                    nextState <= STATE_3;
                end
                
                STATE_2: begin
                    possibleSlots <= limit & ~(ld | col | rd);
                    nextState <= STATE_3;
                end
                
                STATE_3: begin
                    //possibleSlots <= ~(ld | col | rd);
                    reg_load <= 1'b0;
                    init <= 1'b0;
                    if (possibleSlots != 0)
                        begin
                            nextState <= STATE_4;
                        end
                    else
                        begin
                            nextState <= STATE_Done;
                        end
                end
                
                STATE_4: begin
                    currentBit <= possibleSlots & -(possibleSlots);
                    nextState <= STATE_5;
                end
                
                STATE_5: begin
                    possibleSlots <= possibleSlots - currentBit;
                    next_col <= col | currentBit;
                    next_ld <= (ld | currentBit) >> 1;
                    next_rd <= (rd | currentBit) << 1;
                    nextState <= STATE_0;
                end
                
                STATE_Done: begin
                    done <= 1;
                    nextState <= STATE_Done;
                end
                
                default: begin
                    nextState <= STATE_Initial;
                end
            endcase
        end
        
        always @(posedge clk)
            begin
                if (reset == 1'b1)
                    begin
                        state <= STATE_Initial;
                    end
                else
                    begin
                        state <= nextState;
                    end
            end

endmodule
*/