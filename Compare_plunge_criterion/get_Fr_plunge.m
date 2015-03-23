function Fp=get_Fr_plunge(Sv,F)
%F为头部弗汝德数，理论值为2^(1/2), Hupper & Simpson(1980)实验值为1.19

if Sv>0.6
    warndlg('Sv is too big');
    return;
end

rou_c=1000;            %清水密度
rou_s=2650;            %泥沙密度
rou_m=Sv*rou_s+(1-Sv)*rou_c;
ita_g=(rou_m-rou_c)/rou_m;       
if nargin==1      %使用李书霞的公式计算
    Fp=0.49*Sv^0.385;
    Fp=Fp*ita_g^(-1/2);       %转换为密度弗汝德数
    return;
end

%利用相似解成果计算

aa=rou_m*ita_g*F^2;
bb=0.5*rou_c-0.5*rou_m-rou_m*ita_g*F^2;
cc=0;
dd=0.5*(rou_m-rou_c);
% aa=rou_m*ita_g*F^2;
% bb=rou_c-0.5*rou_m-rou_m*ita_g*F^2;
% cc=-rou_c;
% dd=0.5*rou_m;

ans_poly=roots([aa,bb,cc,dd]);
ans_poly=ans_poly.^1.5*F;

for ii=1:1:3
    if isreal(ans_poly(ii))
        if (ans_poly(ii)<1)&&(ans_poly(ii)>0)
            Fp=ans_poly(ii);
        end
    end
end


