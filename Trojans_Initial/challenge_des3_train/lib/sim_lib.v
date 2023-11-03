// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/BUF.v,v 1.6 2007/05/23 21:43:33 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  General Purpose Buffer
// /___/   /\     Filename : BUF.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:13 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module BUF (O, I);

    output O;

    input  I;

	buf B1 (O, I);


endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/RAM64X1D.v,v 1.8 2005/03/14 22:32:58 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  Static Dual Port Synchronous RAM 64-Deep by 1-Wide
// /___/   /\     Filename : RAM64X1D.v
// \   \  /  \    Timestamp : Thu Mar 25 16:43:34 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Remove for-loop in initial block;
// End Revision

`timescale  1 ps / 1 ps


module RAM64X1D (DPO, SPO, A0, A1, A2, A3, A4, A5, D, DPRA0, DPRA1, DPRA2, DPRA3, DPRA4, DPRA5, WCLK, WE);

    parameter INIT = 64'h0000000000000000;

    output DPO, SPO;

    input  A0, A1, A2, A3, A4, A5, D, DPRA0, DPRA1, DPRA2, DPRA3, DPRA4, DPRA5, WCLK, WE;

    reg [63:0] mem;
    wire [5:0] adr;

    assign adr = {A5, A4, A3, A2, A1, A0};
    assign SPO = mem[adr];
    assign DPO = mem[{DPRA5, DPRA4, DPRA3, DPRA2, DPRA1, DPRA0}];

    initial 
        mem = INIT;

    always @(posedge WCLK) begin 
	    if (WE == 1'b1)
	        mem[adr] <= #100 D;
    end
endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/FDS.v,v 1.11 2006/02/13 22:07:03 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  D Flip-Flop with Synchronous Set
// /___/   /\     Filename : FDS.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:18 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Seperate GSR from clock block.
//    10/20/05 - Add set & reset check to main  block. (CR219794)
//    2/07/06 - Remove set & reset from main block and add /*specify block (CR225119)
//    2/10/06 - Change Q from reg to wire (CR 225613)
// End Revision

`timescale  1 ps / 1 ps


module FDS (Q, C, D, S);

    parameter INIT = 1'b1;

    output Q;

    input  C, D, S;

    wire Q;
    reg q_out;

    initial q_out = INIT;

    assign Q = q_out;



    always @(posedge C )begin
         if (S)
	     q_out <=  1;
         else
	     q_out <=  D;
    end
    /*specify
        if (S)
            (posedge C => (Q +: 1'b1)) = (100, 100);
        if (!S)
            (posedge C => (Q +: D)) = (100, 100);
    endspecify*/

endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/FDSE.v,v 1.11 2006/02/13 22:07:03 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  D Flip-Flop with Synchronous Set and Clock Enable
// /___/   /\     Filename : FDSE.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:18 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Seperate GSR from clock block.
//    10/20/05 - Add set & reset check to main  block. (CR219794)
//    2/07/06 - Remove set & reset from main block and add /*specify block (CR225119)
//    2/10/06 - Change Q from reg to wire (CR 225613)
// End Revision

`timescale  1 ps / 1 ps


module FDSE (Q, C, CE, D, S);

    parameter INIT = 1'b1;

    output Q;

    input  C, CE, D, S;

    wire Q;
    reg q_out;


    initial q_out = INIT;
   
    assign Q = q_out;

    always @(posedge C ) begin
	  if (S)
	     q_out <=  1;
	  else if (CE)
	     q_out <=  D;
    end
    /*specify
        if (S)
            (posedge C => (Q +: 1'b1)) = (100, 100);
        if (!S && CE)
            (posedge C => (Q +: D)) = (100, 100);
    endspecify*/

endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/LUT3.v,v 1.7 2007/05/23 21:43:39 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  3-input Look-Up-Table with General Output
// /___/   /\     Filename : LUT3.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:54 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Replace premitive with function; Remove buf.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module LUT3 (O, I0, I1, I2);

    parameter INIT = 8'h00;

    input I0, I1, I2;

    output O;

    reg O;
    reg tmp;
  
    always @(  I2 or  I1 or  I0 )  begin
      tmp =  I0 ^ I1  ^ I2;
      if ( tmp == 0 || tmp == 1)
           O = INIT[{I2, I1, I0}];
      else
           O = lut3_mux4 ( {1'b0, 1'b0, lut3_mux4 (INIT[7:4], {I1, I0}),
                          lut3_mux4 (INIT[3:0], {I1, I0}) }, {1'b0, I2});
    end

  function lut3_mux4;
  input [3:0] d;
  input [1:0] s;

  begin
       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           lut3_mux4 = d[s];
         else if ((d[0] === d[1]) && (d[2] === d[3]) && (d[0] === d[2]))
           lut3_mux4 = d[0];
         else if ((s[1] == 0) && (d[0] === d[1]))
           lut3_mux4 = d[0];
         else if ((s[1] == 1) && (d[2] === d[3]))
           lut3_mux4 = d[2];
         else if ((s[0] == 0) && (d[0] === d[2]))
           lut3_mux4 = d[0];
         else if ((s[0] == 1) && (d[1] === d[3]))
           lut3_mux4 = d[1];
         else
           lut3_mux4 = 1'bx;
   end
   endfunction

endmodule


// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/LUT3_L.v,v 1.7 2007/05/23 21:43:39 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  3-input Look-Up-Table with Local Output
// /___/   /\     Filename : LUT3_L.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:54 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Replace premitive with function; Remove buf.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module LUT3_L (LO, I0, I1, I2);

    parameter INIT = 8'h00;

    input I0, I1, I2;

    output LO;
    reg LO;
    reg tmp;
  
    always @(  I2 or  I1 or  I0 )  begin
      tmp =  I0 ^ I1  ^ I2;
      if ( tmp == 0 || tmp == 1)
           LO = INIT[{I2, I1, I0}];
      else
           LO = lut3_mux4 ( {1'b0, 1'b0, lut3_mux4 (INIT[7:4], {I1, I0}),
                          lut3_mux4 (INIT[3:0], {I1, I0}) }, {1'b0, I2});
    end

  function lut3_mux4;
  input [3:0] d;
  input [1:0] s;

  begin
       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           lut3_mux4 = d[s];
         else if ((d[0] === d[1]) && (d[2] === d[3]) && (d[0] === d[2]))
           lut3_mux4 = d[0];
         else if ((s[1] == 0) && (d[0] === d[1]))
           lut3_mux4 = d[0];
         else if ((s[1] == 1) && (d[2] === d[3]))
           lut3_mux4 = d[2];
         else if ((s[0] == 0) && (d[0] === d[2]))
           lut3_mux4 = d[0];
         else if ((s[0] == 1) && (d[1] === d[3]))
           lut3_mux4 = d[1];
         else
           lut3_mux4 = 1'bx;
   end
   endfunction

endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/LUT4.v,v 1.7 2007/05/23 21:43:39 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  4-input Look-Up-Table with General Output
// /___/   /\     Filename : LUT4.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:54 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Replace premitive with function; Remove buf.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module LUT4 (O, I0, I1, I2, I3);

  parameter INIT = 16'h0000;

  input I0, I1, I2, I3;

  output O;

  reg O;
  reg tmp;

  always @(  I3 or  I2 or  I1 or  I0 )  begin
 
    tmp =  I0 ^ I1  ^ I2 ^ I3;

    if ( tmp == 0 || tmp == 1)

        O = INIT[{I3, I2, I1, I0}];

    else 
    
      O =  lut4_mux4 ( {lut4_mux4 ( INIT[15:12], {I1, I0}),
                          lut4_mux4 ( INIT[11:8], {I1, I0}),
                          lut4_mux4 ( INIT[7:4], {I1, I0}),
                          lut4_mux4 ( INIT[3:0], {I1, I0}) }, {I3, I2});
  end

  function lut4_mux4;
  input [3:0] d;
  input [1:0] s;
   
  begin

       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           
           lut4_mux4 = d[s];

         else if ((d[0] === d[1]) && (d[2] === d[3]) && (d[0] === d[2])) 
           lut4_mux4 = d[0];
         else if ((s[1] == 0) && (d[0] === d[1]))
           lut4_mux4 = d[0];
         else if ((s[1] == 1) && (d[2] === d[3])) 
           lut4_mux4 = d[2];
         else if ((s[0] == 0) && (d[0] === d[2])) 
           lut4_mux4 = d[0];
         else if ((s[0] == 1) && (d[1] === d[3]))
           lut4_mux4 = d[1];
         else
           lut4_mux4 = 1'bx;
   end
  endfunction

endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/LUT2.v,v 1.7 2007/05/23 21:43:39 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  2-input Look-Up-Table with General Output
// /___/   /\     Filename : LUT2.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:53 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Replace premitive with function; Remove buf.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module LUT2 (O, I0, I1);

    parameter INIT = 4'h0;

    input I0, I1;

    output O;

    reg  O;
    wire [1:0] s;

    assign s = {I1, I0};

    always @(s) begin
       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           O = INIT[s];
         else if ((INIT[0] == INIT[1]) && (INIT[2] == INIT[3]) && (INIT[0] == INIT[2])) 
           O = INIT[0];
         else if ((s[1] == 0) && (INIT[0] == INIT[1]))
           O = INIT[0];
         else if ((s[1] == 1) && (INIT[2] == INIT[3])) 
           O = INIT[2];
         else if ((s[0] == 0) && (INIT[0] == INIT[2])) 
           O = INIT[0];
         else if ((s[0] == 1) && (INIT[1] == INIT[3]))
           O = INIT[1];
         else
           O = 1'bx;
    end
endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/LUT2_D.v,v 1.7 2007/05/23 21:43:39 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  2-input Look-Up-Table with Dual Output
// /___/   /\     Filename : LUT2_D.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:53 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Replace premitive with function; Remove buf.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module LUT2_D (LO, O, I0, I1);

    parameter INIT = 4'h0;

    input I0, I1;

    output LO, O;

    reg  O;
    wire LO;
    wire [1:0] s;

    assign s = {I1, I0};
    assign LO = O;

    always @(s) begin
       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           O = INIT[s];
         else if ((INIT[0] == INIT[1]) && (INIT[2] == INIT[3]) && (INIT[0] == INIT[2])) 
           O = INIT[0];
         else if ((s[1] == 0) && (INIT[0] == INIT[1]))
           O = INIT[0];
         else if ((s[1] == 1) && (INIT[2] == INIT[3])) 
           O = INIT[2];
         else if ((s[0] == 0) && (INIT[0] == INIT[2])) 
           O = INIT[0];
         else if ((s[0] == 1) && (INIT[1] == INIT[3]))
           O = INIT[1];
         else
           O = 1'bx;
    end
endmodule
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/LUT2_L.v,v 1.7 2007/05/23 21:43:39 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  2-input Look-Up-Table with Local Output
// /___/   /\     Filename : LUT2_L.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:54 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Replace premitive with function; Remove buf.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module LUT2_L (LO, I0, I1);

    parameter INIT = 4'h0;

    input I0, I1;

    output LO;

    reg  LO;
    wire [1:0] s;

    assign s = {I1, I0};

    always @(s) begin
       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           LO = INIT[s];
         else if ((INIT[0] == INIT[1]) && (INIT[2] == INIT[3]) && (INIT[0] == INIT[2])) 
           LO = INIT[0];
         else if ((s[1] == 0) && (INIT[0] == INIT[1]))
           LO = INIT[0];
         else if ((s[1] == 1) && (INIT[2] == INIT[3])) 
           LO = INIT[2];
         else if ((s[0] == 0) && (INIT[0] == INIT[2])) 
           LO = INIT[0];
         else if ((s[0] == 1) && (INIT[1] == INIT[3]))
           LO = INIT[1];
         else
           LO = 1'bx;
    end

endmodule
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/FDR.v,v 1.11 2006/02/13 22:07:02 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  D Flip-Flop with Synchronous Reset
// /___/   /\     Filename : FDR.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:17 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Seperate GSR from clock block.
//    10/20/05 - Add set & reset check to main  block. (CR219794)
//    2/07/06 - Remove set & reset from main block and add /*specify block (CR225119)
//    2/10/06 - Change Q from reg to wire (CR 225613)
// End Revision

`timescale  1 ps / 1 ps


module FDR (Q, C, D, R);

    parameter INIT = 1'b0;

    output Q;

    input  C, D, R;

    wire Q;
    reg q_out;


    initial q_out = INIT;

    assign Q = q_out;

    always @(posedge C ) begin
         if (R)
	    q_out <=  0;
         else
	    q_out <=  D;
    end

    /*specify
        if (R)
            (posedge C => (Q +: 1'b0)) = (100, 100);
        if (!R)
            (posedge C => (Q +: D)) = (100, 100);
    endspecify*/

endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/FDRE.v,v 1.11 2006/02/13 22:07:02 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  D Flip-Flop with Synchronous Reset and Clock Enable
// /___/   /\     Filename : FDRE.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:17 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Seperate GSR from clock block.
//    10/20/05 - Add set & reset check to main  block. (CR219794)
//    2/07/06 - Remove set & reset from main block and add /*specify block (CR225119)
//    2/10/06 - Change Q from reg to wire (CR 225613)
// End Revision

`timescale  1 ps / 1 ps


module FDRE (Q, C, CE, D, R);

    parameter INIT = 1'b0;

    output Q;

    input  C, CE, D, R;

    wire Q;
    reg q_out;
    initial q_out = INIT;
   
    assign Q = q_out;

    always @(posedge C ) begin
        if (R)
	     q_out <=  0;
         else if (CE)
	     q_out <=  D;
    end
     /*specify
        if (R)
            (posedge C => (Q +: 1'b0)) = (100, 100);
        if (!R && CE)
            (posedge C => (Q +: D)) = (100, 100);
    endspecify*/


endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/FDRS.v,v 1.11 2006/02/13 22:07:02 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  D Flip-Flop with Synchronous Reset and Set
// /___/   /\     Filename : FDRS.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:17 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Seperate GSR from clock block.
//    10/20/05 - Add set & reset check to main  block. (CR219794)
//    2/07/06 - Remove set & reset from main block and add /*specify block (CR225119)
//    2/10/06 - Change Q from reg to wire (CR 225613)
// End Revision

`timescale  1 ps / 1 ps


module FDRS (Q, C, D, R, S);

    parameter INIT = 1'b0;

    output Q;

    input  C, D, R, S;

    wire Q;
    reg q_out;

    initial q_out = INIT;
   
    assign Q = q_out;


    always @(posedge C ) begin
	   if (R)
	     q_out <=  0;
	   else if (S)
	     q_out <=  1;
	   else
	     q_out <=  D;
    end
    /*specify
        if (R)
            (posedge C => (Q +: 1'b0)) = (100, 100);
        if (!R && S)
            (posedge C => (Q +: 1'b1)) = (100, 100);
        if (!R && !S)
            (posedge C => (Q +: D)) = (100, 100);
    endspecify*/

endmodule
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/FDRSE.v,v 1.11 2006/02/13 22:07:02 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  D Flip-Flop with Synchronous Reset and Set and Clock Enable
// /___/   /\     Filename : FDRSE.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:18 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Seperate GSR from clock block.
//    10/20/05 - Add set & reset check to main  block. (CR219794)
//    2/07/06 - Remove set & reset from main block and add /*specify block (CR225119)
//    2/10/06 - Change Q from reg to wire (CR 225613)
// End Revision

`timescale  1 ps / 1 ps


module FDRSE (Q, C, CE, D, R, S);

    parameter INIT = 1'b0;

    output Q;

    input  C, CE, D, R, S;

    wire Q;
    reg q_out;

    initial q_out = INIT;

    assign Q = q_out;

    always @(posedge C )
    begin
         if (R)
	     q_out <=  0;
         else if (S)
	     q_out <=  1;
         else if (CE)
	     q_out <=  D;
    end
    /*specify
        if (R)
            (posedge C => (Q +: 1'b0)) = (100, 100);
        if (!R && S)
            (posedge C => (Q +: 1'b1)) = (100, 100);
        if (!R && !S && CE)
            (posedge C => (Q +: D)) = (100, 100);
    endspecify*/
endmodule
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/rainier/LUT5.v,v 1.6 2007/06/01 00:22:57 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  5-input Look-Up-Table with General Output
// /___/   /\     Filename : LUT5.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:54 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Replace premitive with function; Remove buf.
//    05/30/07 - Change timescale to 1 ps / 1ps.
// End Revision

`timescale  1 ps / 1 ps


module LUT5 (O, I0, I1, I2, I3, I4);

  parameter INIT = 32'h00000000;

  input I0, I1, I2, I3, I4;

  output O;

  reg O;
  reg tmp;

  always @( I4 or I3 or  I2 or  I1 or  I0 )  begin
 
    tmp =  I0 ^ I1  ^ I2 ^ I3 ^ I4;

    if ( tmp == 0 || tmp == 1)

        O = INIT[{I4, I3, I2, I1, I0}];

    else 
    
      O =  lut4_mux4 ( 
                        { lut6_mux8 ( INIT[31:24], {I2, I1, I0}),
                          lut6_mux8 ( INIT[23:16], {I2, I1, I0}),
                          lut6_mux8 ( INIT[15:8], {I2, I1, I0}),
                          lut6_mux8 ( INIT[7:0], {I2, I1, I0}) }, { I4, I3});
  end

  function lut6_mux8;
  input [7:0] d;
  input [2:0] s;
   
  begin

       if ((s[2]^s[1]^s[0] ==1) || (s[2]^s[1]^s[0] ==0))
           
           lut6_mux8 = d[s];

         else
           if ( ~(|d))
                 lut6_mux8 = 1'b0;
           else if ((&d))
                 lut6_mux8 = 1'b1;
           else if (((s[1]^s[0] ==1'b1) || (s[1]^s[0] ==1'b0)) && (d[{1'b0,s[1:0]}]===d[{1'b1,s[1:0]}]))
                 lut6_mux8 = d[{1'b0,s[1:0]}];
           else if (((s[2]^s[0] ==1) || (s[2]^s[0] ==0)) && (d[{s[2],1'b0,s[0]}]===d[{s[2],1'b1,s[0]}]))
                 lut6_mux8 = d[{s[2],1'b0,s[0]}];
           else if (((s[2]^s[1] ==1) || (s[2]^s[1] ==0)) && (d[{s[2],s[1],1'b0}]===d[{s[2],s[1],1'b1}]))
                 lut6_mux8 = d[{s[2],s[1],1'b0}];
           else if (((s[0] ==1) || (s[0] ==0)) && (d[{1'b0,1'b0,s[0]}]===d[{1'b0,1'b1,s[0]}]) &&
              (d[{1'b0,1'b0,s[0]}]===d[{1'b1,1'b0,s[0]}]) && (d[{1'b0,1'b0,s[0]}]===d[{1'b1,1'b1,s[0]}]))
                 lut6_mux8 = d[{1'b0,1'b0,s[0]}];
           else if (((s[1] ==1) || (s[1] ==0)) && (d[{1'b0,s[1],1'b0}]===d[{1'b0,s[1],1'b1}]) &&
              (d[{1'b0,s[1],1'b0}]===d[{1'b1,s[1],1'b0}]) && (d[{1'b0,s[1],1'b0}]===d[{1'b1,s[1],1'b1}]))
                 lut6_mux8 = d[{1'b0,s[1],1'b0}];
           else if (((s[2] ==1) || (s[2] ==0)) && (d[{s[2],1'b0,1'b0}]===d[{s[2],1'b0,1'b1}]) &&
              (d[{s[2],1'b0,1'b0}]===d[{s[2],1'b1,1'b0}]) && (d[{s[2],1'b0,1'b0}]===d[{s[2],1'b1,1'b1}]))
                 lut6_mux8 = d[{s[2],1'b0,1'b0}];
           else
                 lut6_mux8 = 1'bx;
   end
  endfunction


  function lut4_mux4;
  input [3:0] d;
  input [1:0] s;
   
  begin

       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))

           lut4_mux4 = d[s];

         else if ((d[0] === d[1]) && (d[2] === d[3])  && (d[0] === d[2]) )
           lut4_mux4 = d[0];
         else if ((s[1] == 0) && (d[0] === d[1]))
           lut4_mux4 = d[0];
         else if ((s[1] == 1) && (d[2] === d[3]))
           lut4_mux4 = d[2];
         else if ((s[0] == 0) && (d[0] === d[2]))
           lut4_mux4 = d[0];
         else if ((s[0] == 1) && (d[1] === d[3]))
           lut4_mux4 = d[1];
         else
           lut4_mux4 = 1'bx;

   end
  endfunction

endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/rainier/LUT6.v,v 1.6 2007/06/01 00:22:57 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  6-input Look-Up-Table with General Output
// /___/   /\     Filename : LUT6.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:54 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Replace premitive with function; Remove buf.
//    05/30/07 - Change timescale to 1 ps / 1ps.
// End Revision

`timescale  1 ps / 1 ps


module LUT6 (O, I0, I1, I2, I3, I4, I5);

  parameter INIT = 64'h0000000000000000;

  input I0, I1, I2, I3, I4, I5;

  output O;

  reg O;
  reg tmp;

  always @( I5 or I4 or I3 or  I2 or  I1 or  I0 )  begin
 
    tmp =  I0 ^ I1  ^ I2 ^ I3 ^ I4 ^ I5;

    if ( tmp == 0 || tmp == 1)

        O = INIT[{I5, I4, I3, I2, I1, I0}];

    else 
    
      O =  lut6_mux8 ( {lut6_mux8 ( INIT[63:56], {I2, I1, I0}),
                          lut6_mux8 ( INIT[55:48], {I2, I1, I0}),
                          lut6_mux8 ( INIT[47:40], {I2, I1, I0}),
                          lut6_mux8 ( INIT[39:32], {I2, I1, I0}),
                          lut6_mux8 ( INIT[31:24], {I2, I1, I0}),
                          lut6_mux8 ( INIT[23:16], {I2, I1, I0}),
                          lut6_mux8 ( INIT[15:8], {I2, I1, I0}),
                          lut6_mux8 ( INIT[7:0], {I2, I1, I0}) }, {I5, I4, I3});
  end

  function lut6_mux8;
  input [7:0] d;
  input [2:0] s;
   
  begin

   if ((s[2]^s[1]^s[0] ==1) || (s[2]^s[1]^s[0] ==0))
           
       lut6_mux8 = d[s];

     else
       if ( ~(|d))
             lut6_mux8 = 1'b0;
       else if ((&d))
             lut6_mux8 = 1'b1;
       else if (((s[1]^s[0] ==1'b1) || (s[1]^s[0] ==1'b0)) && (d[{1'b0,s[1:0]}]==d[{1'b1,s[1:0]}]))
             lut6_mux8 = d[{1'b0,s[1:0]}];
       else if (((s[2]^s[0] ==1) || (s[2]^s[0] ==0)) && (d[{s[2],1'b0,s[0]}]==d[{s[2],1'b1,s[0]}]))
             lut6_mux8 = d[{s[2],1'b0,s[0]}];
       else if (((s[2]^s[1] ==1) || (s[2]^s[1] ==0)) && (d[{s[2],s[1],1'b0}]==d[{s[2],s[1],1'b1}]))
             lut6_mux8 = d[{s[2],s[1],1'b0}];
       else if (((s[0] ==1) || (s[0] ==0)) && (d[{1'b0,1'b0,s[0]}]==d[{1'b0,1'b1,s[0]}]) &&
          (d[{1'b0,1'b0,s[0]}]==d[{1'b1,1'b0,s[0]}]) && (d[{1'b0,1'b0,s[0]}]==d[{1'b1,1'b1,s[0]}]))
             lut6_mux8 = d[{1'b0,1'b0,s[0]}];
       else if (((s[1] ==1) || (s[1] ==0)) && (d[{1'b0,s[1],1'b0}]==d[{1'b0,s[1],1'b1}]) &&
          (d[{1'b0,s[1],1'b0}]==d[{1'b1,s[1],1'b0}]) && (d[{1'b0,s[1],1'b0}]==d[{1'b1,s[1],1'b1}]))
             lut6_mux8 = d[{1'b0,s[1],1'b0}];
       else if (((s[2] ==1) || (s[2] ==0)) && (d[{s[2],1'b0,1'b0}]==d[{s[2],1'b0,1'b1}]) &&
          (d[{s[2],1'b0,1'b0}]==d[{s[2],1'b1,1'b0}]) && (d[{s[2],1'b0,1'b0}]==d[{s[2],1'b1,1'b1}]))
             lut6_mux8 = d[{s[2],1'b0,1'b0}];
       else
             lut6_mux8 = 1'bx;
   end
  endfunction

endmodule


// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/FDE.v,v 1.11 2006/02/13 22:07:02 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  D Flip-Flop with Clock Enable
// /___/   /\     Filename : FDE.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:17 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Seperate GSR from clock block.
//    10/20/05 - Add set & reset check to main  block. (CR219794)
//    2/07/06 - Remove set & reset from main block and add /*specify block (CR225119)
//    2/10/06 - Change Q from reg to wire (CR 225613)
// End Revision

`timescale  1 ps / 1 ps


module FDE (Q, C, CE, D);

    parameter INIT = 1'b0;

    output Q;

    input  C, CE, D;

    wire Q;
    reg q_out;

    //initial q_out = INIT;

    assign Q = q_out;

    always @(posedge C) begin
	    if (CE)
	       q_out <=  D;
    end
    /*specify
        if (CE)
            (posedge C => (Q +: D)) = (100, 100);
    endspecify*/

endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/FD.v,v 1.13 2006/02/13 22:07:02 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  D Flip-Flop
// /___/   /\     Filename : FD.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:16 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Seperate GSR from clock block.
//    08/09/05 - Add GSR to main block (CR 215196). 
//    10/20/05 - Add set & reset check to main  block. (CR219794)
//    2/07/06 - Remove set & reset from main block and add /*specify block (CR225119)
//    2/10/06 - Change Q from reg to net. (CR )
// End Revision

`timescale  1 ps / 1 ps


module FD (Q, C, D);

    parameter INIT = 1'b0;

    output Q;

    input  C, D;

    wire Q;
    reg q_out;

    //initial q_out = INIT;

    always @(posedge C) begin
	        q_out <=  D;
    end
    assign Q = q_out;

    /*specify
        (posedge C => (Q +: D)) = (100, 100);
    endspecify*/

endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/IBUF.v,v 1.7 2007/05/23 21:43:36 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  Input Buffer
// /___/   /\     Filename : IBUF.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:23 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module IBUF (O, I);

    parameter CAPACITANCE = "DONT_CARE";
    parameter IBUF_DELAY_VALUE = "0";
    parameter IFD_DELAY_VALUE = "AUTO";
    parameter IOSTANDARD = "DEFAULT";
    
    output O;
    input  I;

    buf B1 (O, I);
    
    /*
    initial begin
	
        case (CAPACITANCE)

            "LOW", "NORMAL", "DONT_CARE" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute CAPACITANCE on IBUF instance %m is set to %s.  Legal values for this attribute are DONT_CARE, LOW or NORMAL.", CAPACITANCE);
                          $finish;
                      end

        endcase


	case (IBUF_DELAY_VALUE)

            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute IBUF_DELAY_VALUE on IBUF instance %m is set to %s.  Legal values for this attribute are 0, 1, 2, ... or 16.", IBUF_DELAY_VALUE);
                          $finish;
                      end

        endcase


	case (IFD_DELAY_VALUE)

            "AUTO", "0", "1", "2", "3", "4", "5", "6", "7", "8" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute IFD_DELAY_VALUE on IBUF instance %m is set to %s.  Legal values for this attribute are AUTO, 0, 1, 2, ... or 8.", IFD_DELAY_VALUE);
                          $finish;
                      end

	endcase
	
    end*/

endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/IOBUF.v,v 1.9 2007/05/23 21:43:39 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  Bi-Directional Buffer
// /___/   /\     Filename : IOBUF.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:37 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/22/06 - CR#226003 - Added integer, real parameter type
//    05/23/07 - Changed timescale to 1 ps / 1 ps.
//    05/23/07 - Added wire declaration for internal signals.

`timescale  1 ps / 1 ps


module IOBUF (O, IO, I, T);

    parameter CAPACITANCE = "DONT_CARE";
    parameter integer DRIVE = 12;
    parameter IBUF_DELAY_VALUE = "0";
    parameter IFD_DELAY_VALUE = "AUTO";
    parameter IOSTANDARD = "DEFAULT";
    parameter SLEW = "SLOW";

    output O;
    inout  IO;
    input  I, T;

    wire ts;



    or O1 (ts, T);
    bufif0 T1 (IO, I, ts);

    buf B1 (O, IO);

    initial begin
	
        case (CAPACITANCE)

            "LOW", "NORMAL", "DONT_CARE" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute CAPACITANCE on IOBUF instance %m is set to %s.  Legal values for this attribute are DONT_CARE, LOW or NORMAL.", CAPACITANCE);
                          $finish;
                      end

        endcase

	case (IBUF_DELAY_VALUE)

            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute IBUF_DELAY_VALUE on IOBUF instance %m is set to %s.  Legal values for this attribute are 0, 1, 2, ... or 16.", IBUF_DELAY_VALUE);
                          $finish;
                      end

        endcase


	case (IFD_DELAY_VALUE)

            "AUTO", "0", "1", "2", "3", "4", "5", "6", "7", "8" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute IFD_DELAY_VALUE on IOBUF instance %m is set to %s.  Legal values for this attribute are AUTO, 0, 1, 2, ... or 8.", IFD_DELAY_VALUE);
                          $finish;
                      end

	endcase
	
    end // initial begin
    
endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/OBUF.v,v 1.8 2007/05/23 21:43:44 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  Output Buffer
// /___/   /\     Filename : OBUF.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:59 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/22/06 - CR#226003 - Added integer, real parameter type
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module OBUF (O, I);

    parameter CAPACITANCE = "DONT_CARE";
    parameter integer DRIVE = 12;
    parameter IOSTANDARD = "DEFAULT";
    parameter SLEW = "SLOW";
   
    output O;

    input  I;


    buf B1 (O, I);
	/*
    initial begin
	
        case (CAPACITANCE)

            "LOW", "NORMAL", "DONT_CARE" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute CAPACITANCE on OBUF instance %m is set to %s.  Legal values for this attribute are DONT_CARE, LOW or NORMAL.", CAPACITANCE);
                          $finish;
                      end

        endcase

    end*/
    
endmodule


// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/LUT3_D.v,v 1.7 2007/05/23 21:43:39 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  3-input Look-Up-Table with Dual Output
// /___/   /\     Filename : LUT3_D.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:54 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Replace premitive with function; Remove buf.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module LUT3_D (LO, O, I0, I1, I2);

    parameter INIT = 8'h00;

    input I0, I1, I2;

    output LO, O;

    reg O;
    reg tmp;
  
    assign LO = O;

    always @(  I2 or  I1 or  I0 )  begin
      tmp =  I0 ^ I1  ^ I2;
      if ( tmp == 0 || tmp == 1)
           O = INIT[{I2, I1, I0}];
      else
           O = lut3_mux4 ( {1'b0, 1'b0, lut3_mux4 (INIT[7:4], {I1, I0}),
                          lut3_mux4 (INIT[3:0], {I1, I0}) }, {1'b0, I2});
    end

  function lut3_mux4;
  input [3:0] d;
  input [1:0] s;

  begin
       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           lut3_mux4 = d[s];
         else if ((d[0] === d[1]) && (d[2] === d[3]) && (d[0] === d[2]))
           lut3_mux4 = d[0];
         else if ((s[1] == 0) && (d[0] === d[1]))
           lut3_mux4 = d[0];
         else if ((s[1] == 1) && (d[2] === d[3]))
           lut3_mux4 = d[2];
         else if ((s[0] == 0) && (d[0] === d[2]))
           lut3_mux4 = d[0];
         else if ((s[0] == 1) && (d[1] === d[3]))
           lut3_mux4 = d[1];
         else
           lut3_mux4 = 1'bx;
   end
   endfunction

endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/LUT4_D.v,v 1.7 2007/05/23 21:43:39 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  4-input Look-Up-Table with Dual Output
// /___/   /\     Filename : LUT4_D.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:54 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Replace premitive with function; Remove buf.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module LUT4_D (LO, O, I0, I1, I2, I3);

  parameter INIT = 16'h0000;

  input I0, I1, I2, I3;

  output O, LO;

  reg O;
  reg tmp;
  wire LO;

  assign LO = O;

  always @(  I3 or  I2 or  I1 or  I0 )  begin
 
    tmp =  I0 ^ I1  ^ I2 ^ I3;

    if ( tmp == 0 || tmp == 1)

        O = INIT[{I3, I2, I1, I0}];

    else 
    
      O =  lut4_mux4 ( {lut4_mux4 ( INIT[15:12], {I1, I0}),
                          lut4_mux4 ( INIT[11:8], {I1, I0}),
                          lut4_mux4 ( INIT[7:4], {I1, I0}),
                          lut4_mux4 ( INIT[3:0], {I1, I0}) }, {I3, I2});
  end

  function lut4_mux4;
  input [3:0] d;
  input [1:0] s;
   
  begin

       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           
           lut4_mux4 = d[s];

         else if ((d[0] === d[1]) && (d[2] === d[3]) && (d[0] === d[2])) 
           lut4_mux4 = d[0];
         else if ((s[1] == 0) && (d[0] === d[1]))
           lut4_mux4 = d[0];
         else if ((s[1] == 1) && (d[2] === d[3])) 
           lut4_mux4 = d[2];
         else if ((s[0] == 0) && (d[0] === d[2])) 
           lut4_mux4 = d[0];
         else if ((s[0] == 1) && (d[1] === d[3]))
           lut4_mux4 = d[1];
         else
           lut4_mux4 = 1'bx;
   end
  endfunction

endmodule
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/LUT4_L.v,v 1.7 2007/05/23 21:43:39 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  4-input Look-Up-Table with Local Output
// /___/   /\     Filename : LUT4_L.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:54 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Replace premitive with function; Remove buf.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module LUT4_L (LO, I0, I1, I2, I3);

  parameter INIT = 16'h0000;

  input I0, I1, I2, I3;

  output LO;

  reg LO;
  reg tmp;

  always @(  I3 or  I2 or  I1 or  I0 )  begin
 
    tmp =  I0 ^ I1  ^ I2 ^ I3;

    if ( tmp == 0 || tmp == 1)

        LO = INIT[{I3, I2, I1, I0}];

    else 
    
      LO =  lut4_mux4 ( {lut4_mux4 ( INIT[15:12], {I1, I0}),
                          lut4_mux4 ( INIT[11:8], {I1, I0}),
                          lut4_mux4 ( INIT[7:4], {I1, I0}),
                          lut4_mux4 ( INIT[3:0], {I1, I0}) }, {I3, I2});
  end

  function lut4_mux4;
  input [3:0] d;
  input [1:0] s;
   
  begin

       if ((s[1]^s[0] ==1) || (s[1]^s[0] ==0))
           
           lut4_mux4 = d[s];

         else if ((d[0] === d[1]) && (d[2] === d[3]) && (d[0] === d[2])) 
           lut4_mux4 = d[0];
         else if ((s[1] == 0) && (d[0] === d[1]))
           lut4_mux4 = d[0];
         else if ((s[1] == 1) && (d[2] === d[3])) 
           lut4_mux4 = d[2];
         else if ((s[0] == 0) && (d[0] === d[2])) 
           lut4_mux4 = d[0];
         else if ((s[0] == 1) && (d[1] === d[3]))
           lut4_mux4 = d[1];
         else
           lut4_mux4 = 1'bx;
   end
  endfunction

endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/VCC.v,v 1.5 2007/05/23 21:43:44 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  VCC Connection
// /___/   /\     Filename : VCC.v
// \   \  /  \    Timestamp : Thu Mar 25 16:43:41 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module VCC(P);

    output P;

	assign P = 1'b1;

endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/GND.v,v 1.5 2007/05/23 21:43:33 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  GND Connection
// /___/   /\     Filename : GND.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:19 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module GND(G);

    output G;

	assign G = 1'b0;

endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/MUXF5.v,v 1.11 2007/08/23 23:00:26 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  2-to-1 Lookup Table Multiplexer with General Output
// /___/   /\     Filename : MUXF5.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:55 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Remove unnessasary begin/end;
//    02/10/07 - When input same, output same for any sel value. (CR433761).
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps

module MUXF5 (O, I0, I1, S);

    output O;
    reg    O;

    input  I0, I1, S;

	always @(I0 or I1 or S) begin
	    if (S)
		O = I1;
	    else
		O = I0;
    end
endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/BUFGP.v,v 1.6 2007/05/23 21:43:33 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  Primary Global Buffer for Driving Clocks or Long Lines
// /___/   /\     Filename : BUFGP.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:14 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module BUFGP (O, I);

    output O;

    input  I;

	buf B1 (O, I);


endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/SRL16.v,v 1.8 2007/05/23 21:43:44 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  16-Bit Shift Register Look-Up-Table
// /___/   /\     Filename : SRL16.v
// \   \  /  \    Timestamp : Thu Mar 25 16:43:40 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.

`timescale  1 ps / 1 ps


module SRL16 (Q, A0, A1, A2, A3, CLK, D);

    parameter INIT = 16'h0000;

    output Q;

    input  A0, A1, A2, A3, CLK, D;

    reg  [15:0] data;


    assign Q = data[{A3, A2, A1, A0}];
	initial data = INIT;
    always @(posedge CLK)
    begin
	{data[15:0]} <= #100 {data[14:0], D};
    end


endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/LUT1.v,v 1.7 2007/05/23 21:43:39 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  1-input Look-Up-Table with General Output
// /___/   /\     Filename : LUT1.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:53 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Replace premitive with function; Remove buf.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module LUT1 (O, I0);

    parameter INIT = 2'h0;

    input I0;

    output O;
    
    wire O;

    assign O = (INIT[0] == INIT[1]) ? INIT[0] : INIT[I0];

endmodule
// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/FDCE.v,v 1.13 2006/02/13 22:07:02 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  D Flip-Flop with Asynchronous Clear and Clock Enable
// /___/   /\     Filename : FDCE.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:16 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Seperate GSR from clock block.
//    08/09/05 - Add CLR to GSR block (CR 215196).
//    10/20/05 - Add set & reset check to main  block. (CR219794)
//    2/07/06 - Remove set & reset from main block and add /*specify block (CR225119)
//    2/10/06 - Change Q from reg to wire (CR 225613)
// End Revision

`timescale  1 ps / 1 ps

module FDCE (Q, C, CE, CLR, D);

    parameter INIT = 1'b0;

    output Q;

    input  C, CE, CLR, D;

    wire Q;
    reg q_out;
    
    //initial q_out = 0;
   
    assign Q = q_out;


    /*always @( CLR)
      if (CLR)
            q_out <= 0;*/
      

    always @(posedge C, posedge CLR)
    begin
        if(CLR)
            q_out<=0;
        else if(CE)
		     q_out <= D;
    end
    /*specify
        (posedge CLR => (Q +: 1'b0)) = (0, 0);
        if (!CLR && CE)
            (posedge C => (Q +: D)) = (100, 100);
    endspecify*/


endmodule

`timescale  1 ps / 1 ps

module FDPE (Q, C, CE, PRE, D);

    parameter INIT = 1'b0;

    output Q;

    input  C, CE, PRE, D;

    wire Q;
    reg q_out;
    
    //initial q_out = 0;
   
    assign Q = q_out;


    /*always @( PRE)
      if (PRE)
            assign q_out = 1;
      //else
      //      deassign q_out;
    */
    always @(posedge C, posedge PRE)
    begin
        if(PRE)
            q_out<=1;
        else if (CE)
		    q_out <= D;
    end
    /*specify
        (posedge PRE => (Q +: 1'b1)) = (0, 0);
        if (!PRE && CE)
            (posedge C => (Q +: D)) = (100, 100);
    endspecify*/


endmodule


// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/FDC.v,v 1.13 2006/02/13 22:07:02 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  D Flip-Flop with Asynchronous Clear
// /___/   /\     Filename : FDC.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:16 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Seperate GSR from clock block.
//    08/09/05 - Add CLR t0 GSR block (CR 215196).
//    10/20/05 - Add set & reset check to main  block. (CR219794)
//    2/07/06 - Remove set & reset from main block and add /*specify block (CR225119)
//    2/10/06 - Change Q from reg to wire (CR 225613)
// End Revision

`timescale  1 ps / 1 ps


module FDC (Q, C, CLR, D);

    parameter INIT = 1'b0;

    output Q;

    input  C, CLR, D;

    wire Q;
    reg q_out;

    //initial q_out = INIT;


    /*always @(CLR)
      if (CLR)
           q_out <= 0;
      //else
      //      deassign q_out;
    */
    always @(posedge C, posedge CLR)
    begin
        if(CLR)
            q_out<=0;
        else
	        q_out <=  D;
    end
    assign Q = q_out;

    /*specify
        (posedge CLR => (Q +: 1'b0)) = (0, 0);
        if (!CLR)
            (posedge C => (Q +: D)) = (100, 100);
    endspecify*/
endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/INV.v,v 1.6 2007/05/23 21:43:36 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  Inverter
// /___/   /\     Filename : INV.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:37 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module INV (O, I);

    output O;

    input  I;

	not N1 (O, I);

endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/FDP.v,v 1.13 2006/02/13 22:07:02 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  D Flip-Flop with Asynchronous Preset
// /___/   /\     Filename : FDP.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:17 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Seperate GSR from clock block.
//    08/09/05 - Add PRE to GSR block (CR 215196).
//    10/20/05 - Add set & reset check to main  block. (CR219794)
//    2/07/06 - Remove set & reset from main block and add /*specify block (CR225119)
//    2/10/06 - Change Q from reg to wire (CR 225613)
// End Revision

`timescale  1 ps / 1 ps


module FDP (Q, C, D, PRE);

    parameter INIT = 1'b1;

    output Q;

    input  C, D, PRE;

    wire Q;
    reg q_out;

    //initial q_out = INIT;

    assign Q = q_out;

    //always @(PRE)
    //  if (PRE)
    //         q_out <= 1;
      //else
      //      deassign q_out;

    always @(posedge C, posedge PRE )
    begin
        if(PRE)
            q_out <= 1;
        else
	         q_out <= D;
    end
    /*specify
        (posedge PRE => (Q +: 1'b1)) = (0, 0);
        if (!PRE)
            (posedge C => (Q +: D)) = (100, 100);
    endspecify*/

endmodule


// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/XORCY.v,v 1.6 2007/05/23 21:43:44 patrickp Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  XOR for Carry Logic with General Output
// /___/   /\     Filename : XORCY.v
// \   \  /  \    Timestamp : Thu Mar 25 16:43:42 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    05/23/07 - Changed timescale to 1 ps / 1 ps.

`timescale  1 ps / 1 ps


module XORCY (O, CI, LI);

    output O;

    input  CI, LI;

	xor X1 (O, CI, LI);


endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/MUXCY.v,v 1.11 2007/08/23 23:00:26 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  2-to-1 Multiplexer for Carry Logic with General Output
// /___/   /\     Filename : MUXCY.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:55 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Remove unnessasary begin/end;
//    05/10/07 - When input same, output same for any sel value. (CR434611).
//    08/23/07 - User block statement (CR446704).
// End Revision

`timescale  1 ps / 1 ps


module MUXCY (O, CI, DI, S);

    output O;
    reg    O;

    input  CI, DI, S;

	always @(CI or DI or S)
    begin
	    if (S)
		O = CI;
	    else
		O = DI;
    end
endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/MUXF6.v,v 1.11 2007/08/23 23:00:26 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  2-to-1 Lookup Table Multiplexer with General Output
// /___/   /\     Filename : MUXF6.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:55 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Remove unnessasary begin/end;
//    05/10/07 - When input same, output same for any sel value. (CR434611).
//    08/23/07 - User block statement (CR446704).
// End Revision

`timescale  1 ps / 1 ps


module MUXF6 (O, I0, I1, S);

    output O;
    reg    O;

    input  I0, I1, S;

	always @(I0 or I1 or S) begin
	    if (S)
		O = I1;
	    else
		O = I0;
    end
endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/MUXF7.v,v 1.11 2007/08/23 23:00:26 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  2-to-1 Lookup Table Multiplexer with General Output
// /___/   /\     Filename : MUXF7.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:55 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Remove unnessasary begin/end;
//    05/10/07 - When input same, output same for any sel value. (CR434611).
//    08/23/07 - User block statement (CR446704).
// End Revision

`timescale  1 ps / 1 ps

module MUXF7 (O, I0, I1, S);

    output O;
    reg    O;

    input  I0, I1, S;

	always @(I0 or I1 or S) begin
	    if (S)
		O = I1;
	    else
		O = I0;
    end
endmodule

// $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/verunilibs/data/unisims/MUXF8.v,v 1.11 2007/08/23 23:00:26 yanx Exp $
///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2004 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  2-to-1 Lookup Table Multiplexer with General Output
// /___/   /\     Filename : MUXF8.v
// \   \  /  \    Timestamp : Thu Mar 25 16:42:56 PST 2004
//  \___\/\___\
//
// Revision:
//    03/23/04 - Initial version.
//    02/04/05 - Rev 0.0.1 Remove input/output bufs; Remove unnessasary begin/end;
//    05/10/07 - When input same, output same for any sel value. (CR434611).
//    08/23/07 - User block statement (CR446704).
// End Revision

`timescale  1 ps / 1 ps


module MUXF8 (O, I0, I1, S);

    output O;
    reg    O;

    input  I0, I1, S;

	always @(I0 or I1 or S) begin
        if (S)
		O = I1;
	    else
		O = I0;
    end
endmodule

module LUT6_2(output O6, output O5, input I0, I1, I2, I3, I4, I5);
  parameter [63:0] INIT = 0;
  wire [31: 0] s5 = I5 ? INIT[63:32] : INIT[31: 0];
  wire [15: 0] s4 = I4 ?   s5[31:16] :   s5[15: 0];
  wire [ 7: 0] s3 = I3 ?   s4[15: 8] :   s4[ 7: 0];
  wire [ 3: 0] s2 = I2 ?   s3[ 7: 4] :   s3[ 3: 0];
  wire [ 1: 0] s1 = I1 ?   s2[ 3: 2] :   s2[ 1: 0];
  assign O6 = I0 ? s1[1] : s1[0];

  wire [15: 0] s5_4 = I4 ? INIT[31:16] : INIT[15: 0];
  wire [ 7: 0] s5_3 = I3 ? s5_4[15: 8] : s5_4[ 7: 0];
  wire [ 3: 0] s5_2 = I2 ? s5_3[ 7: 4] : s5_3[ 3: 0];
  wire [ 1: 0] s5_1 = I1 ? s5_2[ 3: 2] : s5_2[ 1: 0];
  assign O5 = I0 ? s5_1[1] : s5_1[0];
endmodule
