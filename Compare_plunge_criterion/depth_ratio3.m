function hr=depth_ratio3(Fr)
%���������������˶���������ȫˮ������������ȱ�

aa=2*Fr^2;
bb=-(2*Fr^2+1);
cc=0;
dd=1;

rts=roots([aa,bb,cc,dd]);

for ii=1:1:3
    if (rts(ii)<1)&&(rts(ii)>0)
        hr=rts(ii);
    end
end
