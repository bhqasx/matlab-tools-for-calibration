function hr=depth_ratio4(Fr,ksi)
%�ò�Ŭ����������������������ȱ�
aa=Fr^2;
bb=0;
cc=-2-(1+ksi)*Fr^2;
dd=2;

rts=roots([aa,bb,cc,dd]);

for ii=1:1:3
    if (rts(ii)<1)&&(rts(ii)>0)
        hr=rts(ii);
    end
end