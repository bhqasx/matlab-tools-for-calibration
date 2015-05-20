function csa=CS_average(hmin,zw,x_v)
%由各起点距处的垂线平均值计算断面平均值
%zw 水位；x_v 第一列起点距，第二列垂线平均值

global CS;
a=cell(1,1);
CS=struct('nodes',a,'x',a,'zb',a,'mc_fp',a,'accml_area',a);
%--------------------------------输入断面地形资料----------------------------
button=questdlg('请断面地形文件','Guide','Yes');
if ~strcmp(button,'Yes')
    return;
end
filename=uigetfile;
file_id=fopen(filename);

tline=fgetl(file_id);
tline=fgetl(file_id);
tline=fgetl(file_id);
rt=textscan(tline,'%f');
CS(1).nodes=rt{1}(1);
CS(1).x=zeros(CS(1).nodes,1);
CS(1).zb=zeros(CS(1).nodes,1);
tline=fgetl(file_id);

for jj=1:1:CS(1).nodes
    tline=fgetl(file_id);
    rt=textscan(tline,'%f');
    CS(1).x(jj)=rt{1}(2);
    CS(1).zb(jj)=rt{1}(3);
    CS(1).mc_fp(jj)=rt{1}(4);
end

%define flood plains and main channels
nmc=0;
for jj=1:1:CS(1).nodes-1
    if (CS(1).mc_fp(jj)~=0)&&(CS(1).mc_fp(jj+1)==0)
        nmc=nmc+1;                    %the number of main channel
        CS(1).nod_mc_l(nmc)=jj;          %the left node number of main channel
    elseif (CS(1).mc_fp(jj)==0)&&(CS(1).mc_fp(jj+1)~=0)
        CS(1).nod_mc_r(nmc)=jj+1;
    end
    CS(1).nmc=nmc;
end

%--------------------------------计算水深----------------------------
hhj=get_depth(hmin,zw);

csa=1;


%------------------------------------------subfunction---------------------------------
%---------------------------------计算断面各结点水深------------------------------------
function hhj=get_depth(h_min,z)
%calculate water depth at each node

global CS;
zb_j=CS(1).zb;
hhj=zeros(1,CS(1).nodes);

%water depth in main channel
for k=1:1:CS(1).nmc
    %depth in main channel
    kl=CS(1).nod_mc_l(k)+1;
    kr=CS(1).nod_mc_r(k)-1;
    for n=kl:1:kr
        if (CS(1).mc_fp(n)==0)&&(z>(zb_j(n)+h_min))
            hhj(n)=z-zb_j(n);
        else
            hhj(n)=0;
        end
    end
    
    %the left floodplain of the fisrt main channel
    if k==1
        kl=1;
        kr=CS(1).nod_mc_l(k);
        for n=kr:-1:kl
            if (CS(1).mc_fp(n)~=0)&&(z>(zb_j(n)+h_min))
                hhj(n)=z-zb_j(n);
            else
                hhj(1:n)=0;
                break;
            end
        end
    end
    %the right floodplain of the right main channel
    if k==CS(1).nmc
        kl=CS(1).nod_mc_r(k);
        kr=CS(1).nodes;
        for n=kl:1:kr
             if (CS(1).mc_fp(n)~=0)&&(z>(zb_j(n)+h_min))
                hhj(n)=z-zb_j(n);
            else
                hhj(n:kr)=0;
                break;
             end     
        end
    end
    %floodplain between main channels
    if k>1
        kl=CS(1).nod_mc_r(k-1);
        kr=CS(1).nod_mc_l(k);
        for n=kl:1:kr
             if (CS(1).mc_fp(n)~=0)&&(z>(zb_j(n)+h_min))
                hhj(n)=z-zb_j(n);
             else
                hhj(n:kr)=0;
                break;
             end
        end
        for n=kr:-1:kl
             if (CS(1).mc_fp(n)~=0)&&(z>(zb_j(n)+h_min))
                hhj(n)=z-zb_j(n);
             else
                break;
             end
        end
    end
end