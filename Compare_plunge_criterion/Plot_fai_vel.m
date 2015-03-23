function fai=Plot_fai_vel(Fr,ksi_min,ksi_max);
%只用伯努利方程，忽略行进流速的到的异重流流速公式中的系数

ksi=linspace(ksi_min,ksi_max,100);
hr=1./(1+(1+ksi)/2*Fr^2);
fai=Fr*hr.^0.5;

subplot(2,1,1);
plot(ksi,hr);
subplot(2,1,2);
plot(ksi,fai);