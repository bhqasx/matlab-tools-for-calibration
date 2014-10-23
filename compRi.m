function Ri=compRi(u,h,S)
%º∆À„Richardson ˝
%u=velocity, S=sedi concentration(kg/m3)

rou_s=2650;
rou_m=S+(1-S/rou_s)*1000;
equi_g=(1-1000/rou_m)*9.8;

Ri=u^2/equi_g/h;
