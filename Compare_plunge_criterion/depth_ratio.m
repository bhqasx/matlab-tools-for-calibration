function hr=depth_ratio(Fr,ksi)
%用动量方程和伯努利方程计算倒灌前后的异重流厚度比
aa=2*Fr^2+1;
bb=-(2*Fr^2*(1+ksi)+4);
cc=3;

hr=roots([aa,bb,cc]);
