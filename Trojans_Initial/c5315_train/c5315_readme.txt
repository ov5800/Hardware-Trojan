c5315 

Trojan is implemented in X1bus -> Mux9bit_2_1 M1 

      X1bus[8:0] = { in299, in307, in315, in323, in331,
		     in338, in348, in358, in366 };

Trigger is 
	in299 = 1, in315 = 0, in331 = 1, in348 = 0 
          |          |          |          | 
    in[169]      in[167]      in[165]    in[163] 	   

Payload -> Xbus = (X1bus[8] & ~X1bus[6] & X1bus[4] & ~ X1bus[2]) ? Ybus  : Xbus_trojan; 


Test : 
          
Input : 0x0002200000000000000000000000000000000000000000
 safe output :  0x07800009F4FCC2000026007BFFC0460F
trojan output : 0x07800009F4FCC2000022007BFFC0460F
                                     ^
                                     | 
                                  it is different here, I promise