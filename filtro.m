 
Ts = 0.001;      
 
Tf = 0.02;       
 
a1 = (2*Tf - Ts) / (2*Tf + Ts); 
a0 = (2) / (2*Tf + Ts); 

NUM_DERIV = [a0, -a0]; 
DEN_DERIV = [1,  -a1];