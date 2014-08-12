function hhj=get_depth(z, ori_prof,nmc,nod_mc_l,nod_mc_r,h_min)
%calculate water depth at each node

n_nod=size(ori_prof,1);           %number of nodes
zb_j=ori_prof(:,2);
hhj=zeros(1,n_nod);

%water depth in main channel
for k=1:1:nmc
    %depth in main channel
    kl=nod_mc_l(k)+1;
    kr=nod_mc_r(k)-1;
    for n=kl:1:kr
        if (ori_prof(n,3)==0)&&(z>(zb_j(n)+h_min))
            hhj(n)=z-zb_j(n);
        else
            hhj(n)=0;
        end
    end
    
    %the left floodplain of the fisrt main channel
    if k==1
        kl=1;
        kr=nod_mc_l(k);
        for n=kr:-1:kl
            if (ori_prof(n,3)~=0)&&(z>(zb_j(n)+h_min))
                hhj(n)=z-zb_j(n);
            else
                hhj(1:n)=0;
                break;
            end
        end
    end
    %the right floodplain of the right main channel
    if k==nmc
        kl=nod_mc_r(k);
        kr=n_nod;
        for n=kl:1:kr
             if (ori_prof(n,3)~=0)&&(z>(zb_j(n)+h_min))
                hhj(n)=z-zb_j(n);
            else
                hhj(n:kr)=0;
                break;
             end     
        end
    end
    %floodplain between main channels
    if k>1
        kl=nod_mc_r(k-1);
        kr=nod_mc_l(k);
        for n=kl:1:kr
             if (ori_prof(n,3)~=0)&&(z>(zb_j(n)+h_min))
                hhj(n)=z-zb_j(n);
             else
                hhj(n:kr)=0;
                break;
             end
        end
        for n=kr:-1:kl
             if (ori_prof(n,3)~=0)&&(z>(zb_j(n)+h_min))
                hhj(n)=z-zb_j(n);
             else
                break;
             end
        end
    end
end
   