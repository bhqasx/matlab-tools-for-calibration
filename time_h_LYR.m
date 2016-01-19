function hours = time_h_LYR(varargin)
%UNTITLED2 Summary of this function goes here
%   the year is 1962 by default
start_h=input('input starting hour:');
year=input('input the year:');
rows=size(varargin{1},1);
hours=zeros(rows,1);
numdate=zeros(rows,1);
%---------------------------------------------------------------
if nargin==1
    vv=varargin{1};
    if size(vv,2)~=4
        disp('need an array with 4 colums if there is only one input parameter');
        hours=0;
        return;
    else       
        for i=1:1:rows
            numdate(i)=datenum(year,vv(i,1),vv(i,2),vv(i,3),vv(i,4),0);
        end
    end
end
%---------------------------------------------------------------
if nargin==2
    vdate=varargin{1};
    vtime=varargin{2};
    
    for i=1:1:rows
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
%----------------------------------------------------------------
if nargin==3
    vdate=varargin{1};
    vhr=varargin{2};
    vmin=varargin{3};
    
    for i=1:1:rows
        m=floor(vdate(i)/100);
        d=mod(vdate(i),100);
        hh=vhr(i);           %vtime stands for hour when nargin is 3
        mm=vmin(i);
        
        numdate(i)=datenum(year,m,d,hh,mm,0);         
    end
end
%-----------------------------------------------------------------
if nargin==4
    vm=varargin{1};
    vd=varargin{2};
    vhr=varargin{3};
    vmin=varargin{4};
    
    for i=1:1:rows
        numdate(i)=datenum(year,vm(i),vd(i),vhr(i),vmin(i),0); 
    end
end

hours(1)=start_h;
for i=2:rows
    hours(i)=hours(i-1)+(numdate(i)-numdate(i-1))*24;
end
end

