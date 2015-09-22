function q=ql_wzh(h0,slope,g_rd)
%wzh's intrusion discharge formula
%g_rd is the reduced gravitational acceleration

LtoH=9.0;
ksi=0.85;
tt=((2*slope*LtoH-4)*ksi-6*slope*LtoH+4)/(3-ksi)^3;
q=h0^1.5*(tt*(1+ksi)*g_rd)^0.5;