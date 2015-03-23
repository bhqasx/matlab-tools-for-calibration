function hrs=PlotHr4(Fr,ksi_min,ksi_max)
%绘制异重流深度比和由此算出的倒灌流速中的系数

ksi=linspace(ksi_min,ksi_max,100);
hrs=zeros(1,100);
fai=zeros(1,100);

for ii=1:1:100
    hrs(ii)=depth_ratio4(Fr,ksi(ii));
    fai(ii)=Fr*hrs(ii)^1.5;
end

subplot(2,1,1);
plot(ksi,hrs);
subplot(2,1,2);
plot(ksi,fai);