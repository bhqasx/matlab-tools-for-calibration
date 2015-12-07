function ss=line_average(dd)
%�����ϸ��������������ƽ��ֵ
%dd����Ϊ����
npt=size(dd,1);
nseries=size(dd,2)-1;
weight=zeros(1,npt-1);
vds=zeros(npt-1,nseries);
for i=2:1:npt
    weight(i-1)=dd(i,1)-dd(i-1,1);
    vds(i-1,:)=0.5*(dd(i-1,2:end)+dd(i,2:end));
end

ss=weight*vds/sum(weight);