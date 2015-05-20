function r_qs=interp_qs(timehr,qs)
%对含沙量插值，也适于需要类似批量线性插值处理的数据，如：糙率在各断面上插值，制作初始文件时
%已知若干个水位在全河段插值
%首尾两端被插数据值必须给出
rows=size(qs,1);
cols=size(qs,2);

for k=1:cols  
    for i=1:rows
        if qs(i,k)==0
            x1=timehr(i-1);
            y1=qs(i-1,k);
            j=i+1;
            while qs(j,k)==0
                j=j+1;
            end
            x2=timehr(j);
            y2=qs(j,k);
            qs(i,k)=y1+(y2-y1)/(x2-x1)*(timehr(i)-x1);
        end
    end
end
r_qs=qs;