function hours = time_h_LYR(vdate,vtime,vmin)
%UNTITLED2 Summary of this function goes here
%   the year is 1962 by default
start_h=input('input starting hour:');
year=input('input the year:');
hours=zeros(size(vdate));
numdate=zeros(size(vdate));
if nargin==2
    for i=1:size(vdate,1)
        if (vtime(i)<0)||(vtime(i)>2400)
            disp(['illegal time. i= ',num2str(i)])
            keyboard;
        end
        m=floor(vdate(i)/100);
        d=mod(vdate(i),100);
        hh=floor(vtime(i)/100);
        mm=mod(vtime(i),100);
        
        numdate(i)=datenum(year,m,d,hh,mm,0);         
    end
end

if nargin==3
    for i=1:size(vdate,1)
        m=floor(vdate(i)/100);
        d=mod(vdate(i),100);
        hh=vtime(i);           %vtime stands for hour when nargin is 3
        mm=vmin(i);
        
        numdate(i)=datenum(year,m,d,hh,mm,0);         
    end
end
hours(1)=start_h;
for i=2:size(vdate,1)
    hours(i)=hours(i-1)+(numdate(i)-numdate(i-1))*24;
end
end

