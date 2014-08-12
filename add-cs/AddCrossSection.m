clear all;
%load cs profile
load('cs1');
load('cs2');

npt1=size(cs1,1);
npt2=size(cs2,1);
npt=round((npt1+npt2)/2)+2;           %nodes of the added cs 

prompt={'Input the distance of CS1','Input the distance of CS2'};
dlg_ans=inputdlg(prompt);
dist1=str2double(dlg_ans{1});
dist2=str2double(dlg_ans{2});

zbmin1=min(cs1(:,3));
zbmin2=min(cs2(:,3));

xcs=(dist1+dist2)/2;      %添加断面的位置
zbot=(zbmin1+zbmin2)/2;       %添加断面的底部高程

prompt={'the bed elevation of the added cs is:','Input hmin'};
dlg_ans=inputdlg(prompt,'Input',1,{num2str(zbot),'0.01'});
zbot=str2double(dlg_ans{1});
hmin=str2double(dlg_ans{2});

prompt={'Input the low level','Input the high level'};
dlg_ans=inputdlg(prompt);
z1=str2double(dlg_ans{1});
z2=str2double(dlg_ans{2});
h1=z1-zbot;
h2=z2-zbot;

Aa=get_area(z1,cs1(:,2:4),hmin);
Ab=get_area(z1,cs2(:,2:4),hmin);
A1=(Aa+Ab)/2;

Aa=get_area(z2,cs1(:,2:4),hmin);
Ab=get_area(z2,cs2(:,2:4),hmin);
A2=(Aa+Ab)/2;

tg=h2*h1*(h1-h2)/(A1*h2-A2*h1);        %tan of the side slope
B_bot=(A2-h2^2/tg)/h2;

B1=2*h1/tg+B_bot;                %width at low level
B2=2*h2/tg+B_bot;                %width at high level

%-----------------design the added cross section-----------------
dx=B2/(npt-3);
x=(1:npt)*dx;
zb=zeros(size(x));
zb(1)=z2+tg*dx;

%左岸坡
for ii=2:1:npt
    zb(ii)=zb(ii-1)-tg*dx;
    if zb(ii)<=zbot
        break;
    end
end

i_L_corner=ii;
i_R_corner=npt-ii-1;
%底部
for ii=i_L_corner:1:i_R_corner
    zb(ii)=zbot;
end

%右岸坡
for ii=i_R_corner+1:1:npt
    zb(ii)=zb(ii-1)+tg*dx;
end

plot(x,zb,'d-');
cs_added=zeros(npt,4);
cs_added(:,1)=(1:npt).';
cs_added(:,2)=x;
cs_added(:,3)=zb;
cs_added(1,4)=1;
cs_added(npt,4)=1;

disp('location:');
disp(num2str((dist1+dist2)/2));
disp('surface width at low level:');
disp(num2str(B1));
disp('surface width at high level:');
disp(num2str(B2));

