function hrs=PlotHr(fr_min,fr_max)
%绘制异重流深度比和由此算出的倒灌流速中的系数

Fr=linspace(fr_min,fr_max,100);
hrs=zeros(1,100);
fai=zeros(1,100);

for ii=1:1:100
    hrs(ii)=depth_ratio3(Fr(ii));
    fai(ii)=Fr(ii)*hrs(ii)^1.5;
end

subplot(2,1,1);
plot(Fr,hrs);
subplot(2,1,2);
plot(Fr,fai);

