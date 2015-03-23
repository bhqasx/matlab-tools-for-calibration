function fai=Plot_fai_vel(Fr,ksi_min,ksi_max);
%ֻ�ò�Ŭ�����̣������н����ٵĵ������������ٹ�ʽ�е�ϵ��

ksi=linspace(ksi_min,ksi_max,100);
hr=1./(1+(1+ksi)/2*Fr^2);
fai=Fr*hr.^0.5;

subplot(2,1,1);
plot(ksi,hr);
subplot(2,1,2);
plot(ksi,fai);