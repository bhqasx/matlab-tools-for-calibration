function hr=depth_ratio(Fr,ksi)
%�ö������̺Ͳ�Ŭ�����̼��㵹��ǰ�����������ȱ�
aa=2*Fr^2+1;
bb=-(2*Fr^2*(1+ksi)+4);
cc=3;

hr=roots([aa,bb,cc]);
