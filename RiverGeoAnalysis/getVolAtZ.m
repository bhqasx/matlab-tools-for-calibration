function [Vol, A]=getVolAtZ(level,CS,dist)
%����ˮλ��������
%the unit of dist is m.  
%ʹ��ǰ��ý�CS�е�kchfp��ȫ����Ϊֻ����β������Ϊ1����Ϊget_area������ǹ�ˮ���

nlv=numel(level);
Vol=zeros(nlv,1);
A=zeros(nlv,1);   %ÿ���߳��µģ�ˮƽ��ˮ�����
ncs=numel(CS);
vol2cs=zeros(ncs-1,1);
for i=1:1:nlv
   z=level(i);
   for ics=1:1:ncs-1
        %����ÿ�������������
        [a1, b1]=get_area(CS(ics),z);
        [a2, b2]=get_area(CS(ics+1),z);
        d2cs=abs(dist(ics)-dist(ics+1));
        vol2cs(ics)=(a1+a2+sqrt(a1*a2))*d2cs/3.0;
        area2cs(ics)=(b1+b2)*d2cs/2;
   end
   Vol(i)=sum(vol2cs);
   A(i)=sum(area2cs);
end
