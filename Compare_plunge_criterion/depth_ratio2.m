function hr=depth_ratio2(ksi)
%��������������Ŭ�������������õ�����������ȱ�

aa=1;
bb=-3;
cc=3-ksi;
dd=-1-ksi;

hr=roots([aa,bb,cc,dd]);