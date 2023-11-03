`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2023 12:44:45 AM
// Design Name: 
// Module Name: wrapper
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


module wrapper(
        in_val, 
        out_val
    );
    
input [35:0] in_val; 
output [6:0] out_val;

Circuit432 wrap(

in_val[35],

in_val[34],

in_val[33],

in_val[32],

in_val[31],

in_val[30],

in_val[29],

in_val[28],

in_val[27],

in_val[26],

in_val[25],

in_val[24],

in_val[23],

in_val[22],

in_val[21],

in_val[20],

in_val[19],

in_val[18],

in_val[17],

in_val[16],

in_val[15],

in_val[14],

in_val[13],

in_val[12],

in_val[11],

in_val[10],

in_val[9],

in_val[8],

in_val[7],

in_val[6],

in_val[5],

in_val[4],

in_val[3],

in_val[2],

in_val[1],

in_val[0],


out_val[6],

out_val[5],

out_val[4],

out_val[3],

out_val[2],

out_val[1],

out_val[0]

);


endmodule
