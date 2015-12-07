%秦文凯公式流量系数随ksi的变化
ksi=linspace(0,1,70);
K=zeros(size(ksi));
for i=1:1:size(ksi,2);
    rf=solve(['(2-k1)^2*(1+',num2str(ksi(i)),')/4/k1^2-(1-k1)^2-2']);
    K(i)=sqrt((1-double(rf(1)))^3);
end