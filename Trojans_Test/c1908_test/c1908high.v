/****************************************************************************
 *                                                                          *
 *  VERILOG HIGH-LEVEL DESCRIPTION OF THE ISCAS-85 BENCHMARK CIRCUIT c1908  *
 *                                                                          *  
 *                                                                          *
 *  Written by   : Hakan Yalcin (hyalcin@cadence.com)		            *
 *  Verified by  : Jonathan David Hauke (jhauke@eecs.umich.edu)             *
 *                                                                          *
 *  First created: Jan  7, 1997                                             *
 *  Last modified: Oct 20, 1998                                             *
 *                                                                          *
****************************************************************************/

module	Circuit1908(
        in101, in104, in107, in110, in113, in116, in119, 
        in122, in125, in128, in131, in134, in137, in140, in143, 
        in146, in210, in214, in217, in221, in224, in227, in234, 
        in237, in469, in472, in475, in478, in898, in900, in902, 
        in952, in953,
        out3, out6, out9, out12, out30, out45, out48, 
        out15, out18, out21, out24, out27, out33, out36, out39, 
        out42, out75, out51, out54, out60, out63, out66, out69, 
        out72, out57);

   input
        in101, in104, in107, in110, in113, in116, in119, 
        in122, in125, in128, in131, in134, in137, in140, in143, 
        in146, in210, in214, in217, in221, in224, in227, in234, 
        in237, in469, in472, in475, in478, in898, in900, in902, 
        in952, in953;
 
   output
        out3, out6, out9, out12, out30, out45, out48, 
        out15, out18, out21, out24, out27, out33, out36, out39, 
        out42, out75, out51, out54, out60, out63, out66, out69, 
        out72, out57;


   wire [15:0] 	InDataBus, OutDataBus;
   wire [5:0] 	InCheckBits, OutSynCheckBits;
   wire [3:0] 	InExtSynBits;
   wire 	ContE, ContB, ContF, ContG, ContH, ContK, ContL;
   wire 	ByteParLo, ByteParHi, UncorrError;

/* In connections */
   
   assign
	 InDataBus[15:0]  = { in146, in143, in140, in137, in134, in131, in128,
			      in125, in122, in119, in116, in113, in110, in107,
		   	      in104, in101 };
   assign
	 InCheckBits[5:0]  = { in224, in221, in227, in210, in214, in217 };
//                               f      e      d      c      b      a

   assign
	 InExtSynBits[3:0] = { in469, in472, in475, in478 };
//                               s      r      q      p

   assign ContE = in902,
          ContB = in953,
          ContF = in952,
          ContG = in234,
          ContH = in237,
          ContK = in898,
          ContL = in900;

/* Out connections */

   assign
	 {out48, out45, out42, out39, out36, out33,
	   out30, out27, out24, out21, out18, out15,
	   out12, out9,  out6,  out3} = OutDataBus[15:0];
   assign
	 { out51, out66, out54, out57, out60, out63 } = OutSynCheckBits[5:0];
  
   assign out69 = ByteParLo, 
          out72 = ByteParHi,
          out75 = UncorrError;
   
/* top level circuit */
   
   TopLevel1908 Ckt1908(InDataBus, InCheckBits, InExtSynBits,
				    ContE, ContB, ContF, ContG, ContH, ContK, ContL,
				    OutDataBus, OutSynCheckBits,
				    ByteParLo, ByteParHi, UncorrError);
   
endmodule // Circuit1908

/*************************************************************************/
/*************************************************************************/

module TopLevel1908(InDataBus, InCheckBits, InExtSynBits,
				    ContE, ContB, ContF, ContG, ContH, ContK, ContL,
				    OutDataBus, OutSynCheckBits,
				    ByteParLo, ByteParHi, UncorrError);

   input [15:0]  InDataBus;
   input [5:0]	  InCheckBits;
   input [3:0]	  InExtSynBits;
   input		  ContE, ContB, ContF, ContG, ContH, ContK, ContL;

   output [15:0] OutDataBus;
   output [5:0]  OutSynCheckBits;
   output		  ByteParLo, ByteParHi, UncorrError;

   wire [5:0]	  SynBits, NewSynBits, Not_NewSynBits, AllExtSynBits;

/* AllExtSynBits=InExtSynBits+ 2 new ones generated from a,c,G,H,E */   

   wire		  ContIntM, ContIntP, CorrectionFlag;
   wire		  CorrectionFlagLo, CorrectionFlagHi;
   wire		  InDBParityLo, InDBParityHi;
   wire [15:0]	  DecodedSyn;
   wire [11:0]	  ProductSyn;


   SyndromeGenerator M1(InDataBus, InCheckBits, ContB, ContG, ContH,
			SynBits, InDBParityLo, InDBParityHi);
   
   ModifySyndrome M2(SynBits, InExtSynBits, InCheckBits, ContE, ContG, ContH,
		     NewSynBits, Not_NewSynBits, AllExtSynBits,
		     ContIntM, ContIntP);

   SyndromeDecode M3(NewSynBits, Not_NewSynBits, ContIntM, ContIntP,
		     ContE, ContB, ContF, ContG, ContH, ContK, ContL,
		     DecodedSyn, ProductSyn,
		     CorrectionFlag, CorrectionFlagLo, CorrectionFlagHi);

   DataBusCorrect M4(InDataBus, DecodedSyn, OutDataBus);

   SynCheckGenerator M5(SynBits, AllExtSynBits, CorrectionFlag, ContE, ContF, ContB,
			OutSynCheckBits);

   ByteParity M6(InDBParityHi, InCheckBits[3], CorrectionFlagHi, ContB, ContL,
		 ByteParHi);

   ByteParity M7(InDBParityLo, InCheckBits[5], CorrectionFlagLo, ContB, ContK,
		 ByteParLo);

   UncorrErrorGenerator M8(ProductSyn, Not_NewSynBits, CorrectionFlagHi, CorrectionFlagLo,
			   InCheckBits[1], InCheckBits[4],			   
			   ContE, ContF, ContB, ContG, ContH, ContIntM, ContIntP,
			   UncorrError);

endmodule // TopLevel1908


/*************************************************************************
 * Module SyndromeGenerator
 * 
 * Function: Generate a 6-bit syndrome (SynBits) from a 16-bit data bus
 * (InDataBus) and 6 checkbits (InCheckBits). InCheckbits are masked/modified
 * with control inputs ContB, ContG and ContH.
 * Also generated are the parities of the high and low byte of InDataBus
 * called InDBParityHi and InDBParityLo.
 * 
***************************************************************************/

module SyndromeGenerator(InDataBus, InCheckBits, ContB, ContG, ContH,
				    SynBits, InDBParityLo, InDBParityHi);

   input [15:0] InDataBus;
   input [5:0]	 InCheckBits;
   input		 ContB, ContG, ContH;
   output [5:0] SynBits;
   output		 InDBParityLo, InDBParityHi;
		 

   wire [15:0]	 NotInDataBus;
   
   inv UM1_0( .A(ContB), .Y(Not_ContB) );
   inv UM1_1( .A(ContH), .Y(Not_ContH) );

   and3 UM1_2( .A(InCheckBits[0]), .B(ContG), .C(Not_ContB), .Y(temp0) );
   and3 UM1_3( .A(InCheckBits[1]), .B(Not_ContH), .C(Not_ContB), .Y(temp1) );
   and3 UM1_4( .A(InCheckBits[2]), .B(Not_ContH), .C(Not_ContB), .Y(temp2) );
   and2 UM1_5( .A(InCheckBits[3]), .B(Not_ContB), .Y(temp3) );
   and3 UM1_6( .A(InCheckBits[4]), .B(ContG), .C(Not_ContB), .Y(temp4) );
   and2 UM1_7( .A(InCheckBits[5]), .B(Not_ContB), .Y(temp5) );

   inv UM1_8( .A(InDataBus[0]), .Y(NotInDataBus[0]) ),
      UM1_9( .A(InDataBus[1]), .Y(NotInDataBus[1]) ),
      UM1_10( .A(InDataBus[2]), .Y(NotInDataBus[2]) ),
      UM1_11( .A(InDataBus[3]), .Y(NotInDataBus[3]) ),
      UM1_12( .A(InDataBus[4]), .Y(NotInDataBus[4]) ),
      UM1_13( .A(InDataBus[5]), .Y(NotInDataBus[5]) ),
      UM1_14( .A(InDataBus[6]), .Y(NotInDataBus[6]) ),
      UM1_15( .A(InDataBus[7]), .Y(NotInDataBus[7]) ),
      UM1_16( .A(InDataBus[8]), .Y(NotInDataBus[8]) ),
      UM1_17( .A(InDataBus[9]), .Y(NotInDataBus[9]) ),
      UM1_18( .A(InDataBus[10]), .Y(NotInDataBus[10]) ),
      UM1_19( .A(InDataBus[11]), .Y(NotInDataBus[11]) ),
      UM1_20( .A(InDataBus[12]), .Y(NotInDataBus[12]) ),
      UM1_21( .A(InDataBus[13]), .Y(NotInDataBus[13]) ),
      UM1_22( .A(InDataBus[14]), .Y(NotInDataBus[14]) ),
      UM1_23( .A(InDataBus[15]), .Y(NotInDataBus[15]) );

/* Parity trees for SynBits[5:0] */

   xor2 UM1_46( .A(NotInDataBus[7]), .B(NotInDataBus[5]), .Y(line46) );
   xor2 UM1_47( .A(line46), .B(NotInDataBus[2]), .Y(line47) );
   xor2 UM1_48( .A(NotInDataBus[14]), .B(NotInDataBus[9]), .Y(line48) );
   xor2 UM1_49( .A(line48), .B(NotInDataBus[11]), .Y(line49) );
   xor2 UM1_50( .A(line47), .B(line49), .Y(line50) );
   xor2 UM1_51( .A(line50), .B(temp0), .Y(SynBits[0]) );

   xor2 UM1_38( .A(NotInDataBus[8]), .B(NotInDataBus[13]), .Y(line38) );
   xor2 UM1_39( .A(line38), .B(NotInDataBus[15]), .Y(line39) );
   xor2 UM1_40( .A(NotInDataBus[14]), .B(temp1), .Y(line40) );
   xor2 UM1_41( .A(line40), .B(NotInDataBus[10]), .Y(line41) );
   xor2 UM1_42( .A(line39), .B(line41), .Y(line42) );
   xor2 UM1_43( .A(NotInDataBus[7]), .B(NotInDataBus[4]), .Y(line43) );
   xor2 UM1_44( .A(line43), .B(NotInDataBus[1]), .Y(line44) );
   xor2 UM1_45( .A(line42), .B(line44), .Y(SynBits[1]) );

   xor2 UM1_24( .A(NotInDataBus[0]), .B(temp2), .Y(line24) );
   xor2 UM1_25( .A(NotInDataBus[12]), .B(NotInDataBus[11]), .Y(line25) );
   xor2 UM1_26( .A(line25), .B(NotInDataBus[10]), .Y(line26) );
   inv UM1_27( .A(line26), .Y(line27) );
   xor2 UM1_28( .A(NotInDataBus[15]), .B(NotInDataBus[14]), .Y(line28) );
   xor2 UM1_29( .A(line28), .B(NotInDataBus[9]), .Y(line29) );
   xor2 UM1_30( .A(line27), .B(line29), .Y(line30) );
   xor2 UM1_31( .A(NotInDataBus[6]), .B(NotInDataBus[5]), .Y(line31) );
   xor2 UM1_32( .A(line31), .B(NotInDataBus[4]), .Y(line32) );
   inv UM1_33( .A(line32), .Y(line33) );
   xor2 UM1_34( .A(line30), .B(line33), .Y(line34) );
   inv UM1_35( .A(line34), .Y(line35) );
   inv UM1_36( .A(line24), .Y(line36) );
   xor2 UM1_37( .A(line36), .B(line35), .Y(SynBits[2]) );

   xor2 UM1_76( .A(NotInDataBus[3]), .B(NotInDataBus[13]), .Y(line76) );
   xor2 UM1_77( .A(line76), .B(temp3), .Y(line77) );
   xor2 UM1_78( .A(NotInDataBus[2]), .B(NotInDataBus[1]), .Y(line78) );
   xor2 UM1_79( .A(line78), .B(NotInDataBus[0]), .Y(line79) );
   xor2 UM1_80( .A(NotInDataBus[15]), .B(NotInDataBus[14]), .Y(line80) );
   xor2 UM1_81( .A(line80), .B(NotInDataBus[9]), .Y(line81) );
   inv UM1_82( .A(line81), .Y(line82) );
   xor2 UM1_83( .A(line79), .B(line82), .Y(line83) );
   xor2 UM1_84( .A(line83), .B(line27), .Y(line84) );
   inv UM1_85( .A(line84), .Y(line85) );
   xor2 UM1_86( .A(line77), .B(line85), .Y(SynBits[3]) );

   xor2 UM1_52( .A(NotInDataBus[8]), .B(NotInDataBus[13]), .Y(line52) );
   xor2 UM1_53( .A(line52), .B(NotInDataBus[15]), .Y(line53) );
   inv UM1_54( .A(line53), .Y(line54) );
   xor2 UM1_55( .A(NotInDataBus[9]), .B(NotInDataBus[6]), .Y(line55) );
   xor2 UM1_56( .A(line55), .B(NotInDataBus[3]), .Y(line56) );
   inv UM1_57( .A(line56), .Y(line57) );
   xor2 UM1_58( .A(line54), .B(line57), .Y(line58) );
   xor2 UM1_59( .A(temp4), .B(NotInDataBus[12]), .Y(line59) );
   inv UM1_60( .A(line59), .Y(line60) );
   xor2 UM1_61( .A(line58), .B(line60), .Y(SynBits[4]) );
   
   xor2 UM1_62( .A(line29), .B(NotInDataBus[8]), .Y(line62) );
   xor2 UM1_63( .A(line62), .B(temp5), .Y(line63) );
   inv UM1_64( .A(line63), .Y(line64) );
   xor2 UM1_65( .A(NotInDataBus[2]), .B(NotInDataBus[1]), .Y(line65) );
   xor2 UM1_66( .A(line65), .B(NotInDataBus[0]), .Y(line66) );
   inv UM1_67( .A(line66), .Y(line67) );
   xor2 UM1_68( .A(NotInDataBus[6]), .B(NotInDataBus[5]), .Y(line68) );
   xor2 UM1_69( .A(line68), .B(NotInDataBus[4]), .Y(line69) );
   xor2 UM1_70( .A(line67), .B(line69), .Y(line70) );
   xor2 UM1_71( .A(NotInDataBus[7]), .B(NotInDataBus[3]), .Y(line71) );
   inv UM1_72( .A(line71), .Y(line72) );
   xor2 UM1_73( .A(line70), .B(line72), .Y(line73) );
   xor2 UM1_74( .A(line64), .B(line73), .Y(line74) );
   inv UM1_75( .A(line74), .Y(SynBits[5]) );


/* Parity trees for the low and high byte of InDataBus: InDBParityLo, InDBParityHi */

   xor2 UM1_87( .A(line67), .B(line69), .Y(line87) );
   xor2 UM1_88( .A(line87), .B(line72), .Y(InDBParityLo) );

   xor2 UM1_89( .A(NotInDataBus[12]), .B(NotInDataBus[11]), .Y(line89) );
   xor2 UM1_90( .A(line89), .B(NotInDataBus[10]), .Y(line90) );
   xor2 UM1_91( .A(line82), .B(line90), .Y(line91) );
   xor2 UM1_92( .A(NotInDataBus[13]), .B(NotInDataBus[8]), .Y(line92) );
   inv UM1_93( .A(line92), .Y(line93) );
   xor2 UM1_94( .A(line91), .B(line93), .Y(InDBParityHi) );

endmodule // SyndromeGenerator


/*************************************************************************
 * Module ModifySyndrome
 * 
 * Function: The 6-bit syndrome (SynBits) is masked with Not_ContE,
 * and xor'ed with AllExtSynBits, which are made up of InExtSynBits
 * plus two more lines obtained from InCheckBits[0], InCheckBits[2]
 * and some control inputs. The external syndrome bits are probably
 * used when the c1908 is cascaded to handle words of size>=16.
 * The output is a modified 6-bit syndrome NewSynBits and its
 * complement Not_NewSynBits.
 * 
***************************************************************************/


module ModifySyndrome(SynBits, InExtSynBits, InCheckBits, ContE, ContG, ContH,
				  NewSynBits, Not_NewSynBits, AllExtSynBits,
				  ContIntM, ContIntP);

   input [5:0]	 SynBits;
   input [3:0]	 InExtSynBits;
   input [5:0]	 InCheckBits;
   input		 ContE, ContG, ContH;
   output [5:0] NewSynBits, Not_NewSynBits, AllExtSynBits;
   output		 ContIntM, ContIntP;


   inv  UM2_0( .A(ContE), .Y(Not_ContE) );
   and2 UM2_1( .A(SynBits[0]), .B(Not_ContE), .Y(temp0) ),
        UM2_2( .A(SynBits[1]), .B(Not_ContE), .Y(temp1) ),
        UM2_3( .A(SynBits[2]), .B(Not_ContE), .Y(temp2) ),
        UM2_4( .A(SynBits[3]), .B(Not_ContE), .Y(temp3) ),
        UM2_5( .A(SynBits[4]), .B(Not_ContE), .Y(temp4) ),
        UM2_6( .A(SynBits[5]), .B(Not_ContE), .Y(temp5) );

   assign AllExtSynBits[3:0] = InExtSynBits[3:0];

   nand2 UM2_7( .A(ContG), .B(Not_ContE), .Y(line7) );
   and2 UM2_8( .A(InCheckBits[0]), .B(line7), .Y(AllExtSynBits[4]) );
   inv  UM2_9( .A(ContH), .Y(Not_ContH) );
   nand2 UM2_10( .A(Not_ContH), .B(Not_ContE), .Y(line10) );
   and2 UM2_11( .A(line10), .B(InCheckBits[2]), .Y(AllExtSynBits[5]) );

   nand2 UM2_12( .A(InCheckBits[1]), .B(line10), .Y(ContIntM) );
   nand2 UM2_13( .A(InCheckBits[4]), .B(line7), .Y(ContIntP) );
   
   xor2  UM2_14( .A(temp0), .B(AllExtSynBits[0]), .Y(NewSynBits[0]) ),
        UM2_15( .A(temp1), .B(AllExtSynBits[1]), .Y(NewSynBits[1]) ),
        UM2_16( .A(temp2), .B(AllExtSynBits[2]), .Y(NewSynBits[2]) ),
        UM2_17( .A(temp3), .B(AllExtSynBits[3]), .Y(NewSynBits[3]) ),
        UM2_18( .A(temp4), .B(AllExtSynBits[4]), .Y(NewSynBits[4]) ),
        UM2_19( .A(temp5), .B(AllExtSynBits[5]), .Y(NewSynBits[5]) );

   inv  UM2_20( .A(NewSynBits[0]), .Y(Not_NewSynBits[0]) ),
        UM2_21( .A(NewSynBits[1]), .Y(Not_NewSynBits[1]) ),
        UM2_22( .A(NewSynBits[2]), .Y(Not_NewSynBits[2]) ),
        UM2_23( .A(NewSynBits[3]), .Y(Not_NewSynBits[3]) ),
        UM2_24( .A(NewSynBits[4]), .Y(Not_NewSynBits[4]) ),
        UM2_25( .A(NewSynBits[5]), .Y(Not_NewSynBits[5]) );
   
endmodule // ModifySyndrome


/*************************************************************************
 * Module SyndromeDecode
 * 
 * Function: The syndrome bits (NewSynBits, Not_NewSynBits) are decoded
 * to identify the bit in error. The result is DecodedSyn, whose ith
 * bit indicates whether the ith input should be corrected: 1 if so,
 * 0 otherwise. At most one bit can be equal to 1, that is, single
 * error correction. The correction can be masked by appropriately setting 
 * the control inputs.
 * ProductSyn are intermediate product terms, also used by module
 * UncorrErrorGenerator. If any DecodedSyn bit is set to 1, CorrectionFlag
 * becomes 1. Similarly, CorrectionFlagLo and CorrectionFlagHi indicate
 * whether correction is performed for the low and high byte of InDataBus,
 * respectively.
 * 
***************************************************************************/

module SyndromeDecode(NewSynBits, Not_NewSynBits, ContIntM, ContIntP,
				  ContE, ContB, ContF, ContG, ContH, ContK, ContL,
				  DecodedSyn, ProductSyn,
				  CorrectionFlag, CorrectionFlagLo, CorrectionFlagHi);

   input [5:0]	  NewSynBits, Not_NewSynBits;
   input		  ContIntM, ContIntP;
   input		  ContE, ContB, ContF, ContG, ContH, ContK, ContL;
   output [15:0] DecodedSyn;
   output [11:0] ProductSyn;
   output		  CorrectionFlag, CorrectionFlagLo, CorrectionFlagHi;
   
   inv  UM3_0( .A(ContK), .Y(Not_ContK) );
   inv  UM3_1( .A(ContL), .Y(Not_ContL) );  
   inv  UM3_2( .A(ContB), .Y(Not_ContB) );
   nand2 UM3_3( .A(ContG), .B(ContH), .Y(NotGH) );
   nand4 UM3_4( .A(Not_ContK), .B(ContE), .C(ContB), .D(NotGH), .Y(line4) );
   nand3 UM3_5( .A(ContF), .B(Not_ContB), .C(NotGH), .Y(line5) );
   nand2 UM3_6( .A(line4), .B(line5), .Y(ContIntLo) );
   nand4 UM3_7( .A(Not_ContL), .B(ContE), .C(ContB), .D(NotGH), .Y(line7) );
   nand2 UM3_8( .A(line7), .B(line5), .Y(ContIntHi) );

   and2 UM3_9 ( .A(ContIntM), .B(NewSynBits[5]), .Y(ProductSyn[0]) ),
       UM3_10( .A(Not_NewSynBits[0]), .B(Not_NewSynBits[1]), .Y(ProductSyn[1]) ),
       UM3_11( .A(Not_NewSynBits[4]), .B(Not_NewSynBits[2]), .Y(ProductSyn[2]) ),
       UM3_12( .A(Not_NewSynBits[0]), .B(NewSynBits[1]), .Y(ProductSyn[3]) ),
       UM3_13( .A(NewSynBits[0]), .B(Not_NewSynBits[1]), .Y(ProductSyn[4]) ),
       UM3_14( .A(NewSynBits[4]), .B(Not_NewSynBits[2]), .Y(ProductSyn[5]) ),
       UM3_15( .A(ContIntP), .B(Not_NewSynBits[3]), .Y(ProductSyn[6]) ),
       UM3_16( .A(NewSynBits[4]), .B(NewSynBits[2]), .Y(ProductSyn[7]) ),
       UM3_17( .A(ContIntM), .B(Not_NewSynBits[5]), .Y(ProductSyn[8]) ),
       UM3_18( .A(Not_NewSynBits[4]), .B(NewSynBits[2]), .Y(ProductSyn[9]) ),
       UM3_19( .A(ContIntP), .B(NewSynBits[3]), .Y(ProductSyn[10]) ),
       UM3_20( .A(NewSynBits[0]), .B(NewSynBits[1]), .Y(ProductSyn[11]) );

   and5 UM3_21( .A(ProductSyn[0]), .B(ProductSyn[10]), .C(ProductSyn[9]),
			.D(ProductSyn[1]), .E(ContIntLo), .Y(DecodedSyn[0]) ),
       UM3_22( .A(ProductSyn[0]), .B(ProductSyn[10]), .C(ProductSyn[2]),
			.D(ProductSyn[3]), .E(ContIntLo), .Y(DecodedSyn[1]) ),
       UM3_23( .A(ProductSyn[0]), .B(ProductSyn[10]), .C(ProductSyn[2]),
			.D(ProductSyn[4]), .E(ContIntLo), .Y(DecodedSyn[2]) ),
       UM3_24( .A(ProductSyn[0]), .B(ProductSyn[10]), .C(ProductSyn[5]),
			.D(ProductSyn[1]), .E(ContIntLo), .Y(DecodedSyn[3]) ),
       UM3_25( .A(ProductSyn[0]), .B(ProductSyn[6]), .C(ProductSyn[9]),
			.D(ProductSyn[3]), .E(ContIntLo), .Y(DecodedSyn[4]) ),
       UM3_26( .A(ProductSyn[0]), .B(ProductSyn[6]), .C(ProductSyn[9]),
			.D(ProductSyn[4]), .E(ContIntLo), .Y(DecodedSyn[5]) ),
       UM3_27( .A(ProductSyn[0]), .B(ProductSyn[6]), .C(ProductSyn[7]),
			.D(ProductSyn[1]), .E(ContIntLo), .Y(DecodedSyn[6]) ),
       UM3_28( .A(ProductSyn[0]), .B(ProductSyn[6]), .C(ProductSyn[2]),
			.D(ProductSyn[11]), .E(ContIntLo), .Y(DecodedSyn[7]) ),
       UM3_29( .A(ProductSyn[0]), .B(ProductSyn[6]), .C(ProductSyn[5]),
			.D(ProductSyn[3]), .E(ContIntHi), .Y(DecodedSyn[8]) ),
       UM3_30( .A(ProductSyn[0]), .B(ProductSyn[10]), .C(ProductSyn[7]),
			.D(ProductSyn[4]), .E(ContIntHi), .Y(DecodedSyn[9]) ),
       UM3_31( .A(ProductSyn[8]), .B(ProductSyn[10]), .C(ProductSyn[9]),
			.D(ProductSyn[3]), .E(ContIntHi), .Y(DecodedSyn[10]) ),
       UM3_32( .A(ProductSyn[8]), .B(ProductSyn[10]), .C(ProductSyn[9]),
			.D(ProductSyn[4]), .E(ContIntHi), .Y(DecodedSyn[11]) ),
       UM3_33( .A(ProductSyn[8]), .B(ProductSyn[10]), .C(ProductSyn[7]),
			.D(ProductSyn[1]), .E(ContIntHi), .Y(DecodedSyn[12]) ),
       UM3_34( .A(ProductSyn[8]), .B(ProductSyn[10]), .C(ProductSyn[5]),
			.D(ProductSyn[3]), .E(ContIntHi), .Y(DecodedSyn[13]) ),
       UM3_35( .A(ProductSyn[0]), .B(ProductSyn[10]), .C(ProductSyn[9]),
			.D(ProductSyn[11]), .E(ContIntHi), .Y(DecodedSyn[14]) ),
       UM3_36( .A(ProductSyn[0]), .B(ProductSyn[10]), .C(ProductSyn[7]),
			.D(ProductSyn[3]), .E(ContIntHi), .Y(DecodedSyn[15]) );

   or8 UM3_37( .A(DecodedSyn[0]), .B(DecodedSyn[1]), .C(DecodedSyn[2]),
			.D(DecodedSyn[3]), .E(DecodedSyn[4]), .F(DecodedSyn[5]),
			.G(DecodedSyn[6]), .H(DecodedSyn[7]), .Y(CorrectionFlagLo) );
   or8 UM3_38( .A(DecodedSyn[8]), .B(DecodedSyn[9]), .C(DecodedSyn[10]),
			.D(DecodedSyn[11]), .E(DecodedSyn[12]), .F(DecodedSyn[13]),
			.G(DecodedSyn[14]), .H(DecodedSyn[15]), .Y(CorrectionFlagHi) );
   or2 UM3_39( .A(CorrectionFlagLo), .B(CorrectionFlagHi), .Y(CorrectionFlag) );
   
endmodule // SyndromeDecode


/*************************************************************************
 * Module DataBusCorrect
 * 
 * Function: InDataBus is xor'ed with DecodedSyn for correcting
 * the bit in error, if there is any and if the control inputs are set
 * to do so.
 * 
***************************************************************************/

module DataBusCorrect(InDataBus, DecodedSyn, OutDataBus);

   input [15:0]  InDataBus, DecodedSyn;
   output [15:0] OutDataBus;

   xor2 UM4_0( .A(InDataBus[0]), .B(DecodedSyn[0]), .Y(OutDataBus[0]) ),
      UM4_1( .A(InDataBus[1]), .B(DecodedSyn[1]), .Y(OutDataBus[1]) ),
      UM4_2( .A(InDataBus[2]), .B(DecodedSyn[2]), .Y(OutDataBus[2]) ),
      UM4_3( .A(InDataBus[3]), .B(DecodedSyn[3]), .Y(OutDataBus[3]) ),
      UM4_4( .A(InDataBus[4]), .B(DecodedSyn[4]), .Y(OutDataBus[4]) ),
      UM4_5( .A(InDataBus[5]), .B(DecodedSyn[5]), .Y(OutDataBus[5]) ),
      UM4_6( .A(InDataBus[6]), .B(DecodedSyn[6]), .Y(OutDataBus[6]) ),
      UM4_7( .A(InDataBus[7]), .B(DecodedSyn[7]), .Y(OutDataBus[7]) ),
      UM4_8( .A(InDataBus[8]), .B(DecodedSyn[8]), .Y(OutDataBus[8]) ),
      UM4_9( .A(InDataBus[9]), .B(DecodedSyn[9]), .Y(OutDataBus[9]) ),
      UM4_10( .A(InDataBus[10]), .B(DecodedSyn[10]), .Y(OutDataBus[10]) ),
      UM4_11( .A(InDataBus[11]), .B(DecodedSyn[11]), .Y(OutDataBus[11]) ),
      UM4_12( .A(InDataBus[12]), .B(DecodedSyn[12]), .Y(OutDataBus[12]) ),
      UM4_13( .A(InDataBus[13]), .B(DecodedSyn[13]), .Y(OutDataBus[13]) ),
      UM4_14( .A(InDataBus[14]), .B(DecodedSyn[14]), .Y(OutDataBus[14]) ),
      UM4_15( .A(InDataBus[15]), .B(DecodedSyn[15]), .Y(OutDataBus[15]) );

endmodule // DataBusCorrect


/*************************************************************************
 * Module SynCheckGenerator
 * 
 * Function: computes the OutSynCheckBits, which are the syndrome or check
 * bits depending on the mode being activated.
 * 
***************************************************************************/

module SynCheckGenerator(SynBits, AllExtSynBits, CorrectionFlag, ContE,
					ContF, ContB, OutSynCheckBits);

   input [5:0]	 SynBits, AllExtSynBits;
   input		 CorrectionFlag;
   input		 ContE, ContF, ContB;
   output [5:0] OutSynCheckBits;

   inv  UM5_0( .A(ContF), .Y(Not_ContF) );
   
   SynCheckSlice UM5_1(SynBits[0], AllExtSynBits[0], CorrectionFlag, ContE,
				   Not_ContF, ContB, OutSynCheckBits[0]),
                 UM5_2(SynBits[1], AllExtSynBits[1], CorrectionFlag, ContE,
				   Not_ContF, ContB, OutSynCheckBits[1]),
                 UM5_3(SynBits[2], AllExtSynBits[2], CorrectionFlag, ContE,
				   Not_ContF, ContB, OutSynCheckBits[2]),
                 UM5_4(SynBits[3], AllExtSynBits[3], CorrectionFlag, ContE,
				   Not_ContF, ContB, OutSynCheckBits[3]),
                 UM5_5(SynBits[4], AllExtSynBits[4], CorrectionFlag, ContE,
				   Not_ContF, ContB, OutSynCheckBits[4]),
                 UM5_6(SynBits[5], AllExtSynBits[5], CorrectionFlag, ContE,
				   Not_ContF, ContB, OutSynCheckBits[5]);

endmodule // SynCheckGenerator

/************************************************/

module SynCheckSlice(SynBits_i, AllExtSynBits_i, CorrectionFlag, ContE,
				 NotContF, ContB, OutSynCheckBits_i);

   input	SynBits_i, AllExtSynBits_i;
   input	CorrectionFlag;
   input	ContE, NotContF, ContB;
   output	OutSynCheckBits_i;
   
   and3 SCS_0( .A(AllExtSynBits_i), .B(ContE), .C(CorrectionFlag), .Y(line0) );
   xor2  SCS_1( .A(SynBits_i), .B(line0), .Y(line1) );
   
   nand2 SCS_2( .A(NotContF), .B(ContB), .Y(line2) );
   and2 SCS_3( .A(line2), .B(line1), .Y(OutSynCheckBits_i) );

endmodule // SynCheckSlice


/*************************************************************************
 * Module Byteparity
 * 
 * Function: computes the corrected parity for low/high byte of InDataBus.
 * 
***************************************************************************/

module ByteParity (InDBParity_N, InCheckBit_N, CorrectionFlag_N, ContB, Cont_N,
			    ByteParity_N);

   input	InDBParity_N, InCheckBit_N, CorrectionFlag_N;
   input	ContB, Cont_N;
   output	ByteParity_N;
   
   inv UM6_7_0( .A(ContB), .Y(Not_ContB) ),
      UM6_7_1( .A(Cont_N), .Y(Not_Cont_N) ),
      UM6_7_2( .A(InDBParity_N), .Y(Not_InDBParity_N) );
   
   nand2 UM6_7_3( .A(ContB), .B(Not_Cont_N), .Y(line3) );
   and2 UM6_7_4( .A(line3), .B(Not_InDBParity_N), .Y(line4) );
   and2 UM6_7_5( .A(CorrectionFlag_N), .B(Not_ContB), .Y(line5) );
   xor2  UM6_7_6( .A(line5), .B(line4), .Y(line6) );
   nand2 UM6_7_7( .A(InCheckBit_N), .B(Cont_N), .Y(line7) );
   and2 UM6_7_8( .A(line7), .B(ContB), .Y(line8) );
   xor2  UM6_7_9( .A(line6), .B(line8), .Y(ByteParity_N) );
   
endmodule // ByteParity



/*************************************************************************
 * Module UncorrErrorGenerator
 * 
 * Function: computes the  final uncorrectable error signal (UncorrError)
 * from UESignal, the error-free syndrome (ErrorFREE), the CorrectionFlag's,
 * and some control inputs.
 * 
***************************************************************************/

module UncorrErrorGenerator (ProductSyn, Not_NewSynBits, CorrectionFlagHi, CorrectionFlagLo,
			     InCheckBit1, InCheckBit4,
			     ContE,ContF, ContB, ContG, ContH, ContIntM, ContIntP,
			     UncorrError);

   input [11:0]	ProductSyn;
   input [5:0]	Not_NewSynBits;
   input	InCheckBit1, InCheckBit4;	
   input	CorrectionFlagHi, CorrectionFlagLo;
   input	ContE, ContF, ContB, ContG, ContH, ContIntM, ContIntP;
   output	UncorrError;

   wire		 UESignal, ErrorFREE;

   
   inv  UM8_0( .A(ContH), .Y(Not_ContH) ),
        UM8_1( .A(ContE), .Y(Not_ContE) ),
        UM8_2( .A(ContB), .Y(Not_ContB) ),
        UM8_3( .A(ContF), .Y(Not_ContF) ),
        UM8_4( .A(ContIntM), .Y(NotM) ),
        UM8_5( .A(ContIntP), .Y(NotP) );

   nand2 UM8_6( .A(ContG), .B(ContH), .Y(NotGH) );
   and3 UM8_7( .A(ContF), .B(Not_ContB), .C(NotGH), .Y(ContIntUE) );

   UEGen UM8_8(ProductSyn, ContIntUE, NotM, NotP, Not_NewSynBits[3], Not_NewSynBits[5],
	       UESignal);
   
   nand2 UM8_9( .A(Not_ContH), .B(Not_ContE), .Y(line9) ),
         UM8_10( .A(InCheckBit1), .B(line9), .Y(line10) ),
         UM8_11( .A(ContG), .B(Not_ContE), .Y(line11) ),
         UM8_12( .A(InCheckBit4), .B(line11), .Y(line12 ) );
   
   
   nand8 UM8_13( .A(Not_NewSynBits[0]), .B(Not_NewSynBits[1]), .C(Not_NewSynBits[2]),
		 .D(Not_NewSynBits[3]), .E(Not_NewSynBits[4]), .F(Not_NewSynBits[5]),
		 .G(line10), .H(line12), .Y(ErrorFREE) );
   
   inv  UM8_14( .A(CorrectionFlagHi), .Y(NotCorrFlagHi) ),
        UM8_15( .A(CorrectionFlagLo), .Y(NotCorrFlagLo) );
   
   and3 UM8_16( .A(NotCorrFlagLo), .B(NotCorrFlagHi), .C(UESignal), .Y(line16) );
   and4 UM8_17( .A(Not_ContB), .B(ErrorFREE), .C(ContF), .D(line16), .Y(line17) );
   and3 UM8_18( .A(Not_ContB), .B(ErrorFREE), .C(Not_ContF), .Y(line18) );
   nor2 UM8_19( .A(line18), .B(line17), .Y(UncorrError) );

endmodule // UncorrErrorGenerator

/**************************************************************
 * Module UEGen
 * 
 * Function: computes the uncorrectable error signal (UESignal)
 * from the product terms of the syndrome (ProductSyn).
 * UESignal can be masked by control inputs.
 * 
***************************************************************/

module UEGen(ProductSyn, ContIntUE, NotM, NotP, NotNewSynBit3, NotNewSynBit5,
		   UESignal);

   input [11:0] ProductSyn;
   input	ContIntUE, NotM, NotP, NotNewSynBit3, NotNewSynBit5;
   output	UESignal;

   and2 UEG_0( .A(NotP), .B(NotNewSynBit3), .Y(line0) ),
        UEG_1( .A(NotM), .B(NotNewSynBit5), .Y(line1) );

   nand5 UEG_2( .A(ProductSyn[0]), .B(ProductSyn[6]), .C(ProductSyn[2]),
		.D(ProductSyn[1]), .E(ContIntUE), .Y(line2) ),
         UEG_3( .A(ProductSyn[8]), .B(ProductSyn[10]), .C(ProductSyn[2]),
		.D(ProductSyn[1]), .E(ContIntUE), .Y(line3) ),
         UEG_4( .A(ProductSyn[8]), .B(ProductSyn[6]), .C(ProductSyn[9]),
		.D(ProductSyn[1]), .E(ContIntUE), .Y(line4) ),
         UEG_5( .A(ProductSyn[8]), .B(ProductSyn[6]), .C(ProductSyn[2]),
		.D(ProductSyn[3]), .E(ContIntUE), .Y(line5) ),
         UEG_6( .A(ProductSyn[8]), .B(ProductSyn[6]), .C(ProductSyn[2]),
		.D(ProductSyn[4]), .E(ContIntUE), .Y(line6) ),
         UEG_7( .A(ProductSyn[8]), .B(ProductSyn[6]), .C(ProductSyn[5]),
		.D(ProductSyn[1]), .E(ContIntUE), .Y(line7) ),
         UEG_8( .A(ProductSyn[8]), .B(line0), .C(ProductSyn[2]),
		.D(ProductSyn[1]), .E(ContIntUE), .Y(line8) ),
         UEG_9( .A(line1), .B(ProductSyn[6]), .C(ProductSyn[2]),
	        .D(ProductSyn[1]), .E(ContIntUE), .Y(line9) );
   
   and8 UEG_10( .A(line2), .B(line3), .C(line4), .D(line5), .E(line6),
		.F(line7), .G(line8), .H(line9), .Y(UESignal) );
   
endmodule // UEGen

