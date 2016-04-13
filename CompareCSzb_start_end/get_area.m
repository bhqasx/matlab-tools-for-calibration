function [A,B]=get_area(CS1,zw)
%计算一定水位下的面积

%parse structure variable
n_nod=CS1.npt;
kchfp=CS1.kchfp;
zb_j=CS1.zb;
x=CS1.x;
%define flood plains and main channels
nmc=0;
for j=1:1:n_nod-1
    if (kchfp(j)~=0)&&(kchfp(j+1)==0)
        nmc=nmc+1;                    %the number of main channel
        nod_mc_l(nmc)=j;          %the left node number of main channel
    elseif (kchfp(j)==0)&&(kchfp(j+1)~=0)
        nod_mc_r(nmc)=j+1;
    end
end

%calculate the area
h_min=0.01;
hhj=get_depth(zw, h_min);
A=0;
B=0;
for k=1:1:n_nod-1
    dx=x(k+1)-x(k);    
    if (hhj(k)>h_min)&&(hhj(k+1)>h_min)
        db=dx;        %the width of sub cross-section
        da=db*(hhj(k)+hhj(k+1))/2;
    elseif (hhj(k)<=h_min)&&(hhj(k+1)<=h_min)
        db=0;
        da=0;
    elseif (hhj(k)<=h_min)&&(hhj(k+1)>h_min)
        hj1=hhj(k+1);
        hj=zb_j(k)-zb_j(k+1)-hj1;
        if hj>=0
            db=(hj1/(hj1+hj))*dx;
        else
            db=dx;
        end
        da=db*hj1*0.5;
    else     %there's water at point k but no water at point k+1
        hj=hhj(k);
        hj1=zb_j(k+1)-zb_j(k)-hj;
        if hj1>=0
            db=(hj/(hj+hj1))*dx;
        else
            db=dx;
        end
        da=db*hj*0.5;
    end
    
    A=A+da;
    B=B+db;
end


%---------------------------------nested function--------------------------------
%-------------------------------------------------------------------------------------
function hhj=get_depth(z, h_min)
%calculate water depth at each node

hhj=zeros(1,n_nod);
%water depth in main channel
for imc=1:1:nmc
    %depth in main channel
    kl=nod_mc_l(imc)+1;
    kr=nod_mc_r(imc)-1;
    for nd=kl:1:kr
        if (kchfp(nd)==0)&&(z>(zb_j(nd)+h_min))
            hhj(nd)=z-zb_j(nd);
        else
            hhj(nd)=0;
        end
    end
    
    %the left floodplain of the fisrt main channel
    if imc==1
        kl=1;
        kr=nod_mc_l(imc);
        for nd=kr:-1:kl
            if (kchfp(nd)~=0)&&(z>(zb_j(nd)+h_min))
                hhj(nd)=z-zb_j(nd);
            else
                hhj(1:nd)=0;
                break;
            end
        end
    end
    %the right floodplain of the right main channel
    if imc==nmc
        kl=nod_mc_r(imc);
        kr=n_nod;
        for nd=kl:1:kr
             if (kchfp(nd)~=0)&&(z>(zb_j(nd)+h_min))
                hhj(nd)=z-zb_j(nd);
            else
                hhj(nd:kr)=0;
                break;
             end     
        end
    end
    %floodplain between main channels
    if imc>1
        kl=nod_mc_r(imc-1);
        kr=nod_mc_l(imc);
        for nd=kl:1:kr
             if (kchfp(nd)~=0)&&(z>(zb_j(nd)+h_min))
                hhj(nd)=z-zb_j(nd);
             else
                hhj(nd:kr)=0;
                break;
             end
        end
        for nd=kr:-1:kl
             if (kchfp(nd)~=0)&&(z>(zb_j(nd)+h_min))
                hhj(nd)=z-zb_j(nd);
             else
                break;
             end
        end
    end
end
end

end

