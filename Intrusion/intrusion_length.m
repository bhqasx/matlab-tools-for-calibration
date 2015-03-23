

%--------------韩其为的计算方法----------------
lbd=0.03;             %沿程阻力系数
ksai_s=linspace(0.3,1,50);          %损失系数
J0=[4.387,7.634,7.459,3.679,1.974,1.548,1.741]*0.0001;     %底坡
h0=[20.4,18.8,19.3,26.9,36.2,33.4,34.8];
nline=size(ksai_s,2);
ndot=size(J0,2);

plot((1:ndot),[3700,2160,2300,5800,10100,10500,11000],'o');
for i=1:1:nline
    ksai=ksai_s(i);
    K1=(1+ksai)/(3-ksai);           %潜入前后深度比
    Fr=(2*(1-K1)/(1+ksai)/K1)^0.5;
    L=zeros(1,ndot);
    for j=1:1:ndot
        L(j)=(1+0.5*Fr^2)/(J0(j)+lbd/8*Fr^2)*K1*h0(j);    %倒灌长度
    end
    
    hold on;
    plot((1:ndot),L);
    hold off;
end


