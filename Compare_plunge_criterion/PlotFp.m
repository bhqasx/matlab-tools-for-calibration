function FP1=PlotFp(Fr)
%比较不同方法计算的潜入点弗汝德数
% clear all;
Sv=linspace(0.001,0.2,100);
FP1=zeros(size(Sv));      %存储李书霞公式的结果
FP2=zeros(size(Sv));       %存储新方法的结果

for ii=1:1:size(Sv,2)
    FP1(ii)=get_Fr_plunge(Sv(ii));
end
plot(Sv,FP1,'b-');

if nargin==0
    retun;
end

for jj=1:1:size(Fr,2)
    for ii=1:1:size(Sv,2)
        FP2(ii)=get_Fr_plunge(Sv(ii),Fr(jj));
    end
    hold on;
    plot(Sv,FP2,'r-');
end



