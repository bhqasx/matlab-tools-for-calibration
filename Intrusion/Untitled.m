%L/h0Ó°ÏìJÔÊÐíµÄ·¶Î§

slope=0.00935;
ltoh=1.3;
ksi=0.8;

a=(16*ksi^2-64*ksi+64)*ltoh^2;
b=(12*3^0.5*ksi^2-24*3^0.5*ksi-36*3^0.5)*ltoh^2-(48*ksi^2-144*ksi+96)*ltoh;
c=36*ksi^2-72*ksi+36;

k=(6-6*ksi)+(4*ksi-8)*slope*ltoh+sqrt(a*slope^2+b*slope+c);
k=k/(18-6*ksi);
qk=(1-k-slope*ltoh)*sqrt(2*k/(1+ksi))