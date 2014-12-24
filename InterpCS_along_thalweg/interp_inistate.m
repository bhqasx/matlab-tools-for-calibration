function B=interp_inistate(A)
%对初始条件进行插值

rA=size(A,1);             %原始断面个数
rB=2*rA-1;

B=zeros(rB,size(A,2));
for ii=1:1:rA-1
    B(2*ii-1,1)=2*ii-1;
    B(2*ii-1,2:end)=A(ii,2:end);
    
    B(2*ii,1)=2*ii;
    B(2*ii,2:end)=(A(ii,2:end)+A(ii+1,2:end))/2;
end
B(rB,1)=rB;
B(rB,2:end)=A(rA,2:end);