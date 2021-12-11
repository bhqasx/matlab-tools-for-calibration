function [CS] = create1Dtopo(dist,B,zb)
%CREATE1DTOPO 此处显示有关此函数的摘要
%   此处显示详细说明
NPT=5;

ncs=numel(dist);
b=cell(1,ncs);
CS=struct('npt',b,'x',b,'zb',b,'name',b,'kchfp',b,'dist',b);
for i=1:1:ncs
    CS(i).name=['CS',num2str(i)];
    CS(i).npt=NPT;
    CS(i).x=linspace(0,B(i),CS(i).npt);
    CS(i).zb=zb(i)*ones(CS(i).npt,1);
    CS(i).kchfp=zeros(CS(i).npt,1);
    CS(i).kchfp(1)=1;
    CS(i).kchfp(end)=1;
    CS(i).dist=dist(i)*1000;   %km to m
end

end

