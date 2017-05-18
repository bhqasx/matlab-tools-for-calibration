function pp2=ChangeGradationDiam(diam1,pp1,diam2)
%由一组粒径下的级配转换为另一组粒径下的级配

nrow=size(pp1,1);
ndm2=size(diam2,2);
pp2=zeros(nrow,ndm2);
for i=1:1:nrow
    for j=1:1:ndm2
        pp2(i,j)=GradationInterp(diam1,pp1(i,:),diam2(j));
    end
end


function yi=GradationInterp(xx,yy,xi)

nx=size(xx,2);
if nx~=size(yy,2);
    disp('sizes do not match');
    pause;
end

for i=1:1:nx
    if i==1 
       if (xi<xx(i))
          disp('beyond the lower limit');
          pause;
       end
    elseif (xi>=xx(i-1))&&(xi<xx(i))
       grad=(yy(i)-yy(i-1))/(xx(i)-xx(i-1));
       yi=yy(i-1)+(xi-xx(i-1))*grad;
       return;
    end
end

%xi大于xx中的最大值
if i==nx
   yi=yy(nx); 
end