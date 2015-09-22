function [Ri,ec]=Ewater_Parker(Ri_max)

Ri=linspace(0.1,Ri_max,100);
ec=0.00153./(0.0204+Ri);             %Parker's formula
if (nargout~=2)
    plot(Ri,ec);
end
