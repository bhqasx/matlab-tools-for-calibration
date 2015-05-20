function ss=line_average(dd)
%由线上各点数据求出线上平均值
%dd应为两列
npt=size(dd,1);
weight=zeros(npt-1,1);
vds=zeros(npt-1,1);
for i=2:1:npt
    weight(i-1)=dd(i,1)-dd(i-1,1);
    vds(i-1)=0.5*(dd(i-1,2)+dd(i,2));
end

ss=sum(weight.*vds)/sum(weight);