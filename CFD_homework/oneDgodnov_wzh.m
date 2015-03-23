% Code for 2-nd order Godunov type scheme for 1D shallow water 

global dx;
global zb;
global L;
global ncase; global t;
zb=0;
g=9.81;
% -----------ask for user's input------------ 
ncase=input(['input the num for test cases:','\n','1.Still water test','\n','2.Tidal wave over a varying bed',...
    '\n','3.Dam break','\n','4.Tidal Wave over steps','\n','You choose:']);
if (ncase~=1)&(ncase~=2)&(ncase~=3)&(ncase~=4)
    disp('illigal input')
    return
end
%-------------- initalize--------------------
t=0;
[x,U]=ini_zq(ncase);
U_ini=U;
M=size(x);
M=M(1,2);
subplot(2,1,1);         %plot zb and z
plot(x,zb,'b-','LineWidth',2);
hold on;
plot(x,U(1,:),'r-');
title(num2str(t));
ymax=max(U(1,:))+5;
axis([0,L,0,ymax]);

subplot(2,1,2);                  %plot velocity
plot(x,U(2,:)./(U(1,:)-zb),'g-');   
pause(0.1);
switch ncase
    case 1
        tout=5000;
        dt=10;
    case 2
        tout=7552.13;
        dt=10;
    case 3
        tout=5;
        dt=0.02;
    case 4
        tout=10800;
        dt=0.45;
end
%------------------------------------------------------
while t<tout
    t=t+dt;
    %------------1st step of RK2-----------------------
    UeL=LR(1,U);                  %construct LR state
    UeR=LR(2,U);
    UeR(:,end)=UeL(:,end);      
    zb_diag=diag(0.5*ones(1,M))+diag(0.5*ones(1,M-1),1);
    zbf=(zb_diag*zb.').';
    zbf(1,end)=zb(1,end);            
    Fe=F_cal(UeL,UeR,zbf);
    Fw=circshift(Fe,[0,1]);
    switch ncase
        case 1
            Fe(1,end)=0; 
            Fe(2,end)=0.5*g*(U(1,end)^2-2*U(1,end)*zb(end));
            Fw(1,1)=0; 
            Fw(2,1)=0.5*g*(U(1,1)^2-2*U(1,1)*zb(1));
        case 2
            h_bd=64.5-zb(1)-4*sin(pi*(4*t/86400+0.5));
            Fw(1,1)=h_bd*(-L)*pi/5400/h_bd*cos(pi*(4*t/86400+0.5));
            z_bd=h_bd+zb(1);
            Fw(2,1)=Fw(1,1)^2/h_bd+0.5*g*(z_bd^2-2*z_bd*zb(1));
            Fe(1,end)=0; 
            Fe(2,end)=0.5*g*(U(1,end)^2-2*U(1,end)*zb(end));
        case 3
            Fw(1,1)=U(2,1);
            Fw(2,1)=U(2,1)^2/(U(1,1)-zb(1))+0.5*g*(U(1,1)^2-2*U(1,1)*zb(1));
        case 4
            h_bd=20-4*sin(pi*(4*t/86400+0.5))-zb(1);
            z_bd=h_bd+zb(1);
            Fw(1,1)=U(2,1);
            Fw(2,1)=U(2,1)^2/h_bd+0.5*g*(z_bd^2-2*z_bd*zb(1));
            Fe(1,end)=0;
            Fe(2,end)=0.5*g*(U(1,end)^2-2*U(1,end)*zb(end));
    end
    
        %source terms
    s(1,1:M)=0;
    zb_delta=((eye(M)+diag(-1*ones(1,M-1),-1))*zbf.').';
    zb_delta(1)=zbf(1)-zb(1);
    s(2,1:M)=-g*U(1,:).*(zb_delta/dx);
        %new values
    km=-(Fe-Fw)/dx+s;
    Um=U+dt*km;
    %-----------2nd step of RK2---------------------------
    UeL=LR(1,Um);
    UeR=LR(2,Um);
    UeR(:,end)=UeL(:,end);
    Fe=F_cal(UeL,UeR,zbf);
    Fw=circshift(Fe,[0,1]);
    switch ncase
        case 1
            Fe(1,end)=0; 
            Fe(2,end)=0.5*g*(Um(1,end)^2-2*Um(1,end)*zb(end));
            Fw(1,1)=0; 
            Fw(2,1)=0.5*g*(Um(1,1)^2-2*Um(1,1)*zb(1));
        case 2
            h_bd=64.5-zb(1)-4*sin(pi*(4*(t+dt)/86400+0.5));
            Fw(1,1)=h_bd*(-L)*pi/5400/h_bd*cos(pi*(4*(t+dt)/86400+0.5));
            z_bd=h_bd+zb(1);
            Fw(2,1)=Fw(1,1)^2/h_bd+0.5*g*(z_bd^2-2*z_bd*zb(1));
            Fe(1,end)=0; 
            Fe(2,end)=0.5*g*(Um(1,end)^2-2*Um(1,end)*zb(end));
        case 3
            Fw(1,1)=Um(2,1);
            Fw(2,1)=Um(2,1)^2/(Um(1,1)-zb(1))+0.5*g*(Um(1,1)^2-2*Um(1,1)*zb(1));
        case 4
            h_bd=20-4*sin(pi*(4*(t+dt)/86400+0.5))-zb(1);
            z_bd=h_bd+zb(1);
            Fw(1,1)=Um(2,1);
            Fw(2,1)=Um(2,1)^2/h_bd+0.5*g*(z_bd^2-2*z_bd*zb(1));
            Fe(1,end)=0;
            Fe(2,end)=0.5*g*(Um(1,end)^2-2*Um(1,end)*zb(end));
    end;
        %source terms
    s(1,1:M)=0;
    s(2,1:M)=-g*Um(1,:).*(zb_delta/dx);
        %update
        U=U+0.5*dt*(km-(Fe-Fw)/dx+s);
    %------------ plot resluts------------------------------
    subplot(2,1,1);
    hold off;
    plot(x,zb,'b-','LineWidth',2);
    hold on;
    plot(x,U(1,:),'r-');
    title(num2str(t));
    axis([0,L,0,ymax]);
    
    subplot(2,1,2);
    hold off;
    plot(x,U(2,:)./(U(1,:)-zb),'g-');
    
    pause(0.01);

end
        
    
    

