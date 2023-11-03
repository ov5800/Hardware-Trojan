`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2023 08:52:26 PM
// Design Name: 
// Module Name: cell
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

module inv (
    
    input A,  
    output Y

);
assign Y = ~A; 

endmodule 

module nor9 (A, B, C,D,E, F,G,H,I, Y); 
input A,B,C,D,E,F,G,H,I; 
output Y; 

assign Y = ~(A | B | C | D | E | F | G | H | I); 

endmodule

module or8 (A, B, C,D,E, F,G,H, Y); 
input A,B,C,D,E,F,G,H; 
output Y; 

assign Y = A | B | C | D | E | F | G | H; 

endmodule

module nand8 (A, B, C,D,E, F,G,H, Y); 
input A,B,C,D,E,F,G,H; 
output Y; 

assign Y = ~(A & B & C & D & E & F & G & H); 

endmodule

module and8 (A, B, C,D,E, F,G,H, Y); 
input A,B,C,D,E,F,G,H; 
output Y; 

assign Y = A & B & C & D & E & F & G & H; 

endmodule

module and5 (A, B, C,D,E, Y); 
input A,B,C,D,E; 
output Y; 

assign Y = A & B & C & D & E; 

endmodule

module and4 (A, B, C,D, Y); 
input A,B,C,D; 
output Y; 

assign Y = A & B & C & D; 

endmodule

module and3 (A, B, C, Y); 
input A,B,C; 
output Y; 

assign Y = A & B & C; 

endmodule

module and2 (A, B, Y); 
input A, B; 
output Y; 

assign Y = A & B; 
endmodule 

module or2 (A, B, Y); 
input A, B; 
output Y; 

assign Y = A | B; 
endmodule 

module or3 (A, B, C,  Y); 
input A, B, C; 
output Y; 

assign Y = A | B | C; 
endmodule 

module or4 (A, B, C, D,  Y); 
input A, B, C, D; 
output Y; 

assign Y = A | B | C | D; 
endmodule

module or5 (A, B, C, D, E, Y); 
input A, B, C, D, E; 
output Y; 

assign Y = A | B | C | D | E; 
endmodule

module or6 (A, B, C, D, E,F, Y); 
input A, B, C, D, E, F; 
output Y; 

assign Y = A | B | C | D | E | F; 
endmodule

module nor2 (A, B, Y); 
input A, B; 
output Y; 

assign Y = ~(A | B); 
endmodule 

module buffer (A,Y); 
input A; 
output Y; 
assign Y = A; 
endmodule 

module xor2 (A,B,Y); 
input A, B; 
output Y; 

assign Y = A^B; 
endmodule 

module nand2 (A, B, Y); 
input A, B; 
output Y; 

assign Y = ~(A & B); 
endmodule


module nand3 (A,B,C,Y); 
input A,B,C;
output Y; 

assign Y = ~(A&B&C); 
endmodule 

module nand4 (A,B,C,D,Y); 
input A,B,C,D;
output Y; 

assign Y = ~(A&B&C&D); 
endmodule 


module nand5 (A,B,C,D,E,Y); 
input A,B,C,D,E;
output Y; 

assign Y = ~(A&B&C&D&E); 
endmodule 