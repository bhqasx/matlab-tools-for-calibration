function CS_balance=TopoBalance_Design(CS,CS_BlcPara)
%design the topography of a reservoir when the channel reached a new
%balanced state

ncs1=size(CS,1);
ncs2=size(CS_BlcPara,1);
b=cell(ncs1,1);
CS_balance=struct('name',b,'x',b,'zb',b);

for i=1:1:ncs1
    for j=1:1:ncs2
        if strcmp(CS(i).name,CS_BlcPara(j).name)
            CS_balance(i)=GetCS_Balance(CS(i),CS_BlcPara(j));
        end
    end
end



%--------------------------------------------------------------------------
function CSnew=GetCS_Balance(CSold,CS_Para)

CSnew.x=zeros(6,1);
CSnew.zb=zeros(6,1);
CSnew.name=CSold.name;

flag=0;
for i=1:1:CSold.npt-1
    if (CSold.zb(i)>=CS_Para.z_ch_top)&&(CSold.zb(i+1)<CS_Para.z_ch_top)
        %槽顶高程线与原断面左交点
        flag=1;
        grad=abs((CSold.x(i+1)-CSold.x(i))/(CSold.zb(i+1)-CSold.zb(i)));
        xL=CSold.x(i)+(CSold.zb(i)-CS_Para.z_ch_top)*grad;
        break;
    end
end

if flag==0;
    CSnew.x=CSold.x;
    CSnew.zb=CSold.zb;
    return;
end

flag=0;
for i=CSold.npt:-1:2
    if (CSold.zb(i)>=CS_Para.z_ch_top)&&(CSold.zb(i-1)<CS_Para.z_ch_top)
        %槽顶高程线与原断面右交点
        flag=1;
        grad=abs((CSold.x(i)-CSold.x(i-1))/(CSold.zb(i)-CSold.zb(i-1)));
        xR=CSold.x(i)-(CSold.zb(i)-CS_Para.z_ch_top)*grad;
    end
end

if flag==0
    CSnew.x=CSold.x;
    CSnew.zb=CSold.zb;
    return;
end

xc=(xL+xR)/2.0;
CSnew.x(1)=xc-CS_Para.B_fp/2;
CSnew.zb(1)=CS_Para.z_fp;
CSnew.x(6)=xc+CS_Para.B_fp/2;
CSnew.zb(6)=CS_Para.z_fp;

CSnew.x(2)=xc-CS_Para.B_ch_top/2;
CSnew.zb(2)=CS_Para.z_ch_top;
CSnew.x(5)=xc+CS_Para.B_ch_top/2;
CSnew.zb(5)=CS_Para.z_ch_top;

CSnew.x(3)=xc-CS_Para.B_ch_bot/2;
CSnew.zb(3)=CS_Para.z_ch_bot;
CSnew.x(4)=xc+CS_Para.B_ch_bot/2;
CSnew.zb(4)=CS_Para.z_ch_bot;