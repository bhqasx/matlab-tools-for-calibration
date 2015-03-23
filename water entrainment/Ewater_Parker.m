function Ewater_Parker(Ri_max)

Ri=linspace(0,Ri_max,100);
ec=0.00153./(0.0204+Ri);             %Parker's formula
plot(Ri,ec);
