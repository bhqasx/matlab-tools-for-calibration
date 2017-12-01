function [x3,y31,y32]=MergeSeries(x1,y1,x2,y2)
%将两个（时间）序列的数据合到一个时间线上，x1y1是较短的序列
%x2应从小到大排列

x3=x2;
y31=y2;
%y32=zeros(size(y31));
y32=y2;

nx1=size(x1,1);
for i=1:1:nx1
    nx3=size(x3,1);    
    
    if x1(i)<x3(1)
        %plast=1;       %positon of the last inserted element
        x3_in=x1(i);
        y31_in=y31(1);
        y32_in=y1(i);
        
        %insert an element to the top
        x3=[x3_in;x3];
        y31=[y31_in;y31];
        y32=[y32_in;y32];
        
        continue;
    elseif x1(i)>x3(nx3)
        x3_in=x1(i);
        y31_in=y31(nx3);
        y32_in=y1(i);
        
        %insert an element to the bottom
        x3=[x3;x3_in];
        y31=[y31;y31_in];
        y32=[y32;y32_in];    
        
        continue;
    elseif x1(i)==x3(nx3)
        y32(nx3)=y1(i);
        continue;
    end
            
    for j=1:1:nx3-1
        if (x1(i)>x3(j))&&(x1(i)<x3(j+1))
            x3_in=x1(i);
            y31_in=y31(j)+(y31(j+1)-y31(j))/(x3(j+1)-x3(j))*(x1(i)-x3(j));
            y32_in=y1(i);
            
            %insert an element
            x3=[x3(1:j); x3_in; x3(j+1:end)];
            y31=[y31(1:j); y31_in; y31(j+1:end)];
            y32=[y32(1:j); y32_in; y32(j+1:end)];           
        elseif x1(i)==x3(j)
            y32(j)=y1(i);
        end
    end
end



           