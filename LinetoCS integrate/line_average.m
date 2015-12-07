function ss=line_average(dd)
%由线上各点数据求出线上平均值
%dd至少为两列
npt=size(dd,1);
nseries=size(dd,2)-1;
weight=zeros(1,npt-1);
vds=zeros(npt-1,nseries);
for i=2:1:npt
    weight(i-1)=dd(i,1)-dd(i-1,1);
    vds(i-1,:)=0.5*(dd(i-1,2:end)+dd(i,2:end));
end

ss=weight*vds/sum(weight);