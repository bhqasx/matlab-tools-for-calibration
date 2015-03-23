function [x,U]=ini_zq(ncase)
global dx;
global zb;
global L;
switch ncase
    case 1           %Still water test
        L=14000; M=50;
        dx=L/M;
        for i=1:1:M
            x(i)=dx/2+(i-1)*dx;
            zb(i)=10+40*x(i)/L+10*sin(pi*(4*x(i)/L-1/2));
            U(1,i)=65;
            U(2,i)=0;
        end
    case 2        %Tidal wave over a varying bed
        L=14000; M=50;
        dx=L/M;
        for i=1:1:M
            x(i)=dx/2+(i-1)*dx;
            zb(i)=10+40*x(i)/L+10*sin(pi*(4*x(i)/L-1/2));
            h(i)=64.5-zb(i)-4*sin(pi*0.5);
            u(i)=(x(i)-L)*pi/5400/h(i)*cos(pi*0.5);
            U(1,i)=h(i)+zb(i);
            U(2,i)=h(i)*u(i);
        end   
    case 3      %Dam Break
        L=50; M=200;
        dx=L/M;
        for i=1:1:M
            x(i)=dx/2+(i-1)*dx;
            zb(i)=0.5;
            if x(i)<25;
                U(1,i)=1.5;
            else
                U(1,i)=0.6;
            end
            U(2,i)=0;
        end
    case 4      %Tidal wave over steps
        L=1500; M=200;
        dx=L/M;
        for i=1:1:M
            x(i)=dx/2+(i-1)*dx;
            if abs(x(i)-750)<=185.5
                zb(i)=8.5;
            else
                zb(i)=0.5;
            end
            h(i)=20-zb(i)-4*sin(pi*0.5);
            u(i)=(x(i)-L)*pi/5400/h(i)*cos(pi*0.5);
            U(1,i)=h(i)+zb(i);
            U(2,i)=h(i)*u(i);
        end
            
end
return
        
        
       

