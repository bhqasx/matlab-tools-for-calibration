function [Vol, A]=getVolAtZ(level,CS,dist)
%计算水位库容曲线
%the unit of dist is m.  
%使用前最好将CS中的kchfp域全部改为只有首尾两个数为1，因为get_area计算的是过水面积

nlv=numel(level);
Vol=zeros(nlv,1);
A=zeros(nlv,1);   %每个高程下的（水平）水面面积
ncs=numel(CS);
vol2cs=zeros(ncs-1,1);
for i=1:1:nlv
   z=level(i);
   for ics=1:1:ncs-1
        %计算每两个断面间的体积
        [a1, b1]=get_area(CS(ics),z);
        [a2, b2]=get_area(CS(ics+1),z);
        d2cs=abs(dist(ics)-dist(ics+1));
        vol2cs(ics)=(a1+a2+sqrt(a1*a2))*d2cs/3.0;
        area2cs(ics)=(b1+b2)*d2cs/2;
   end
   Vol(i)=sum(vol2cs);
   A(i)=sum(area2cs);
end
