function [Ri,ec]=Ewater_EllisonTurner(Ri_max)

Ri=linspace(0.1,Ri_max,100);
ec=zeros(size(Ri));
for i=1:1:100
    if (Ri(i)<0.6)
        ec(i)=(0.06-0.1*Ri(i))/(1+5*Ri(i));
    else
        ec(i)=(0.06-0.1*Ri(i))/(32*Ri(i)-2);
    end
end

if (nargout~=2)
    plot(Ri,ec);
end