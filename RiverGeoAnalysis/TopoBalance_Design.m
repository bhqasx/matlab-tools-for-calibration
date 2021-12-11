function CS_balance=TopoBalance_Design(CS,CS_BlcPara,dz)
%design the topography of a reservoir when the channel reached a new
%balanced state

if nargin==2
    dz=0.1;
end

ncs1=size(CS,1);
ncs2=size(CS_BlcPara,1);
b=cell(ncs1,1);
CS_balance=struct('name',b,'x',b,'zb',b,'modi_info',b,'done',b);

for i=1:1:ncs1
    for j=1:1:ncs2
        if strcmp(CS(i).name,CS_BlcPara(j).name)
            CS_balance(i)=GetCS_Balance(CS(i),CS_BlcPara(j),dz);
        end
    end
end



%--------------------------------------------------------------------------
function CSnew=GetCS_Balance(CSold,CS_Para,dz)

CSnew.x=zeros(6,1);
CSnew.zb=zeros(6,1);
CSnew.name=CSold.name;
CSnew.modi_info='None';
CSnew.done=0;

if CS_Para.z_ch_bot<min(CSold.zb)   %如果设计槽底低于原始断面最低点
    CSnew.x=CSold.x;
    CSnew.zb=CSold.zb;
    CSnew.done=1;
    return;
end

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
    CSnew.done=1;
    return;
end

flag=0;
for i=CSold.npt:-1:2
    if (CSold.zb(i)>=CS_Para.z_ch_top)&&(CSold.zb(i-1)<CS_Para.z_ch_top)
        %槽顶高程线与原断面右交点
        flag=1;
        grad=abs((CSold.x(i)-CSold.x(i-1))/(CSold.zb(i)-CSold.zb(i-1)));
        xR=CSold.x(i)-(CSold.zb(i)-CS_Para.z_ch_top)*grad;
        break;
    end
end

if flag==0
    CSnew.x=CSold.x;
    CSnew.zb=CSold.zb;
    CSnew.modi_info='Done';
    return;
end

if (xR-xL)<CS_Para.B_ch_top
   %槽顶高程（造床流量下对应的水面高程）受限时，保持河槽面积不变升高槽顶高程
   CSnew.modi_info='NarrowCh';
   ztemp=CS_Para.z_ch_top;
   A_ch=(CS_Para.B_ch_bot+CS_Para.B_ch_top)*(CS_Para.z_ch_top-CS_Para.z_ch_bot)/2;
   Atemp=0.0;
   while Atemp<A_ch
      ztemp=ztemp+dz;
      for i=1:1:CSold.npt-1
          if (CSold.zb(i)>=ztemp)&&(CSold.zb(i+1)<ztemp)
              grad=abs((CSold.x(i+1)-CSold.x(i))/(CSold.zb(i+1)-CSold.zb(i)));
              xL=CSold.x(i)+(CSold.zb(i)-ztemp)*grad;
              break;
          end
      end
      
      for i=CSold.npt:-1:2
          if (CSold.zb(i)>=ztemp)&&(CSold.zb(i-1)<ztemp)
              grad=abs((CSold.x(i)-CSold.x(i-1))/(CSold.zb(i)-CSold.zb(i-1)));
              xR=CSold.x(i)-(CSold.zb(i)-ztemp)*grad;
              break;
          end
      end
      
      Btemp=(xR-xL);
      Atemp=(Btemp+CS_Para.B_ch_bot)*(ztemp-CS_Para.z_ch_bot)/2;
   end
   
   CS_Para.B_ch_top=Btemp;
   CS_Para.z_ch_top=ztemp;
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