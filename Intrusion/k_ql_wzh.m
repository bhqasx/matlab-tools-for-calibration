function K=k_ql_wzh(ksi, slope)
%discharge coefficient of wzh's formula

LtoH=9.0;
tt=((2*slope*LtoH-4)*ksi-6*slope*LtoH+4)/(3-ksi)^3;
K=(tt*(1+ksi))^0.5;