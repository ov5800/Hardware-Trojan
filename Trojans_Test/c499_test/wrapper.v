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
    
input [40:0] in_val; 
output [31:0] out_val;

Circuit499 wrap(

    in_val[0], in_val[1], in_val[2], in_val[3], in_val[4], in_val[5], in_val[6], in_val[7], 
    in_val[8], in_val[9], in_val[10], in_val[11], in_val[12], in_val[13], in_val[14], in_val[15], 
    in_val[16], in_val[17], in_val[18], in_val[19], in_val[20], in_val[21], in_val[22], in_val[23], 
    in_val[24], in_val[25], in_val[26], in_val[27], in_val[28], in_val[29], in_val[30], in_val[31],
    in_val[32], in_val[33], in_val[34], in_val[35], in_val[36], in_val[37], in_val[38], in_val[39],
    in_val[40],   
    
    out_val[0], out_val[1], out_val[2], out_val[3], out_val[4], out_val[5], out_val[6], out_val[7], 
    out_val[8], out_val[9], out_val[10], out_val[11], out_val[12], out_val[13], out_val[14], out_val[15], 
    out_val[16], out_val[17], out_val[18], out_val[19], out_val[20], out_val[21], out_val[22], out_val[23],
    out_val[24], out_val[25], out_val[26], out_val[27], out_val[28], out_val[29], out_val[30], out_val[31]  

);


endmodule
