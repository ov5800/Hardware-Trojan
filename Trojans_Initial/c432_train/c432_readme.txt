c432 , input - 36 bits, output - 7 bits 

Students need to SEND OUT 5 BYTES 

Input to trigger trojan 
in[27] = 0 , in[19] = 1, in[4] = 1

Payload: 
out329 =  ^{1'b1, out329_pretrojan}; 
  *where out329 _pretrojan = PB 


Tested: 

c432_trojan : input = 0x0ff7fffffff  -> output 0x27
c432_safe : input = 0x0ff7ffffff  -> output 0x07
