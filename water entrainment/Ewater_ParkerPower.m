function [Ri,ec]=Ewater_ParkerPower(Ri_max)

Ri=linspace(0.1,Ri_max,100);
ec=zeros(size(Ri));
for i=1:1:100
    ec(i)=0.0028/Ri(i)^1.2;
end

if (nargout~=2)
    plot(Ri,ec);
end