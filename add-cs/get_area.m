function A=get_area(z,ori_prof,h_min)
%计算一定水位下的面积

nmc=0;
%define flood plains and main channels
n_nod=size(ori_prof,1);
for j=1:1:n_nod-1
    if (ori_prof(j,3)~=0)&&(ori_prof(j+1,3)==0)
        nmc=nmc+1;                    %the number of main channel
        nod_mc_l(nmc)=j;          %the left node number of main channel
    elseif (ori_prof(j,3)==0)&&(ori_prof(j+1,3)~=0)
        nod_mc_r(nmc)=j+1;
    end
end

%calculate the area
hhj=get_depth(z, ori_prof, nmc, nod_mc_l, nod_mc_r, h_min);
A=0;
for k=1:1:n_nod-1
    dx=ori_prof(k+1,1)-ori_prof(k,1);    
    if (hhj(k)>h_min)&&(hhj(k+1)>h_min)
        db=dx;        %the width of sub cross-section
        da=db*(hhj(k)+hhj(k+1))/2;
    elseif (hhj(k)<=h_min)&&(hhj(k+1)<=h_min)
        db=0;
        da=0;
    elseif (hhj(k)<=h_min)&&(hhj(k+1)>h_min)
        hj1=hhj(k+1);
        hj=ori_prof(k,2)-ori_prof(k+1,2)-hj1;
        if hj>=0
            db=(hj1/(hj1+hj))*dx;
        else
            db=dx;
        end
        da=db*hj1*0.5;
    else     %there's water at point k but no water at point k+1
        hj=hhj(k);
        hj1=ori_prof(k+1,2)-ori_prof(k,2)-hj;
        if hj1>=0
            db=(hj/(hj+hj1))*dx;
        else
            db=dx;
        end
        da=db*hj*0.5;
    end
    
    A=A+da;
end